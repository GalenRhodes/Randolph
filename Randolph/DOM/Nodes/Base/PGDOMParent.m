/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMParent.m
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

@interface PGDOMNode()

    @property(nonatomic, nullable) PGDOMNode *parentNode;
    @property(nonatomic, nullable) PGDOMNode *nextSibling;
    @property(nonatomic, nullable) PGDOMNode *prevSibling;

@end

@implementation PGDOMParent {
        PGDOMNode       *_firstChild;
        PGDOMNode       *_lastChild;
        NSString        *_textContent;
        PGDOMNodeList   *_childNodes;
        NSRecursiveLock *_lock;
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            _lock = [NSRecursiveLock new];
        }

        return self;
    }

    -(void)synchronizeChildren {
        [super synchronizeChildren];
    }

    -(instancetype)copy:(BOOL)deep {
        [self lock];
        @try {
            PGDOMParent *copy = (PGDOMParent *)[super copy:deep];
            if(copy && deep) [self cloneChildrenTo:copy];
            return copy;
        }
        @finally { [self unlock]; }
    }

    -(void)cloneChildrenTo:(PGDOMParent *)node {
        PGDOMSyncChildren;
        PGDOMNode *myChild = _firstChild;

        while(myChild) {
            [node addChildNode:[myChild copy:YES]];
            myChild = myChild.nextSibling;
        }
    }

    -(void)dealloc {
        [self removeAllChildren];
    }

    -(void)lock {
        [_lock lock];
    }

    -(void)unlock {
        [_lock unlock];
    }

    -(PGDOMNode *)firstChild {
        [self lock];
        @try {
            PGDOMSyncChildren;
            return _firstChild;
        }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)lastChild {
        [self lock];
        @try {
            PGDOMSyncChildren;
            return _lastChild;
        }
        @finally { [self unlock]; }
    }

    -(BOOL)hasChildNodes {
        [self lock];
        @try {
            PGDOMSyncChildren;
            return (_firstChild != nil);
        }
        @finally { [self unlock]; }
    }

    -(PGDOMNodeList *)childNodes {
        [self lock];
        @try {
            PGDOMSyncChildren;
            if(!_childNodes) _childNodes = [PGDOMNodeList listWithParentNode:self];
            return self->_childNodes;
        }
        @finally { [self unlock]; }
    }

    -(NSString *)textContent {
        [self lock];
        @try {
            PGDOMSyncChildren;
            if(!_textContent) {
                NSMutableString *str  = [NSMutableString new];
                PGDOMNode       *node = _firstChild;

                while(node) {
                    [str appendString:node.textContent];
                    node = node.nextSibling;
                }

                _textContent = str.copy;
            }
        }
        @finally { [self unlock]; }

        return _textContent;
    }

    -(void)setTextContent:(NSString *)textContent {
        [self lock];
        @try {
            PGDOMSyncChildren;
            [self _removeAllChildren];
            [self _insertChildNode:[self.ownerDocument createTextElement:textContent] refNode:nil];
        }
        @finally {
            [self unlock];
            [self nodeHierarchyChanged];
        }
    }

    -(NSString *)nodeValue {
        return self.textContent;
    }

    -(void)setNodeValue:(NSString *)nodeValue {
        self.textContent = nodeValue;
    }

    -(PGDOMNode *)addChildNode:(PGDOMNode *)newNode {
        return [self insertChildNode:newNode beforeNode:nil];
    }

    -(PGDOMNode *)insertChildNode:(PGDOMNode *)newNode beforeNode:(PGDOMNode *)refNode {
        if(newNode && [newNode isInstanceOf:PGDOMChild.class]) {
            [self lock];
            @try {
                PGDOMSyncChildren;
                if(refNode && (self != refNode.parentNode)) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgNodeNotChild, PGDOMDescReference);
                [self validateNewChildNode:newNode];
                [self _insertChildNode:newNode refNode:refNode];
            }
            @finally {
                [self unlock];
                [self nodeHierarchyChanged];
            }
        }

        return newNode;
    }

    -(PGDOMNode *)replaceChildNode:(PGDOMNode *)oldNode withNode:(PGDOMNode *)newNode {
        if(newNode && oldNode && [newNode isInstanceOf:PGDOMChild.class]) {
            [self lock];
            @try {
                PGDOMSyncChildren;
                if(self != oldNode.parentNode) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgNodeNotChild, PGDOMDescNodeToReplace);
                [self validateNewChildNode:newNode];
                [self _replaceChildNode:oldNode withNode:newNode];
            }
            @finally {
                [self unlock];
                [self nodeHierarchyChanged];
            }
        }
        else if(oldNode) {
            [self removeChildNode:oldNode];
        }
        else if(newNode) {
            @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgNodeNull, PGDOMDescNodeToReplace);
        }

        return oldNode;
    }

    -(PGDOMNode *)removeChildNode:(PGDOMNode *)node {
        if(node) {
            [self lock];
            @try {
                PGDOMSyncChildren;
                if(self != node.parentNode) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgNodeNotChild, PGDOMDescNodeToRemove);
                [self _removeChildNode:node];
            }
            @finally {
                [self unlock];
                [self nodeHierarchyChanged];
            }
        }

        return node;
    }

    -(void)removeAllChildren {
        [self lock];
        @try {
            PGDOMSyncChildren;
            [self _removeAllChildren];
        }
        @finally {
            [self unlock];
            [self nodeHierarchyChanged];
        }
    }

    -(void)validateNewChildNode:(PGDOMNode *)newNode {
        if(self.ownerDocument != newNode.ownerDocument) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgWrongDocument, PGDOMDescNewNode);
        PGDOMNode *p = self;
        do {
            if(newNode == p) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGDOMErrorMsgChildIsParent, PGDOMDescNewNode);
            p = p.parentNode;
        }
        while(p);
    }

    -(void)nodeHierarchyChanged {
        @try {
            _textContent = nil;
            [PGNotificationCenter() postNotificationName:PGDOMNodeHierarchyDidChange object:self];
            [super nodeHierarchyChanged];
        }
        @catch(NSException *e) {
            /* Ignore */
        }
    }

    -(void)_adjustIfEndNode:(PGDOMNode *)newNode {
        /*@f:0*/if(newNode.nextSibling) newNode.nextSibling.prevSibling = newNode; else _lastChild = newNode;/*@f:1*/
        /*@f:0*/if(newNode.prevSibling) newNode.prevSibling.nextSibling = newNode; else _firstChild = newNode;/*@f:1*/
    }

    -(void)_insertChildNode:(PGDOMNode *)newNode refNode:(PGDOMNode *)refNode {
        [newNode.parentNode removeChildNode:newNode];

        newNode.parentNode  = self;
        newNode.nextSibling = refNode;
        newNode.prevSibling = (refNode ? refNode.prevSibling : _lastChild);

        [self _adjustIfEndNode:newNode];
    }

    -(void)_removeChildNode:(PGDOMNode *)node {
        /*@f:0*/if(node.prevSibling) node.prevSibling.nextSibling = node.prevSibling; else _firstChild = node.nextSibling;/*@f:1*/
        /*@f:0*/if(node.nextSibling) node.nextSibling.prevSibling = node.nextSibling; else _lastChild = node.prevSibling;/*@f:1*/
        node.prevSibling = nil;
        node.nextSibling = nil;
        node.parentNode  = nil;
    }

    -(void)_removeAllChildren {
        PGDOMNode *node = _firstChild, *next;

        while(node) {
            next = node.nextSibling;
            node.parentNode  = nil;
            node.nextSibling = nil;
            node.prevSibling = nil;
            node = next;
        }

        _firstChild = _lastChild = nil;
    }

    -(void)_replaceChildNode:(PGDOMNode *)oldNode withNode:(PGDOMNode *)newNode {
        [newNode.parentNode removeChildNode:newNode];

        newNode.parentNode  = self;
        newNode.prevSibling = oldNode.prevSibling;
        newNode.nextSibling = oldNode.nextSibling;
        oldNode.prevSibling = nil;
        oldNode.nextSibling = nil;
        oldNode.parentNode  = nil;

        [self _adjustIfEndNode:newNode];
    }

@end
