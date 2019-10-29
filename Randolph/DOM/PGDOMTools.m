/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMTools.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2019-08-20
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

#import "PGTools.h"
#import "PGDOMTools.h"
#import "PGDOMPrivate.h"
#import "PGDOMDocument_Private.h"

static NSMutableDictionary<NSString *, NSRegularExpression *> *_regexMap    = nil;
static dispatch_once_t                                        _regexMapFlag = 0;

NSString *PGDOMValidateName(NSString *name, NSString *format) {
    if(name) {
        dispatch_once(&_regexMapFlag, ^{
            PGLog(@"Creating regexMap...");
            _regexMap = [NSMutableDictionary new];
        });

        @synchronized(_regexMap) {
            NSRegularExpression *regex = _regexMap[format];

            if(!regex) {
                NSString *pattern = PGFormat(format, PGDOMPatternNameStartChar, PGDOMPatternNameCharAddon);
                regex = [NSRegularExpression regularExpressionWithPattern:pattern];
                _regexMap[format] = regex;
            }

            if(![regex matchesEntireString:name]) @throw PGMakeDOMException(PGDOMErrorInvalidCharacter, PGF, PGDOMErrorInvalidCharacter);
        }
    }

    return name;
}

NSString *PGDOMValidateNodeName(NSString *nodeName) {
    if(nodeName.length == 0) @throw PGMakeDOMException(PGDOMErrorMissingNodeName, PGF, PGDOMErrorMsgNodeNameMissing);
    return PGDOMValidateName(nodeName, PGDOMFormatNodeNameParserPattern);
}

NSString *PGDOMValidateLocalName(NSString *localName) {
    if(localName.length == 0) @throw PGMakeDOMException(PGDOMErrorMissingLocalName, PGF, PGDOMErrorMsgLocalNameMissing);
    return PGDOMValidateName(localName, PGDOMFormatNameParserPattern);
}

NSString *PGDOMValidatePrefix(NSString *prefix) {
    return PGDOMValidateName(prefix, PGDOMFormatPrefixParserPattern);
}

void PGDOMValidateNameCombo(NSString *prefix, NSString *localName, NSString *namespaceURI) {
    if([W3NS1998PFX isEqualToString:prefix] && ![W3NS1998URI isEqualToString:namespaceURI]) @throw PGMakeDOMException(PGDOMErrorNamespaceError, nil);

    BOOL b1 = ([W3NS2000PFX isEqualToString:prefix] || ((prefix.length == 0) && [W3NS2000PFX isEqualToString:localName]));
    BOOL b2 = [W3NS2000URI isEqualToString:namespaceURI];

    if(b1 != b2) @throw PGMakeDOMException(PGDOMErrorNamespaceError, nil);
}

PGDOMQName *PGDOMParseQualifiedName(NSString *qualifiedName) {
    return [PGDOMQName qnameWithQualifiedName:qualifiedName];
}

PGDOMDocument *PGDOMCreateDocument() {
    PGDOMDocument *doc = [PGDOMDocument new];
    return doc;
}
