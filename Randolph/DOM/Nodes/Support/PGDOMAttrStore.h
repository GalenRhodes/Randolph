/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMAttrStore.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/3/19
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

#ifndef __RANDOLPH_PGDOMATTRSTORE_H__
#define __RANDOLPH_PGDOMATTRSTORE_H__

#import <Cocoa/Cocoa.h>

@class PGDOMAttr;

NS_ASSUME_NONNULL_BEGIN

@protocol PGDOMAttrStore<NSObject>

    -(nullable NSString *)attrValueWithName:(NSString *)name;

    -(nullable NSString *)attrValueWithLocalName:(NSString *)localName namespaceURI:(nullable NSString *)namespaceURI;

    -(nullable PGDOMAttr *)attrWithName:(NSString *)name;

    -(nullable PGDOMAttr *)attrWithLocalName:(NSString *)localName namespaceURI:(nullable NSString *)namespaceURI;

    -(BOOL)hasAttrWithName:(NSString *)name;

    -(BOOL)hasAttrWithLocalName:(NSString *)localName namespaceURI:(nullable NSString *)namespaceURI;

    -(void)removeAttrWithName:(NSString *)name;

    -(void)removeAttrWithLocalName:(NSString *)localName namespaceURI:(nullable NSString *)namespaceURI;

    -(nullable PGDOMAttr *)removeAttr:(PGDOMAttr *)attr;

    -(void)setAttrValue:(NSString *)value withName:(NSString *)name;

    -(void)setAttrValue:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

    -(nullable PGDOMAttr *)setAttr:(PGDOMAttr *)attr;

    -(void)setIdAttrValue:(NSString *)value withName:(NSString *)name;

    -(void)setIdAttrValue:(NSString *)value withQualifiedName:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

    -(nullable PGDOMAttr *)setIdAttr:(PGDOMAttr *)attr;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDOMATTRSTORE_H__
