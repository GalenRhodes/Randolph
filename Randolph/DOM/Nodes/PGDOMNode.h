/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNode.h
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

#ifndef __RANDOLPH_PGDOMNODE_H__
#define __RANDOLPH_PGDOMNODE_H__

#import <Randolph/PGDOMTools.h>
#import <Randolph/PGDOMUserDataHandler.h>

@class PGDOMNamedNodeMap;
@class PGDOMNodeList;
@class PGDOMDocument;

NS_ASSUME_NONNULL_BEGIN

@interface PGDOMNode : NSObject<NSCopying>

    @property(nonatomic, readonly)/*            */ PGDOMNodeType     nodeType;
    @property(nonatomic, readonly, copy)/*      */ NSString          *nodeName;
    @property(nonatomic, readonly, nullable, copy) NSString          *localName;
    @property(nonatomic, readonly, nullable, copy) NSString          *namespaceURI;
    @property(nonatomic, nullable, copy)/*      */ NSString          *prefix;
    @property(nonatomic, nullable, copy)/*      */ NSString          *nodeValue;
    @property(nonatomic, nullable, copy)/*      */ NSString          *textContent;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMNode         *parentNode;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMNode         *nextSibling;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMNode         *prevSibling;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMNode         *firstChild;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMNode         *lastChild;
    @property(nonatomic, readonly, nullable)/*  */ PGDOMDocument     *ownerDocument;
    @property(nonatomic, readonly)/*            */ BOOL              hasAttributes;
    @property(nonatomic, readonly)/*            */ BOOL              hasChildNodes;
    @property(nonatomic, readonly)/*            */ BOOL              hasNamespace;
    @property(nonatomic, readonly)/*            */ PGDOMNamedNodeMap *attributes;
    @property(nonatomic, readonly)/*            */ PGDOMNodeList     *childNodes;

    -(PGDOMNode *)addChildNode:(PGDOMNode *)newNode;

    -(PGDOMNode *)insertChildNode:(PGDOMNode *)newNode beforeNode:(nullable PGDOMNode *)refNode;

    -(PGDOMNode *)replaceChildNode:(PGDOMNode *)oldNode withNode:(PGDOMNode *)newNode;

    -(PGDOMNode *)removeChildNode:(PGDOMNode *)node;

    -(void)normalize;

    -(id)setUserData:(nullable id)data forKey:(NSString *)key;

    -(id)setUserData:(nullable id)data forKey:(NSString *)key handler:(nullable id<PGDOMUserDataHandler>)handler;

    -(id)setUserData:(nullable id)data forKey:(NSString *)key handlerBlock:(nullable PGDOMUserDataHandlerBlock)block;

    -(id)userData:(NSString *)key;

    -(instancetype)copyWithZone:(nullable NSZone *)zone;

    -(instancetype)copy;

    -(instancetype)copy:(BOOL)deep;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDOMNODE_H__
