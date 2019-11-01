/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGURLBufferElement.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/27/19
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
#import "PGSemaphore.h"

const NSInteger PGForceDownloadThreshold = 134217728; // 128MB threshold

@interface PGURLBufferElement()

    @property(nonatomic)/*      */ NSUInteger      writePointer;
    @property(nonatomic)/*      */ NSUInteger      readPointer;
    @property(nonatomic, readonly) NSMutableData   *dataBuild;
    @property(nonatomic, readonly) NSRecursiveLock *lock;
    @property(nonatomic, readonly) PGSemaphore     *semaphore;
    @property(nonatomic, readonly) NSThread        *readerThread;
    @property(nonatomic, readonly) NSInputStream   *inputStream;
@end

@implementation PGURLBufferElement {
    }

    @synthesize isCompleted = _isCompleted;
    @synthesize isStatusSuccess = _isStatusSuccess;
    @synthesize forceDownload = _forceDownload;
    @synthesize writePointer = _writePointer;
    @synthesize readPointer = _readPointer;
    @synthesize dataBuild = _dataBuild;
    @synthesize lock = _lock;
    @synthesize semaphore = _semaphore;
    @synthesize readerThread = _readerThread;

    -(instancetype)initWithBytesFromURL:(NSString *)url forceDownload:(BOOL)forceDownload error:(NSError **)error {
        self = [super init];

        if(self) {
            NSError *err = nil;
            _semaphore = [[PGSemaphore alloc] initWithCount:1 error:&err];

            if(!_semaphore) {
                PGSetError(error, err);
                return nil;
            }

            _inputStream     = [NSInputStream inputStreamWithURL:[NSURL URLWithString:url]];

            _lock            = [NSRecursiveLock new];
            _dataBuild       = [NSMutableData new];
            _forceDownload   = forceDownload;
            _isCompleted     = NO;
            _isStatusSuccess = NO;
        }

        return self;
    }

    -(NSUInteger)count {
        return 0;
    }

    -(BOOL)isAtEOF {
        return NO;
    }

    -(NSUInteger)getBytes:(pPGByte)buffer maxLength:(NSUInteger)maxLength error:(NSError **)error {
        return [super getBytes:buffer maxLength:maxLength error:error];
    }

    -(NSInteger)getByte:(NSError **)error {
        return [super getByte:error];
    }


@end
