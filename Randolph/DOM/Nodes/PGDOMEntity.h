/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMEntity.h
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

#ifndef __RANDOLPH_PGDOMENTITY_H__
#define __RANDOLPH_PGDOMENTITY_H__

#import <Randolph/PGDOMNonChildParent.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGDOMEntity : PGDOMNonChildParent

    @property(nonatomic, readonly, copy)/*      */ NSString *inputEncoding;
    @property(nonatomic, readonly, copy)/*      */ NSString *notationName;
    @property(nonatomic, readonly, copy, nullable) NSString *publicId;
    @property(nonatomic, readonly, copy, nullable) NSString *systemId;
    @property(nonatomic, readonly, copy)/*      */ NSString *xmlEncoding;
    @property(nonatomic, readonly, copy)/*      */ NSString *xmlVersion;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDOMENTITY_H__
