/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDefines.m
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

#import "PGDefines.h"

NSErrorDomain const PGRandolphDomain = @"com.projectgalen.randolph";

NSExceptionName const PGComparisonException           = @"PGComparisonException";
NSExceptionName const PGUnsupportedOperationException = @"PGUnsupportedOperationException";
NSExceptionName const PGBufferNotGrowableException    = @"PGBufferNotGrowableException";

NSString *const PGF = @"%@";

NSString *const PGErrorUnknown          = @"Unknown Error";
NSString *const PGErrorOutOfMemory      = @"Out of memory.";
NSString *const PGErrorNotEnoughtMemory = @"Not enough memory to allocate %lu bytes.";
NSString *const PGErrorRegex            = @"Syntax error in regular expression pattern.";
NSString *const PGErrorEmptyArray       = @"Array Empty";
NSString *const PGErrorCannotGrowBuffer = @"Cannot grow buffer.";
NSString *const PGErrorNoBuffer         = @"No buffer.";
NSString *const PGErrorDataSourceClosed = @"Data source is closed.";
NSString *const PGErrorBadSemCount      = @"Count must be in the range 0 < x <= %@.";
NSString *const PGErrorInvalidTimeout   = @"Timeout period is invalid.";

NSString *const PGErrorMsgBadIndex               = @"%@ > %@";
NSString *const PGErrorMsgBadIndex2              = @"%@ >= %@";
NSString *const PGErrorMsgNoSelector             = @"%@ does not respond to '%@' selector.";
NSString *const PGErrorMsgNodeMapImmutable       = @"Named node map is immutable.";
NSString *const PGErrorMsgNoNodeRotation         = @"Cannot rotate tree node to the %@.";
NSString *const PGErrorMsgObjectIsNull           = @"%@ is null.";
NSString *const PGErrorMsgBufferMalloc           = @"Malloc Error: %@";
NSString *const PGErrorMsgNSStream               = @"%@ stream %@";
NSString *const PGErrorMsgNSStreamUnknown        = @"Unknown %@ error";
NSString *const PGErrorMsgBufferElementOwnership = @"%@ element is not owned by this buffer";
NSString *const PGErrorMsgZeroSize               = @"Size is zero";
NSString *const PGErrorMsgBufferFull             = @"Buffer is full";
NSString *const PGErrorMsgBufferNoRoom           = @"Only enough room for %@ bytes";

NSString *const PGMsgReference       = @"Reference";
NSString *const PGMsgSelectorCompare = @"compare:";
NSString *const PGMsgBuffer          = @"Buffer";
NSString *const PGMsgLeft            = @"left";
NSString *const PGMsgRight           = @"right";
NSString *const PGMsgKey             = @"Key";
NSString *const PGMsgValue           = @"Value";
NSString *const PGMsgInput           = @"Input";
NSString *const PGMsgOutput          = @"Output";
NSString *const PGMsgIO              = @"I/O";
NSString *const PGMsgNotOpen         = @"not open";
NSString *const PGMsgBusyReading     = @"busy reading";
NSString *const PGMsgBusyWriting     = @"busy writing";
NSString *const PGMsgClosed          = @"closed";
NSString *const PGMsgTimespec        = @"Timespec";
NSString *const PGMsgTimeval         = @"Timeval";

NSString *const PGSemaphoreNameFormat = @"pgsem_%@";

