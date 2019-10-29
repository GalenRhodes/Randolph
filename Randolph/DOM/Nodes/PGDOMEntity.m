/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMEntity.m
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

#import "PGDOMPrivate.h"

@implementation PGDOMEntity {
    }

    @synthesize inputEncoding = _inputEncoding;
    @synthesize notationName = _notationName;
    @synthesize publicId = _publicId;
    @synthesize systemId = _systemId;
    @synthesize xmlEncoding = _xmlEncoding;
    @synthesize xmlVersion = _xmlVersion;

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument
                           inputEncoding:(NSString *)inputEncoding
                            notationName:(NSString *)notationName
                                publicId:(NSString *)publicId
                                systemId:(NSString *)systemId
                             xmlEncoding:(NSString *)xmlEncoding
                              xmlVersion:(NSString *)xmlVersion {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            _inputEncoding = [inputEncoding copy];
            _notationName  = [notationName copy];
            _publicId      = [publicId copy];
            _systemId      = [systemId copy];
            _xmlEncoding   = [xmlEncoding copy];
            _xmlVersion    = [xmlVersion copy];
        }

        return self;
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeEntity;
    }

    -(instancetype)copy:(BOOL)deep {
        /*
         * Always deep copy an entities child nodes.
         */
        return [super copy:YES];
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMEntity *copy = (PGDOMEntity *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_inputEncoding = _inputEncoding.copy;
            copy->_notationName  = _notationName.copy;
            copy->_publicId      = _publicId.copy;
            copy->_systemId      = _systemId.copy;
            copy->_xmlEncoding   = _xmlEncoding.copy;
            copy->_xmlVersion    = _xmlVersion.copy;
        }

        return copy;
    }

@end
