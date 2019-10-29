/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMDocument.h
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

#ifndef __RANDOLPH_PGDOMDOCUMENT_H__
#define __RANDOLPH_PGDOMDOCUMENT_H__

#import <Randolph/PGDOMNode.h>
#import <Randolph/PGDOMNonChildParent.h>

@class PGDOMText;
@class PGDOMComment;
@class PGDOMCData;
@class PGDOMProcessingInstruction;
@class PGDOMDocumentType;
@class PGDOMAttr;
@class PGDOMElement;
@class PGDOMEntityReference;

NS_ASSUME_NONNULL_BEGIN

@interface PGDOMDocument : PGDOMNonChildParent

    @property(nonatomic)/*                */ BOOL              strictErrorChecking;
    @property(nonatomic)/*                */ BOOL              xmlStandalone;
    @property(nonatomic, copy, nullable)/**/ NSString          *documentURI;
    @property(nonatomic, copy)/*          */ NSString          *xmlVersion;
    @property(nonatomic, readonly)/*      */ NSStringEncoding  xmlEncoding;
    @property(nonatomic, readonly)/*      */ NSStringEncoding  inputEncoding;
    @property(nonatomic, readonly, nullable) PGDOMElement      *documentElement;
    @property(nonatomic, readonly, nullable) PGDOMDocumentType *doctype;

    -(PGDOMAttr *)createAttribute:(NSString *)value withName:(NSString *)name;

    -(PGDOMAttr *)createAttribute:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

    -(PGDOMElement *)createElement:(NSString *)tagName;

    -(PGDOMElement *)createElement:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

    -(PGDOMEntityReference *)createEntityReference:(NSString *)name;

    -(PGDOMText *)createTextElement:(NSString *)textContent;

    -(PGDOMCData *)createCDataSection:(NSString *)textContent;

    -(PGDOMComment *)createComment:(NSString *)textContent;

    -(PGDOMProcessingInstruction *)createProcessingInstruction:(NSString *)target data:(NSString *)data;

    -(PGDOMNode *)adoptNode:(PGDOMNode *)node;

    -(PGDOMNode *)importNode:(PGDOMNode *)node deep:(BOOL)deep;

    -(PGDOMNode *)renameNode:(PGDOMNode *)node nodeName:(NSString *)nodeName;

    -(PGDOMNode *)renameNode:(PGDOMNode *)node qualifiedName:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDOMDOCUMENT_H__
