/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMLocator.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/25/19
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

#import "PGDOMLocator.h"
#import "PGDOMNode.h"

@implementation PGDOMLocator {
    }

    @synthesize columnNumber = _columnNumber;
    @synthesize lineNumber = _lineNumber;
    @synthesize utf16Offset = _utf16Offset;
    @synthesize relatedNode = _relatedNode;
    @synthesize uri = _uri;

    -(instancetype)initWithLineNumber:(NSInteger)lineNumber
                         columnNumber:(NSInteger)columnNumber
                          utf16Offset:(NSInteger)utf16Offset
                                  uri:(NSString *)uri
                          relatedNode:(PGDOMNode *)relatedNode {
        self = [super init];

        if(self) {
            _lineNumber   = lineNumber;
            _columnNumber = columnNumber;
            _utf16Offset  = utf16Offset;
            _uri          = [uri copy];
            _relatedNode  = relatedNode;
        }

        return self;
    }

    +(instancetype)locatorWithLineNumber:(NSInteger)lineNumber
                            columnNumber:(NSInteger)columnNumber
                             utf16Offset:(NSInteger)utf16Offset
                                     uri:(NSString *)uri
                             relatedNode:(PGDOMNode *)relatedNode {
        return [[self alloc] initWithLineNumber:lineNumber columnNumber:columnNumber utf16Offset:utf16Offset uri:uri relatedNode:relatedNode];
    }

@end
