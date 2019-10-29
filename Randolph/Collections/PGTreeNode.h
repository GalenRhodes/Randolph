/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTreeNode.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/28/19
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

#ifndef __RANDOLPH_PGTREENODE_H__
#define __RANDOLPH_PGTREENODE_H__

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma ide diagnostic ignored "err_statically_allocated_object"

@interface PGTreeNode<__covariant KeyType, __covariant ValueType> : NSObject

    @property(nonatomic, readonly, copy)/**/ KeyType                        key;
    @property(nonatomic)/*                */ ValueType                      value;
    @property(nonatomic, readonly)/*      */ BOOL                           isRed;
    @property(nonatomic, readonly, nullable) PGTreeNode<KeyType, ValueType> *parentNode;
    @property(nonatomic, readonly, nullable) PGTreeNode<KeyType, ValueType> *leftChild;
    @property(nonatomic, readonly, nullable) PGTreeNode<KeyType, ValueType> *rightChild;
    @property(nonatomic, readonly)/*      */ NSUInteger                     count;
    @property(nonatomic, readonly)/*      */ NSUInteger                     index;

    +(instancetype)nodeWithValue:(ValueType)value forKey:(KeyType<NSCopying>)key;

    -(NSUInteger)branchDepth;

    -(nullable PGTreeNode<KeyType, ValueType> *)nodeForKey:(KeyType)key;

    -(PGTreeNode<KeyType, ValueType> *)remove;

    -(PGTreeNode<KeyType, ValueType> *)insertValue:(ValueType)value forKey:(KeyType<NSCopying>)key;

    -(void)removeAll;

    -(void)removeAllWithAction:(void (^)(KeyType key, ValueType value))actionBlock;

    -(BOOL)doForEach:(BOOL (^)(KeyType key, ValueType value))block;

    -(PGTreeNode<KeyType, ValueType> *)nodeAtIndex:(NSUInteger)index;

@end

#pragma clang diagnostic pop

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGTREENODE_H__
