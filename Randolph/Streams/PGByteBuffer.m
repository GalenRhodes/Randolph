/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGByteBuffer.m
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

#import "PGByteBuffer.h"
#import "PGBufferElement.h"
#import "PGByteBufferElement.h"

const NSInteger PGChunkBufferSize = (1024 * 1024); // 1 MB chunks...

@interface PGByteBuffer()

    -(void)setError:(NSError *)error error:(NSError **)pError;

    -(BOOL)appendFullyFromFilePath:(NSString *)fileName error:(NSError **)error;

    -(void)appendBufferElement:(PGBufferElement *)bufferElement;

    -(void)prependBufferElement:(PGBufferElement *)bufferElement;

    -(void)removeBufferElement:(PGBufferElement *)bufferElement;

    -(void)deallocBuffers;

@end

@implementation PGByteBuffer {
        PGBufferElement *_firstElement;
        PGBufferElement *_lastElement;
    }

    @synthesize lastError = _lastError;

    -(instancetype)init {
        self = [super init];
        return self;
    }

    -(instancetype)initWithBytes:(const pPGByte)bytes length:(NSUInteger)length error:(NSError **)error {
        self = [self init];

        if(self) {
            if(bytes) {
                PGByteBufferElement *elem = [PGByteBufferElement elementWithBytes:bytes length:length error:error];
                if(elem) [self appendBufferElement:elem]; else return nil;
            }
            else {
                PGSetError(error, PGMakeError(1200, PGErrorNoBuffer));
                return nil;
            }
        }

        return self;
    }

    -(instancetype)initWithFileAtPath:(NSString *)fileName readFully:(BOOL)readFully error:(NSError **)error {
        self = [self init];

        if(self) {
            if(readFully) {
                if(![self appendFullyFromFilePath:fileName error:error]) return nil;
            }
            else {
            }
        }

        return self;
    }

    -(void)setError:(NSError *)error error:(NSError **)pError {
        if(pError) *pError = error;
        _lastError = error;
    }

    -(BOOL)appendFullyFromFilePath:(NSString *)fileName error:(NSError **)error {
        NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:fileName];

        if(stream) {
            [stream open];
            while(stream.isStatusOpening);

            @try {
                NSError             *_e = nil;
                PGByteBufferElement *be = [PGByteBufferElement elementWithBytesFromStream:stream length:65536 error:&_e];

                while(be) {
                    [self appendBufferElement:be];
                    be = [PGByteBufferElement elementWithBytesFromStream:stream length:65536 error:&_e];
                }

                [self setError:_e error:error];
                return (_e == nil);
            }
            @finally {
                [stream close];
            }
        }
        else {
            [self setError:PGMakeError(1201, PGErrorUnknown) error:error];
            return NO;
        }
    }

    -(void)appendBufferElement:(PGBufferElement *)bufferElement {
        if(bufferElement) {
            [bufferElement.owner removeBufferElement:bufferElement];
            bufferElement.owner = self;
            bufferElement.next  = nil;
            bufferElement.prev  = _lastElement;
            _lastElement.next   = bufferElement;
            _lastElement = bufferElement;
        }
    }

    -(void)prependBufferElement:(PGBufferElement *)bufferElement {
        if(bufferElement) {
            [bufferElement.owner removeBufferElement:bufferElement];
            bufferElement.owner = self;
            bufferElement.prev  = nil;
            bufferElement.next  = _firstElement;
            _firstElement.prev  = bufferElement;
            _firstElement = bufferElement;
        }
    }

    -(void)removeBufferElement:(PGBufferElement *)bufferElement {
        if(bufferElement) {
            if(self == bufferElement.owner) {
                if(_lastElement == bufferElement) _lastElement   = bufferElement.prev;
                if(_firstElement == bufferElement) _firstElement = bufferElement.next;

                bufferElement.owner     = nil;
                bufferElement.next.prev = bufferElement.prev;
                bufferElement.prev.next = bufferElement.next;
                bufferElement.next      = bufferElement.prev = nil;
            }
        }
    }

    -(void)dealloc {
        [self deallocBuffers];
    }

    -(void)deallocBuffers {
        PGBufferElement *e = _firstElement;
        PGBufferElement *n;

        _firstElement = _lastElement = nil;

        while(e) {
            n = e.next;
            e.prev  = e.next = nil;
            e.owner = nil;
            e = n;
        }
    }

@end
