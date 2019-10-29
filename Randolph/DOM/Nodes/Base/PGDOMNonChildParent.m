/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNonChildParent.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/4/19
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

#import "PGDOMPrivate.h"

@implementation PGDOMNonChildParent {
    }

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
        }

        return self;
    }

    -(PGDOMNode *)parentNode {
        return nil;
    }

    -(void)setParentNode:(PGDOMNode *)parentNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

    -(PGDOMNode *)nextSibling {
        return nil;
    }

    -(void)setNextSibling:(PGDOMNode *)nextSibling {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

    -(PGDOMNode *)prevSibling {
        return nil;
    }

    -(void)setPrevSibling:(PGDOMNode *)prevSibling {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

@end
