/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMElement.m
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

#import "PGTreeNode.h"
#import "PGDOMPrivate.h"
#import "PGDOMNamedKey.h"

@interface PGDOMElement()

    @property(nonatomic, nullable) AttrTNode attribs;

    -(nullable AttrTNode)attrNodeWithName:(NSString *)name;

    -(nullable AttrTNode)attrNodeWithLocalName:(NSString *)localName namespaceURI:(nullable NSString *)namespaceURI;

    -(nullable AttrTNode)attrNodeForKey:(NamedKey)key;

    -(nullable PGDOMAttr *)setAttrNode:(PGDOMAttr *)attr;

    -(nullable PGDOMAttr *)removeAttrNode:(AttrTNode)tnode;

@end

@implementation PGDOMElement {
    }

    @synthesize attribs = _attribs;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument tagName:(NSString *)tagName {
        return (self = [super initWithOwnerDocument:ownerDocument nodeName:tagName]);
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument qualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        return (self = [super initWithOwnerDocument:ownerDocument qualifiedName:qualifiedName namespaceURI:namespaceURI]);
    }

    -(PGDOMNodeList *)elementsWithTagName:(NSString *)tagName {
        return [PGDOMNodeList new];
    }

    -(PGDOMNodeList *)elementsWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        return [PGDOMNodeList new];
    }

    -(NSString *)tagName {
        return self.nodeName;
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeElement;
    }

    -(nullable NSString *)attrValueWithName:(NSString *)name {
        [self lock];
        @try { return [self attrWithName:name].value; }
        @finally { [self unlock]; }
    }

    -(nullable NSString *)attrValueWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { return [self attrWithLocalName:localName namespaceURI:namespaceURI].value; }
        @finally { [self unlock]; }
    }

    -(nullable PGDOMAttr *)attrWithName:(NSString *)name {
        [self lock];
        @try { return [self attrNodeWithName:name].value; }
        @finally { [self unlock]; }
    }

    -(nullable PGDOMAttr *)attrWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { return [self attrNodeWithLocalName:localName namespaceURI:namespaceURI].value; }
        @finally { [self unlock]; }
    }

    -(BOOL)hasAttrWithName:(NSString *)name {
        [self lock];
        @try { return ([self attrNodeWithName:name] != nil); }
        @finally { [self unlock]; }
    }

    -(BOOL)hasAttrWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { return ([self attrNodeWithLocalName:localName namespaceURI:namespaceURI] != nil); }
        @finally { [self unlock]; }
    }

    -(void)removeAttrWithName:(NSString *)name {
        [self lock];
        @try { [self removeAttrNode:[self attrNodeWithName:name]]; }
        @finally { [self unlock]; }
    }

    -(void)removeAttrWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { [self removeAttrNode:[self attrNodeWithLocalName:localName namespaceURI:namespaceURI]]; }
        @finally { [self unlock]; }
    }

    -(nullable PGDOMAttr *)removeAttr:(PGDOMAttr *)attr {
        [self lock];
        @try {
            if(self != attr.ownerElement) @throw PGMakeDOMException(PGDOMErrorHierarchy, PGF, PGDOMErrorMsgAttribNotFound);
            AttrTNode tnode = [self attrNodeForKey:[PGDOMNamedKey keyWithNode:attr]];
            return [self removeAttrNode:tnode];
        }
        @finally { [self unlock]; }
    }

    -(void)setAttrValue:(NSString *)value withName:(NSString *)name {
        [self lock];
        @try { [self setAttrNode:[self.ownerDocument createAttribute:value withName:name]]; }
        @finally { [self unlock]; }
    }

    -(void)setAttrValue:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { [self setAttrNode:[self.ownerDocument createAttribute:value withQualifiedName:qualifiedName namespaceURI:namespaceURI]]; }
        @finally { [self unlock]; }
    }

    -(nullable PGDOMAttr *)setAttr:(PGDOMAttr *)attr {
        [self lock];
        @try {
            if(self == attr.ownerElement) return attr;
            if(attr.ownerElement) @throw PGMakeDOMException(PGDOMErrorAttribInUse, PGF, PGDOMErrorMsgAttribInUse);
            if(self.ownerDocument != attr.ownerDocument) @throw PGMakeDOMException(PGDOMErrorWrongDocument, PGF, PGDOMErrorMsgAttribWrongDocument);
            return [self setAttrNode:attr];
        }
        @finally { [self unlock]; }
    }

    -(void)setIdAttrValue:(NSString *)value withName:(NSString *)name {
        [self setIdAttr:[self.ownerDocument createAttribute:value withName:name]];
    }

    -(void)setIdAttrValue:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        [self setIdAttr:[self.ownerDocument createAttribute:value withQualifiedName:qualifiedName namespaceURI:namespaceURI]];
    }

    -(nullable PGDOMAttr *)setIdAttr:(PGDOMAttr *)attr {
        [self lock];
        @try {
            PGDOMAttr *old = [self setAttrNode:attr];
            attr.isID = YES;
            [self postAttributeChangeNotification:AttribEventIsID attr:attr];
            return old;
        }
        @finally { [self unlock]; }
    }

    -(AttrTNode)attrNodeWithName:(NSString *)name {
        return [self attrNodeForKey:[PGDOMNamedKey keyWithName:name]];
    }

    -(AttrTNode)attrNodeWithLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        return [self attrNodeForKey:[PGDOMNamedKey keyWithName:localName namespaceURI:namespaceURI]];
    }

    -(AttrTNode)attrNodeForKey:(NamedKey)key {
        PGDOMSyncAttribs;
        return [_attribs nodeForKey:key];
    }

    -(PGDOMAttr *)setAttrNode:(PGDOMAttr *)attr {
        PGDOMSyncAttribs;
        if(attr) {
            NamedKey key = [PGDOMNamedKey keyWithNode:attr];

            if(_attribs) {
                AttrTNode tnode = [self attrNodeForKey:key];

                if(tnode) {
                    PGDOMAttr *old = tnode.value;
                    tnode.value = attr;
                    [self postAttributeChangeNotification:AttribEventRemove attr:old];
                    [self postAttributeChangeNotification:AttribEventAdd attr:attr];
                    return old;
                }
                else {
                    _attribs = [_attribs insertValue:attr forKey:key];
                    [self postAttributeChangeNotification:AttribEventAdd attr:attr];
                }
            }
            else {
                _attribs = [PGTreeNode nodeWithValue:attr forKey:key];
                [self postAttributeChangeNotification:AttribEventAdd attr:attr];
            }
        }
        return nil;
    }

    -(PGDOMAttr *)removeAttrNode:(AttrTNode)tnode {
        if(tnode) {
            PGDOMSyncAttribs;
            PGDOMAttr *attr = tnode.value;
            _attribs = [tnode remove];
            [self postAttributeChangeNotification:AttribEventRemove attr:attr];
            return attr;
        }
        return nil;
    }

    -(void)postAttributeChangeNotification:(PGDOMAttribEventName)change attr:(PGDOMAttr *)attr {
        if(attr) [PGNotificationCenter() postNotificationName:PGDOMElementAttribsDidChange object:self userInfo:@{
                PGDOMAttribEventNameKey: change, PGDOMAttribEventNodeKey: attr
        }];
    }

    -(void)synchronizeAttributes {
        self.needsSyncAttribs = NO;
    }

    -(BOOL)needsSyncAttribs {
        return [self hasFlag:PGDOMIntFlag_SyncAttribs];
    }

    -(void)setNeedsSyncAttribs:(BOOL)flag {
        [self setFlag:PGDOMIntFlag_SyncAttribs value:flag];
    }


@end
