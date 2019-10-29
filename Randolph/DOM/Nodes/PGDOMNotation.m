/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNotation.m
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

#import "PGDOMNotation.h"
#import "PGDOMPrivate.h"

@implementation PGDOMNotation {
    }

    @synthesize publicId = _publicId;
    @synthesize systemId = _systemId;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument publicId:(NSString *)publicId systemId:(NSString *)systemId {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            _publicId = publicId;
            _systemId = systemId;
        }

        return self;
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeNotation;
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMNotation *copy = (PGDOMNotation *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_publicId = _publicId.copy;
            copy->_systemId = _systemId.copy;
        }

        return copy;
    }

@end
