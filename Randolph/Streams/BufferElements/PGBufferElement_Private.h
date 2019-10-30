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

#import "PGBufferElement.h"
#import "PGByteBufferElement.h"
#import "PGURLBufferElement.h"

@interface PGBufferElement()

    @property(nonatomic) NSUInteger count;
    @property(nonatomic) NSError    *lastError;

    -(void)setError:(NSError *)error error:(NSError **)pError;

@end

@interface PGByteBufferElement()

    @property(nonatomic) NSData *buffer;

@end

@interface PGURLBufferElement()

    @property(nonatomic, readonly)/*      */ BOOL                 isCompleted;
    @property(nonatomic, readonly)/*      */ BOOL                 isStatusSuccess;
    @property(nonatomic, nullable, readonly) NSURLSessionDataTask *urlTask;
    @property(nonatomic, nullable, readonly) NSHTTPURLResponse    *urlTaskResponse;
    @property(nonatomic, nullable, readonly) NSMutableData        *dataBuild;
    @property(nonatomic, nullable, readonly) NSURLSession         *urlSession;

    +(NSURLSessionConfiguration *)backgroundSessionConfiguration;

    -(NSURLSessionDataTask *)taskForURL:(NSString *)url;

@end

#endif // __PGBufferElement_Private_h__
