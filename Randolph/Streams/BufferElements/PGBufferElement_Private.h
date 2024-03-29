/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGBufferElement_Private.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/26/19
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

#ifndef __PGBufferElement_Private_h__
#define __PGBufferElement_Private_h__

#import <Randolph/PGByteBuffer.h>
#import <Randolph/PGBufferElement.h>
#import <Randolph/PGByteBufferElement.h>
#import <Randolph/PGURLBufferElement.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGBufferElement()

    @property(nonatomic) NSUInteger count;
    @property(nonatomic) NSError    *lastError;

    -(void)setError:(nullable NSError *)error error:(NSError **)pError;

@end

@interface PGByteBufferElement()

    @property(nonatomic) NSData *buffer;

@end

@interface PGURLBufferElement()

@end

NS_ASSUME_NONNULL_END

#endif // __PGBufferElement_Private_h__
