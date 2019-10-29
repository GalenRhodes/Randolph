/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMDocument.m
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
#import "PGDOMDocument_Private.h"

@interface PGDOMNode()

    @property(nonatomic, nullable) PGDOMDocument *ownerDocument;

@end

@implementation PGDOMDocument {
    }

    @synthesize strictErrorChecking = _strictErrorChecking;
    @synthesize xmlStandalone = _xmlStandalone;
    @synthesize documentURI = _documentURI;
    @synthesize xmlVersion = _xmlVersion;
    @synthesize xmlEncoding = _xmlEncoding;
    @synthesize inputEncoding = _inputEncoding;
    @synthesize documentElement = _documentElement;
    @synthesize doctype = _doctype;

    -(instancetype)init {
        self = [super init];

        if(self) {
            self.strictErrorChecking = YES;
            self.xmlStandalone       = YES;
            self.xmlVersion          = @"1.0";
            self.xmlEncoding         = NSUTF8StringEncoding;
            self.inputEncoding       = NSUTF8StringEncoding;
        }

        return self;
    }

    -(PGDOMAttr *)createAttribute:(NSString *)value withName:(NSString *)name {
        return [[PGDOMAttr alloc] initWithOwnerDocument:self name:name value:value];
    }

    -(PGDOMAttr *)createAttribute:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        return [[PGDOMAttr alloc] initWithOwnerDocument:self qualifiedName:qualifiedName namespaceURI:namespaceURI value:value];
    }

    -(PGDOMElement *)createElement:(NSString *)tagName {
        return [[PGDOMElement alloc] initWithOwnerDocument:self tagName:tagName];
    }

    -(PGDOMElement *)createElement:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        return [[PGDOMElement alloc] initWithOwnerDocument:self qualifiedName:qualifiedName namespaceURI:namespaceURI];
    }

    -(PGDOMEntityReference *)createEntityReference:(NSString *)name {
        return [[PGDOMEntityReference alloc] initWithOwnerDocument:self entity:[PGDOMEntity new]];
    }

    -(PGDOMText *)createTextElement:(NSString *)textContent {
        return [[PGDOMText alloc] initWithOwnerDocument:self textData:textContent ?: @""];
    }

    -(PGDOMCData *)createCDataSection:(NSString *)textContent {
        return [[PGDOMCData alloc] initWithOwnerDocument:self textData:textContent ?: @""];
    }

    -(PGDOMComment *)createComment:(NSString *)textContent {
        return [[PGDOMComment alloc] initWithOwnerDocument:self textData:textContent ?: @""];
    }

    -(PGDOMProcessingInstruction *)createProcessingInstruction:(NSString *)target data:(NSString *)data {
        return [[PGDOMProcessingInstruction alloc] initWithOwnerDocument:self target:target data:data];
    }

    -(PGDOMNode *)adoptNode:(PGDOMNode *)node {
        node.ownerDocument = self;
        [node postNodeAdoptedUserDataNotification];
        return node;
    }

    -(PGDOMNode *)importNode:(PGDOMNode *)node deep:(BOOL)deep {
        return node;
    }

    -(PGDOMNode *)renameNode:(PGDOMNode *)node qualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        if([node isKindOfClass:PGDOMNamed.class]) return [((PGDOMNamed *)node) rename:qualifiedName namespaceURI:namespaceURI];
        @throw PGMakeDOMException(PGDOMErrorNotRenamable, PGF, PGDOMErrorMsgNotRenamable);
    }

    -(PGDOMNode *)renameNode:(PGDOMNode *)node nodeName:(NSString *)nodeName {
        if([node isKindOfClass:PGDOMNamed.class]) return [((PGDOMNamed *)node) rename:nodeName];
        @throw PGMakeDOMException(PGDOMErrorNotRenamable, PGF, PGDOMErrorMsgNotRenamable);
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeDocument;
    }

    -(NSString *)nodeName {
        return @"#document";
    }

@end
