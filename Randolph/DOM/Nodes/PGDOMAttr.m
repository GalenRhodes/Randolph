/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMAttribute.m
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

@implementation PGDOMAttr {
    }

    @synthesize value = _value;
    @synthesize ownerElement = _ownerElement;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)document name:(NSString *)name value:(NSString *)value {
        self = [super initWithOwnerDocument:document nodeName:name];

        if(self) {
            self.value = (value ?: @"");
        }

        return self;
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)document qualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI value:(NSString *)value {
        self = [super initWithOwnerDocument:document qualifiedName:qualifiedName namespaceURI:namespaceURI];

        if(self) {
            self.value = (value ?: @"");
        }

        return self;
    }

    -(instancetype)copy:(BOOL)deep {
        return (PGDOMAttr *)[super copy:YES];
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeAttribute;
    }

    -(BOOL)isID {
        return [self hasFlag:PGDOMIntFlag_IDAttribute];
    }

    -(void)setIsID:(BOOL)value {
        [self setFlag:PGDOMIntFlag_IDAttribute value:value];
    }

    -(BOOL)isSpecified {
        return [self hasFlag:PGDOMIntFlag_Specified];
    }

    -(void)setIsSpecified:(BOOL)value {
        [self setFlag:PGDOMIntFlag_Specified value:value];
    }

    -(PGDOMNode *)parentNode {
        return nil;
    }

    -(PGDOMNode *)nextSibling {
        return nil;
    }

    -(PGDOMNode *)prevSibling {
        return nil;
    }

    -(void)setParentNode:(PGDOMNode *)parentNode {
    }

    -(void)setNextSibling:(PGDOMNode *)nextSibling {
    }

    -(void)setPrevSibling:(PGDOMNode *)prevSibling {
    }

    -(void)synchronizeChildren {
        [super synchronizeChildren];
    }

    -(void)nodeHierarchyChanged {
        [super nodeHierarchyChanged];
    }

    -(PGDOMNamed *)renameWithBlock:(RenameAction)block {
        PGDOMElement *elem = self.ownerElement;

        if(elem) {
            if(elem.isReadOnly) @throw PGMakeDOMException(PGDOMErrorNotRenamable, PGF, PGDOMErrorMsgNotRenamable);
            [elem removeAttr:self];
        }

        if(self.isReadOnly) {
            PGDOMAttr *copy = (PGDOMAttr *)block([self copy:YES]);
            if(elem) [elem setAttr:copy];
            return copy;
        }
        else {
            block(self);
            if(elem) [elem setAttr:self];
            return nil;
        }
    }

@end
