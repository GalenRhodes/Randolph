/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGByteBufferElement.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/24/19
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

#ifndef __RANDOLPH_PGBYTEBUFFERELEMENT_H__
#define __RANDOLPH_PGBYTEBUFFERELEMENT_H__

#import <Randolph/PGBufferElement.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGByteBufferElement : PGBufferElement

    @property(nonatomic, readonly) NSData     *buffer;
    @property(nonatomic, readonly) NSUInteger readPointer;

    /************************************************************************//**
     * Creates an empty buffer with nothing in it.
     *
     * @return An empty buffer with nothing in it.
     */
    -(instancetype)init NS_DESIGNATED_INITIALIZER;

    -(instancetype)initWithNSData:(NSData *)data NS_DESIGNATED_INITIALIZER;

    -(instancetype)initWithBytes:(pPGByte)bytes length:(NSUInteger)length error:(NSError **)error NS_DESIGNATED_INITIALIZER;

    -(instancetype)initWithBytesNoCopy:(pPGByte)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone error:(NSError **)error NS_DESIGNATED_INITIALIZER;

    -(instancetype)initWithFileAtPath:(NSString *)path error:(NSError **)error NS_DESIGNATED_INITIALIZER;

    -(instancetype)initWithBytesFromStream:(NSInputStream *)stream length:(NSUInteger)length error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGBYTEBUFFERELEMENT_H__
