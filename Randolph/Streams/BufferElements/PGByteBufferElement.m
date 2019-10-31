/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGByteBufferElement.m
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

const NSInteger ReadBufferSize = 8192;

@implementation PGByteBufferElement {
    }

    @synthesize readPointer = _readPointer;
    @synthesize buffer = _buffer;

    -(instancetype)init {
        self = [super init];
        return self;
    }

    -(instancetype)initWithNSData:(NSData *)data {
        self = [super init];
        if(self) _buffer = ((data == nil) ? [NSData new] : ([data isInstanceOf:[NSMutableData class]] ? [data copy] : data));
        return self;
    }

    -(instancetype)initWithBytes:(pPGByte)bytes length:(NSUInteger)length error:(NSError **)error {
        if(bytes) {
            self = [super init];
            if(self) _buffer = [NSData dataWithBytes:bytes length:length];
            [self setError:nil error:error];
            return self;
        }
        else {
            [self setError:PGMakeError(1100, PGErrorNoBuffer) error:error];
            return nil;
        }
    }

    -(instancetype)initWithBytesNoCopy:(pPGByte)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeWhenDone error:(NSError **)error {
        if(bytes) {
            self = [super init];
            if(self) _buffer = [NSData dataWithBytesNoCopy:bytes length:length freeWhenDone:freeWhenDone];
            [self setError:nil error:error];
            return self;
        }
        else {
            [self setError:PGMakeError(1100, PGErrorNoBuffer) error:error];
            return nil;
        }
    }

    -(instancetype)initWithBytesFromFileAtPath:(NSString *)path error:(NSError **)error {
        self = [super init];
        if(self) {
            self.name = path;
            _buffer = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:error];
            if(!_buffer) return nil;
        }
        return self;
    }

    -(instancetype)initWithBytesFromStream:(NSInputStream *)stream length:(NSUInteger)length error:(NSError **)error {
        self = [super init];

        @try {
            if(self) {
                if(length) {
                    NSMutableData *data  = [NSMutableData dataWithCapacity:(ReadBufferSize * 2)];
                    pPGByte       buffer = malloc(ReadBufferSize);

                    if(buffer) {
                        @try {
                            NSInteger r = [stream read:buffer maxLength:ReadBufferSize];

                            while(r > 0) {
                                [data appendBytes:buffer length:(NSUInteger)r];
                                r = [stream read:buffer maxLength:ReadBufferSize];
                            }

                            if(r < 0) {
                                [self setError:stream.streamError error:error];
                                return nil;
                            }

                            _buffer = data.copy;
                        }
                        @finally {
                            free(buffer);
                        }
                    }
                    else {
                        [self setError:PGMakeError(1001, PGErrorOutOfMemory) error:error];
                        return nil;
                    }
                }
            }
        }
        @catch(NSException *e) {
            [self setError:PGMakeError(0000, @"Unknown Exception: %@", [e description]) error:error];
            return nil;
        }
        @finally {
            [stream close];
        }

        [self setError:nil error:error];
        return self;
    }

    -(NSUInteger)count {
        return _buffer.length;
    }

    -(NSUInteger)getBytes:(pPGByte)buffer maxLength:(NSUInteger)maxLength error:(NSError **)error {
        [self setError:nil error:error];
        NSUInteger bl = _buffer.length;
        NSUInteger rl = 0;
        if(_readPointer < bl) {
            NSRange range = NSMakeRange(_readPointer, MIN((bl - _readPointer), maxLength));
            [_buffer getBytes:buffer range:range];
            _readPointer = NSMaxRange(range);
            rl           = range.length;
        }
        return rl;
    }

    -(NSInteger)getByte:(NSError **)error {
        [self setError:nil error:error];
        return ((_readPointer < _buffer.length) ? ((pPGByte)_buffer.bytes)[_readPointer++] : EOF);
    }

    -(BOOL)isAtEOF {
        return (_readPointer >= _buffer.length);
    }

@end
