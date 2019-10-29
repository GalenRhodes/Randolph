/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMQName.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/26/19
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

#import "PGDOMQName.h"
#import "PGTools.h"
#import "PGDOMTools.h"
#import "PGDOMPrivate.h"

@implementation PGDOMQName {
    }

    @synthesize prefix = _prefix;
    @synthesize localName = _localName;

    -(instancetype)initWithQualifiedName:(NSString *)qname {
        self = [super init];

        if(self) {
            NSArray<NSTextCheckingResult *> *array = [self parsedQName:qname];

            if(array.count == 1) {
                NSTextCheckingResult *result = array[0];
                _prefix    = PGSubstr(qname, [result rangeAtIndex:1]).nilIfEmpty;
                _localName = PGSubstr(qname, [result rangeAtIndex:2]).nilIfEmpty;
            }
            else @throw PGMakeDOMException(PGDOMErrorNoNames, PGF, PGFormat(PGDOMErrorMsgNoName, PGDOMDescQName));
        }

        return self;
    }

    +(instancetype)qnameWithQualifiedName:(NSString *)qname {
        return [[self alloc] initWithQualifiedName:qname];
    }

    -(instancetype)initWithPrefix:(NSString *)prefix localName:(NSString *)localName {
        self = [super init];

        if(self) {
            _prefix    = prefix.nilIfEmpty.copy;
            _localName = localName.nilIfEmpty.copy;
            if(!_localName) @throw PGMakeDOMException(PGDOMErrorNoNames, PGF, PGFormat(PGDOMErrorMsgNoName, PGDOMDescLocalName));
        }

        return self;
    }

    +(instancetype)qnameWithPrefix:(NSString *)prefix localName:(NSString *)localName {
        return [[self alloc] initWithPrefix:prefix localName:localName];
    }

    -(NSArray<NSTextCheckingResult *> *)parsedQName:(NSString *)qualifiedName {
        NSRegularExpression *regex = [NSRegularExpression cachedRegexWithPattern:PGDOMPatternParseQualifiedName];
        @synchronized(regex) {
            return [regex matchesInString:qualifiedName];
        }
    }

    -(NSString *)qualifiedName {
        return (self.prefix.length ? PGFormat(PGDOMFormatNodeNameNS, self.prefix, self.localName ?: @"") : self.localName);
    }

@end
