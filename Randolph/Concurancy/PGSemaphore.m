/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGSemaphore.m
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

#import <semaphore.h>
#import "PGSemaphore.h"
#import "PGTools.h"
#import "sem_timedwait.h"

@implementation PGSemaphore {
        sem_t *_sem;
        BOOL  _unlinkWhenDone;
    }

    @synthesize count = _count;

    -(instancetype)initWithCount:(NSUInteger)count error:(NSError **)error {
        self = [self initWithName:nil count:count unlinkWhenDone:YES error:error];
        return self;
    }

    -(instancetype)initWithName:(NSString *)name count:(NSUInteger)count unlinkWhenDone:(BOOL)unlinkWhenDone error:(NSError **)error {
        self = [super init];

        if(self) {
            _sem            = SEM_FAILED;
            _unlinkWhenDone = (unlinkWhenDone || (name.trim.length == 0));

            if(count < 1 || count > SEM_VALUE_MAX) {
                @throw PGMakeException(NSInvalidArgumentException, PGErrorBadSemCount, SEM_VALUE_MAX);
            }

            _name = (name.trim.length ? name.copy : PGFormat(PGSemaphoreNameFormat, [NSUUID.UUID UUIDString]));
            if(_name.length > PG_MAX_IPC_NAME_LENGTH) _name = [_name substringWithRange:NSMakeRange(0, PG_MAX_IPC_NAME_LENGTH)];

            _count = count;
            _sem   = sem_open(_name.UTF8String, O_CREAT, (S_IRWXU | S_IRWXG), (unsigned int)_count);

            if(_sem == SEM_FAILED) {
                if(error) *error = PGMakeError(5000, PGErrorString(errno));
                return nil;
            }
        }

        return self;
    }

    -(void)dealloc {
        if(_sem != SEM_FAILED) {
            sem_close(_sem);
            if(_unlinkWhenDone) sem_unlink(self.name.UTF8String);
        }
    }

    -(PGSemaphoreResponses)post {
        return (sem_post(_sem) ? PG_SEM_WAIT_OTHERERR : PG_SEM_WAIT_SUCCESS);
    }

    -(PGSemaphoreResponses)wait {
        if(sem_wait(_sem)) {
            switch(errno) {//@f:0
                case EAGAIN:  return PG_SEM_WAIT_BUSY;
                case EDEADLK: return PG_SEM_WAIT_DEADLOCK;
                case EINTR:   return PG_SEM_WAIT_INTERRUPT;
                default:      return PG_SEM_WAIT_OTHERERR; //@f:1
            }
        }

        return PG_SEM_WAIT_SUCCESS;
    }

    -(PGSemaphoreResponses)tryWait {
        if(sem_wait(_sem)) {
            switch(errno) {//@f:0
                case EAGAIN:  return PG_SEM_WAIT_BUSY;
                case EDEADLK: return PG_SEM_WAIT_DEADLOCK;
                case EINTR:   return PG_SEM_WAIT_INTERRUPT;
                default:      return PG_SEM_WAIT_OTHERERR; //@f:1
            }
        }

        return PG_SEM_WAIT_SUCCESS;
    }

    -(PGSemaphoreResponses)timedWait:(PGTime *)timeout {
        PGTimespec ts = timeout.toTimespec;

        if(sem_timedwait(_sem, &ts)) {
            switch(errno) {//@f:0
                case EINVAL:    @throw PGMakeException(NSInvalidArgumentException, PGErrorInvalidTimeout);
                case ETIMEDOUT: return PG_SEM_WAIT_TIMEOUT;
                case EAGAIN:    return PG_SEM_WAIT_BUSY;
                case EDEADLK:   return PG_SEM_WAIT_DEADLOCK;
                case EINTR:     return PG_SEM_WAIT_INTERRUPT;
                default:        return PG_SEM_WAIT_OTHERERR; //@f:1
            }
        }

        return PG_SEM_WAIT_SUCCESS;
    }

@end
