/************************************************************************//**
 *     PROJECT: Randolph
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/27/19
 *    FILENAME: PGURLBufferElement.m
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

const NSInteger PGForceDownloadThreshold = 134217728; // 128MB threshold
const NSInteger PGReadBufferSize         = 65536;     // 64KB read buffer

BOOL PGReadFromStreamIntoBuffer(NSMutableData *buffer, NSInputStream *inputStream, BOOL forceDownload, NSRecursiveLock *lock) {
    uint8_t *bff = malloc(PGReadBufferSize);

    if(bff) {
        @try {
            if(!inputStream.isStatusClosed) {
                if(inputStream.isStatusNotOpen) {
                    [inputStream open];
                    while(inputStream.isStatusOpening);
                }

                @try {
                    NSInteger rr = [inputStream read:bff maxLength:PGReadBufferSize];

                    while(rr > 0) {
                        [lock lock];
                        @try { [buffer appendBytes:bff length:(NSUInteger)rr]; } @finally { [lock unlock]; }
                        rr = [inputStream read:bff maxLength:PGReadBufferSize];
                    }

                    return (rr == 0);
                }
                @finally { [inputStream close]; }
            }
        }
        @catch(NSException *e) {
            PGLog(@"Exception Caught: %@: %@", e.name, e.reason);
        }
        @finally { free(bff); }
    }

    return NO;
}

@implementation PGURLBufferElement {
        BOOL             _isCompleted;
        NSUInteger       _readPointer;
        NSMutableData    *_buffer;
        NSRecursiveLock  *_lock;
        NSInputStream    *_inputStream;
        dispatch_queue_t _queue;
        NSString         *_queueName;
    }

    @synthesize isStatusSuccess = _isStatusSuccess;
    @synthesize forceDownload = _forceDownload;

    -(instancetype)initWithBytesFromURL:(NSString *)url forceDownload:(BOOL)forceDownload error:(NSError **)error {
        self = [super init];

        if(self) {
            self.name = url;

            _forceDownload   = forceDownload;
            _isCompleted     = NO;
            _isStatusSuccess = NO;
            _buffer          = [NSMutableData new];
            _lock            = [NSRecursiveLock new];
            _inputStream     = [NSInputStream inputStreamWithURL:[NSURL URLWithString:url]];
            _queueName       = [NSUUID.UUID UUIDString];
            _queue           = dispatch_queue_create(_queueName.UTF8String, DISPATCH_QUEUE_SERIAL);

            dispatch_async(_queue, ^{
                _isStatusSuccess = PGReadFromStreamIntoBuffer(_buffer, _inputStream, self.forceDownload, _lock);
                if(!_isStatusSuccess) self.lastError = (_inputStream.streamError ?: PGMakeError(1000, PGErrorUnknown));
                _isCompleted = YES;
            });

            PGSetError(error, nil);
        }

        return self;
    }

    -(NSUInteger)count {
        [_lock lock];
        NSUInteger l = _buffer.length;
        [_lock unlock];
        return l;
    }

    -(BOOL)isAtEOF {
        [_lock lock];
        BOOL f = (_isCompleted && (_readPointer == _buffer.length));
        [_lock unlock];
        return f;
    }

    -(NSUInteger)getBytes:(pPGByte)buffer maxLength:(NSUInteger)maxLength error:(NSError **)error {
        [self waitForData];
        NSUInteger cc = MIN(maxLength, (_buffer.length - _readPointer));

        if(cc) {
            [_buffer getBytes:buffer range:NSMakeRange(_readPointer, cc)];
            _readPointer += cc;
        }

        [_lock unlock];
        return cc;
    }

    -(NSInteger)getByte:(NSError **)error {
        [self waitForData];
        NSInteger bt = ((_readPointer < _buffer.length) ? ((uint8_t *)_buffer.bytes)[_readPointer++] : EOF);
        [_lock unlock];
        return bt;
    }

    -(void)waitForData {
        [_lock lock];
        BOOL willWait = !((_readPointer < _buffer.length) || _isCompleted);

        while(willWait) {
            [_lock unlock];
            PGSleep(30); // Sleep for 30 milliseconds just so we don't waste CPU time.
            [_lock lock];
            willWait = !((_readPointer < _buffer.length) || _isCompleted);
        }
    }


@end
