/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDefines.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/3/19
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

#ifndef __RANDOLPH_PGDEFINES_H__
#define __RANDOLPH_PGDEFINES_H__

#import <Cocoa/Cocoa.h>
// #import <p99/p99.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const PGRandolphDomain;

FOUNDATION_EXPORT NSExceptionName const PGComparisonException;
FOUNDATION_EXPORT NSExceptionName const PGUnsupportedOperationException;
FOUNDATION_EXPORT NSExceptionName const PGBufferNotGrowableException;

FOUNDATION_EXPORT NSString *const PGF;

FOUNDATION_EXPORT NSString *const PGErrorUnknown;
FOUNDATION_EXPORT NSString *const PGErrorOutOfMemory;
FOUNDATION_EXPORT NSString *const PGErrorNotEnoughtMemory;
FOUNDATION_EXPORT NSString *const PGErrorRegex;
FOUNDATION_EXPORT NSString *const PGErrorEmptyArray;
FOUNDATION_EXPORT NSString *const PGErrorCannotGrowBuffer;
FOUNDATION_EXPORT NSString *const PGErrorNoBuffer;
FOUNDATION_EXPORT NSString *const PGErrorDataSourceClosed;
FOUNDATION_EXPORT NSString *const PGErrorBadSemCount;
FOUNDATION_EXPORT NSString *const PGErrorInvalidTimeout;

FOUNDATION_EXPORT NSString *const PGErrorMsgBadIndex;
FOUNDATION_EXPORT NSString *const PGErrorMsgBadIndex2;
FOUNDATION_EXPORT NSString *const PGErrorMsgNoSelector;
FOUNDATION_EXPORT NSString *const PGErrorMsgNodeMapImmutable;
FOUNDATION_EXPORT NSString *const PGErrorMsgNoNodeRotation;
FOUNDATION_EXPORT NSString *const PGErrorMsgObjectIsNull;
FOUNDATION_EXPORT NSString *const PGErrorMsgBufferMalloc;
FOUNDATION_EXPORT NSString *const PGErrorMsgNSStream;
FOUNDATION_EXPORT NSString *const PGErrorMsgNSStreamUnknown;
FOUNDATION_EXPORT NSString *const PGErrorMsgBufferElementOwnership;
FOUNDATION_EXPORT NSString *const PGErrorMsgZeroSize;
FOUNDATION_EXPORT NSString *const PGErrorMsgBufferFull;
FOUNDATION_EXPORT NSString *const PGErrorMsgBufferNoRoom;

FOUNDATION_EXPORT NSString *const PGMsgReference;
FOUNDATION_EXPORT NSString *const PGMsgBuffer;
FOUNDATION_EXPORT NSString *const PGMsgLeft;
FOUNDATION_EXPORT NSString *const PGMsgRight;
FOUNDATION_EXPORT NSString *const PGMsgKey;
FOUNDATION_EXPORT NSString *const PGMsgValue;
FOUNDATION_EXPORT NSString *const PGMsgSelectorCompare;
FOUNDATION_EXPORT NSString *const PGMsgInput;
FOUNDATION_EXPORT NSString *const PGMsgOutput;
FOUNDATION_EXPORT NSString *const PGMsgIO;
FOUNDATION_EXPORT NSString *const PGMsgNotOpen;
FOUNDATION_EXPORT NSString *const PGMsgBusyReading;
FOUNDATION_EXPORT NSString *const PGMsgBusyWriting;
FOUNDATION_EXPORT NSString *const PGMsgClosed;
FOUNDATION_EXPORT NSString *const PGMsgTimespec;
FOUNDATION_EXPORT NSString *const PGMsgTimeval;

FOUNDATION_EXPORT NSString *const PGSemaphoreNameFormat;

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDEFINES_H__
