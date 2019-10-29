/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMEntityReference.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/20/19
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

@implementation PGDOMEntityReference {
    }

    @synthesize entity = _entity;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument entity:(PGDOMEntity *)entity {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            _entity = entity;
        }

        return self;
    }

    -(NSString *)nodeName {
        return self.entity.nodeName;
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeEntityRef;
    }

    -(instancetype)copy:(BOOL)deep {
        return [super copy:NO];
    }

    -(NSString *)nodeValue {
        return self.entity.nodeValue;
    }

    -(void)setNodeValue:(NSString *)nodeValue {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(NSString *)textContent {
        return self.entity.textContent;
    }

    -(void)setTextContent:(NSString *)textContent {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)firstChild {
        return self.entity.firstChild;
    }

    -(PGDOMNode *)lastChild {
        return self.entity.lastChild;
    }

    -(BOOL)hasChildNodes {
        return self.entity.hasChildNodes;
    }

    -(PGDOMNodeList *)childNodes {
        return self.entity.childNodes;
    }

    -(PGDOMNode *)addChildNode:(PGDOMNode *)newNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)insertChildNode:(PGDOMNode *)newNode beforeNode:(PGDOMNode *)refNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)replaceChildNode:(PGDOMNode *)oldNode withNode:(PGDOMNode *)newNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)removeChildNode:(PGDOMNode *)node {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMEntityReference *copy = (PGDOMEntityReference *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_entity = _entity;
        }

        return copy;
    }

    -(void)synchronizeChildren {
        [self.entity synchronizeChildren];
    }

    -(void)cloneChildrenTo:(PGDOMParent *)node {
    }

    -(void)removeAllChildren {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

@end
