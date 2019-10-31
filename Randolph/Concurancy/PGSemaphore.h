/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGSemaphore.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/30/19
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

#ifndef __RANDOLPH_PGSEMAPHORE_H__
#define __RANDOLPH_PGSEMAPHORE_H__

#import <Cocoa/Cocoa.h>

@class PGTime;

NS_ASSUME_NONNULL_BEGIN

// Reference https://github.com/django/asgi_ipc/issues/4
#ifdef __APPLE__
    #define PG_MAX_IPC_NAME_LENGTH 30
#else
    #define PG_MAX_IPC_NAME_LENGTH 251
#endif

typedef NS_ENUM(NSUInteger, PGSemaphoreResponses) {
    PG_SEM_WAIT_SUCCESS = 0, PG_SEM_WAIT_TIMEOUT, PG_SEM_WAIT_BUSY, PG_SEM_WAIT_INTERRUPT, PG_SEM_WAIT_DEADLOCK, PG_SEM_WAIT_OTHERERR
};

@interface PGSemaphore : NSObject

    @property(nonatomic, readonly)/*  */ NSUInteger count;
    @property(nonatomic, readonly, copy) NSString   *name;

    -(PGSemaphoreResponses)post;

    -(PGSemaphoreResponses)wait;

    -(PGSemaphoreResponses)tryWait;

    -(PGSemaphoreResponses)timedWait:(PGTime *)timeout;
@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGSEMAPHORE_H__
