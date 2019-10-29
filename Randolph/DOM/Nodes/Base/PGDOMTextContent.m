/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMTextContent.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/17/19
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

@implementation PGDOMTextContent {
        NSString *_textData;
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument textData:(NSString *)textData {
        self = [super initWithOwnerDocument:ownerDocument];

        if(self) {
            self.textData = textData;
        }

        return self;
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMTextContent *copy = (PGDOMTextContent *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_textData = _textData.copy;
        }

        return copy;
    }

    -(NSString *)nodeValue {
        return self.textData;
    }

    -(void)setNodeValue:(NSString *)nodeValue {
        self.textData = nodeValue;
    }

    -(NSString *)textContent {
        return self.textData;
    }

    -(void)setTextContent:(NSString *)textContent {
        self.textData = textContent;
    }

    -(NSString *)textData {
        PGDOMSyncData;
        return (_textData ?: @"");
    }

    -(void)setTextData:(NSString *)textData {
        PGDOMSyncData;
        _textData = (textData ?: @"").copy;
    }

    -(NSUInteger)length {
        PGDOMSyncData;
        return _textData.length;
    }

    -(void)appendTextData:(NSString *)textData {
        self.textData = PGAppend(2, self.textData, textData);
    }

    -(void)insertTextData:(NSString *)textData offset:(NSUInteger)offset {
        if(textData.length) {
            NSString   *s = self.textData;
            NSUInteger sl = s.length;

            if(offset == sl) self.textData = PGAppend(2, s, textData);
            else if(offset == 0) self.textData = PGAppend(2, textData, s);
            else if(offset > sl) @throw PGMakeRangeException(offset, sl);
            else {
                NSMutableString *ms = s.mutableCopy;
                [ms insertString:textData atIndex:offset];
                self.textData = ms;
            }
        }
    }

    -(void)deleteTextDataInRange:(NSRange)range {
        if(range.length) {
            NSString   *s = self.textData;
            NSUInteger sl = s.length;
            NSUInteger oc = PGMaxRange(range);

            if(oc > sl) @throw PGMakeRangeException(oc, sl);
            NSString *sa = [s substringWithRange:NSMakeRange(0, range.location)];
            NSString *sb = [s substringWithRange:NSMakeRange(oc, (sl - oc))];
            self.textData = PGAppend(2, sa, sb);
        }
    }

    -(void)replaceTextData:(NSString *)textData inRange:(NSRange)range {
        if(range.length) {
            NSString   *s = self.textData;
            NSUInteger sl = s.length;
            NSUInteger oc = PGMaxRange(range);

            if(oc > sl) @throw PGMakeRangeException(oc, sl);

            NSString *sa = [s substringWithRange:NSMakeRange(0, range.location)];
            NSString *sb = ((textData.length <= range.length) ? (textData ?: @"") : [textData substringWithRange:NSMakeRange(0, range.length)]);
            NSString *sc = [s substringWithRange:NSMakeRange(oc, (sl - oc))];
            self.textData = PGAppend(3, sa, sb, sc);
        }
    }

    -(NSString *)substringAtRange:(NSRange)range {
        return [self.textData substringWithRange:range];
    }

@end
