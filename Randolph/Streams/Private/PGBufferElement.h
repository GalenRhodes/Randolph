/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGBufferElement.h
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

#ifndef __RANDOLPH_PGBUFFERELEMENT_H__
#define __RANDOLPH_PGBUFFERELEMENT_H__

#import <Cocoa/Cocoa.h>
#import <Randolph/PGTools.h>

@class PGByteBuffer;

NS_ASSUME_NONNULL_BEGIN

@interface PGBufferElement : NSObject

    @property(nonatomic, nullable)/*      */ PGBufferElement *next;
    @property(nonatomic, nullable)/*      */ PGBufferElement *prev;
    @property(nonatomic, nullable, weak)/**/ PGByteBuffer    *owner;
    @property(nonatomic, readonly)/*      */ NSUInteger      count;
    @property(nonatomic, nullable, copy)/**/ NSString        *name;
    @property(nonatomic, nullable, readonly) NSError         *lastError;
    @property(nonatomic, readonly)/*      */ BOOL            isAtEOF;

    -(instancetype)init NS_DESIGNATED_INITIALIZER;

    -(NSUInteger)getBytes:(pPGByte)buffer maxLength:(NSUInteger)maxLength error:(NSError **)error;

    -(NSInteger)getByte:(NSError **)error;

    +(instancetype)elementWithNSData:(NSData *)data;

    +(instancetype)elementWithBytes:(pPGByte)bytes length:(NSUInteger)length error:(NSError **)error;

    +(instancetype)elementWithBytesNoCopy:(pPGByte)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone error:(NSError **)error;

    +(instancetype)elementWithFileAtPath:(NSString *)path error:(NSError **)error;

    +(instancetype)elementWithBytesFromStream:(NSInputStream *)stream length:(NSUInteger)length error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGBUFFERELEMENT_H__
