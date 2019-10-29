/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMText.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/17/19
 *
 * Copyright © 2019 ProjectGalen. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//************************************************************************/

#import "PGDOMPrivate.h"

BOOL getWholeText(BOOL forward, PGDOMNode *node, NSMutableString *buffer, PGDOMNode *parent);

PGDOMText *replaceWholeText(PGDOMText *node, NSString *content);

@implementation PGDOMText {
        NSMutableString *_buffer;
        dispatch_once_t _bufferFlag;
    }

    @synthesize isElementContentWhitespace = _isElementContentWhitespace;

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeText;
    }

    -(NSString *)nodeName {
        return @"#text";
    }

    -(NSString *)wholeText {
        PGDOMSyncData;
        dispatch_once(&self->_bufferFlag, ^{ self->_buffer = [NSMutableString new]; });

        @synchronized(_buffer) {
            [((PGDOMParent *)self.parentNode) lock];
            @try {
                [_buffer appendString:self.textData];
                getWholeText(NO, self.prevSibling, _buffer, self.parentNode);
                getWholeText(YES, self.nextSibling, _buffer, self.parentNode);
                return _buffer.copy;
            }
            @finally { [((PGDOMParent *)self.parentNode) unlock]; }
        }
    }

    -(PGDOMText *)replaceWholeText:(NSString *)content {
        PGDOMSyncData;
        [((PGDOMParent *)self.parentNode) lock];
        @try {
            if(content.length) return replaceWholeText(self, content);
            [self.parentNode removeChildNode:self];
        }
        @finally { [((PGDOMParent *)self.parentNode) unlock]; }
        return nil;
    }

    -(PGDOMText *)splitText:(NSUInteger)offset {
        PGDOMSyncData;
        PGDOMReadOnly;

        [((PGDOMParent *)self.parentNode) lock];
        @try {
            NSString   *s = self.textData;
            NSUInteger sl = s.length;

            if(offset > sl) @throw PGMakeRangeException(offset, sl);

            NSString  *newStr  = ((offset == sl) ? @"" : [s substringWithRange:NSMakeRange(offset, (sl - offset))]);
            PGDOMText *newText = [(PGDOMText *)[[self class] alloc] initWithOwnerDocument:self.ownerDocument textData:newStr];

            self.textData = [s substringWithRange:NSMakeRange(0, offset)];
            [self.parentNode insertChildNode:newText beforeNode:self.nextSibling];
            return newText;
        }
        @finally { [((PGDOMParent *)self.parentNode) unlock]; }
    }


@end

BOOL canModify(BOOL next, PGDOMNode *node) {
    BOOL textChild = NO;

    PGDOMNode *sibling = getSibling(next, node);

    while(sibling) {
        if(nodeIsEntityRef(sibling)) {
            PGDOMNode *child = getChild(next, sibling);

            if(!child) return NO;

            do {
                BOOL a = nodeIsText(child), b = nodeIsEntityRef(child), c = canModify(next, child);
                if(a || (b && c)) textChild = YES; else return (b ? NO : !textChild);
                child = getSibling(next, child);
            }
            while(child);
        }
        else if(!nodeIsText(sibling)) return YES;

        sibling = getSibling(next, sibling);
    }

    return YES;
}

BOOL hasTextOnlyChildren(PGDOMNode *node) {
    if(!node) return NO;
    node = node.firstChild;
    while(node) { if(nodeIsEntityRef(node)) return hasTextOnlyChildren(node); else if(!nodeIsText(node)) return NO; else node = node.nextSibling; }
    return YES;
}

PGDOMText *removeTextSiblings(BOOL next, PGDOMText *node) {
    PGDOMNode *parent  = node.parentNode;
    PGDOMNode *sibling = getSibling(next, node);

    while(sibling) {
        if(nodeIsText(sibling) || (nodeIsEntityRef(sibling) && hasTextOnlyChildren(sibling))) {
            [parent removeChildNode:sibling];
            sibling = getSibling(next, node);
        }
        else return node;
    }

    return node;
}

void addTextFromNode(BOOL forward, PGDOMNode *node, NSMutableString *buffer) {
    NSString *str = ((PGDOMText *)node).textData.nilIfEmpty;
    if(str) {
        if(forward) [buffer appendString:str]; else [buffer insertString:str atIndex:0];
    }
}

PGDOMText *replaceNodeContent(PGDOMText *node, NSString *content) {
    if(node.isReadOnly) {
        PGDOMText *currentNode = [node.ownerDocument createTextElement:content];
        [node.parentNode insertChildNode:currentNode beforeNode:node];
        [node.parentNode removeChildNode:node];
        return currentNode;
    }
    else {
        node.textData = content;
        return node;
    }
}

BOOL canModifyNode(PGDOMNode *node) {
    return (canModify(NO, node) && canModify(YES, node));
}

PGDOMText *removeAdjacentText(PGDOMText *node) {
    return removeTextSiblings(NO, removeTextSiblings(YES, node));
}

PGDOMText *replaceWholeText(PGDOMText *node, NSString *content) {
    if(node.ownerDocument.strictErrorChecking && !canModifyNode(node)) @throw PGMakeDOMException(PGDOMErrorNoModificationAllowed, PGF, PGDOMErrorMsgNoModificationAllowed);
    return removeAdjacentText(replaceNodeContent(node, content));
}

BOOL getWholeText(BOOL forward, PGDOMNode *node, NSMutableString *buffer, PGDOMNode *parent) {
    BOOL inEntRef = nodeIsEntityRef(parent);

    while(node) {
        if(nodeIsText(node)) addTextFromNode(forward, node, buffer);
        else if(!nodeIsEntityRef(node) || getWholeText(forward, getChild(forward, node), buffer, node)) return YES;
        node = getSibling(forward, node);
    }

    if(inEntRef) {
        getWholeText(forward, getSibling(forward, parent), buffer, parent.parentNode);
        return YES;
    }

    return NO;
}


