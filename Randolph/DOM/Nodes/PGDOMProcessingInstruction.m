/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMProcessingInstruction.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/20/19
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

#import "PGDOMProcessingInstruction.h"
#import "PGDOMPrivate.h"

@implementation PGDOMProcessingInstruction {
    }

    @synthesize target = _target;
    @synthesize data = _data;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument target:(NSString *)target data:(NSString *)data {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            _target = target.copy;
            _data   = data.copy;
        }

        return self;
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMProcessingInstruction *copy = (PGDOMProcessingInstruction *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_data = _data.copy;
            copy->_target = _target.copy;
        }

        return copy;
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeProcessingInstruction;
    }

    -(NSString *)nodeName {
        return self.target;
    }

    -(NSString *)nodeValue {
        return self.data;
    }

    -(void)setNodeValue:(NSString *)nodeValue {
        self.data = nodeValue;
    }

@end
