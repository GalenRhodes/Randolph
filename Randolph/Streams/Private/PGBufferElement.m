/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGBufferElement.m
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

#import "PGBufferElement_Private.h"

@implementation PGBufferElement {
    }

    @synthesize next = _next;
    @synthesize prev = _prev;
    @synthesize owner = _owner;
    @synthesize name = _name;
    @synthesize lastError = _lastError;
    @synthesize count = _count;

    -(instancetype)init {
        self = [super init];
        return self;
    }

    -(NSUInteger)getBytes:(pPGByte)buffer maxLength:(NSUInteger)maxLength error:(NSError **)error {
        return 0;
    }

    -(NSInteger)getByte:(NSError **)error {
        return 0;
    }

    -(void)setError:(NSError *)error error:(NSError **)pError {
        if(pError) *pError = error;
        _lastError = error;
    }

    -(BOOL)isAtEOF {
        return YES;
    }

    +(instancetype)elementWithNSData:(NSData *)data {
        return [[PGByteBufferElement alloc] initWithNSData:data];
    }

    +(instancetype)elementWithBytes:(pPGByte)bytes length:(NSUInteger)length error:(NSError **)error {
        return [[PGByteBufferElement alloc] initWithBytes:bytes length:length error:error];
    }

    +(instancetype)elementWithBytesNoCopy:(pPGByte)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone error:(NSError **)error {
        return [[PGByteBufferElement alloc] initWithBytesNoCopy:bytes length:length freeWhenDone:freeWhenDone error:error];
    }

    +(instancetype)elementWithFileAtPath:(NSString *)path error:(NSError **)error {
        return [[PGByteBufferElement alloc] initWithFileAtPath:path error:error];
    }

    +(instancetype)elementWithBytesFromStream:(NSInputStream *)stream length:(NSUInteger)length error:(NSError **)error {
        return [[PGByteBufferElement alloc] initWithBytesFromStream:stream length:length error:error];
    }

@end
