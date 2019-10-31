/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTime.m
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

#import <ImageIO/ImageIO.h>
#import "PGTime.h"

@interface PGTime()

    @property(nonatomic, readonly) int64_t seconds;
    @property(nonatomic, readonly) int64_t nanoseconds;
    @property(nullable)/*       */ PGTime  *plus;

@end

@implementation PGTime {
    }

    @synthesize time = _time;
    @synthesize units = _units;
    @synthesize plus = _plus;

    -(instancetype)initWithTime:(NSInteger)time units:(PGTimeUnits)units {
        return (self = [self initWithTime:time units:units add:nil]);
    }

    -(instancetype)initWithTime:(NSInteger)time units:(PGTimeUnits)units add:(nullable PGTime *)plus {
        self = [super init];

        if(self) {
            _time  = time;
            _units = units;
            _plus  = plus;
        }

        return self;
    }

    -(instancetype)initWithSeconds:(int64_t)seconds nanos:(int64_t)nanos {
        return (self = [self initWithTime:seconds units:PG_TIMEUNIT_SECONDS add:[PGTime Nanos:nanos]]);
    }

    -(void)add:(PGTime *)plus {
        PGTime *k = self;
        while(k.plus) k = k.plus;
        k.plus = plus;
    }

    -(int64_t)seconds {
        switch(self.units) {//@f:0
            case PG_TIMEUNIT_MICROS:  return (self.time / PG_MICROS_PER_SEC);
            case PG_TIMEUNIT_MILLIS:  return (self.time / PG_MILLIS_PER_SEC);
            case PG_TIMEUNIT_SECONDS: return (self.time);
            case PG_TIMEUNIT_MINUTES: return (self.time * PG_SECS_PER_MIN);
            case PG_TIMEUNIT_HOURS:   return (self.time * PG_SECS_PER_HOUR);
            case PG_TIMEUNIT_DAYS:    return (self.time * PG_SECS_PER_DAY);
            case PG_TIMEUNIT_MONTHS:  return (self.time * PG_SECS_PER_MONTH);
            case PG_TIMEUNIT_YEARS:   return (self.time * PG_SECS_PER_YEAR);
            default:                  return (self.time / PG_NANOS_PER_SEC); //@f:1
        }
    }

    -(int64_t)nanoseconds {
        switch(self.units) {//@f:0
            case PG_TIMEUNIT_NANOS:  return (self.time % PG_NANOS_PER_SEC);
            case PG_TIMEUNIT_MICROS: return ((self.time % PG_MICROS_PER_SEC) * PG_MICROS_PER_NANO);
            case PG_TIMEUNIT_MILLIS: return ((self.time % PG_MILLIS_PER_SEC) * PG_MILLIS_PER_NANO);
            default:                 return 0;
        }//@f:1
    }

    -(void)getTimespec:(PGTimespec *)pTimespec {
        if(pTimespec) {
            PGTimespec ts = { .tv_sec = 0, .tv_nsec = 0 };
            if(self.plus) [self.plus getTimespec:&ts];

            int64_t ns = (self.nanoseconds + ts.tv_nsec);
            pTimespec->tv_nsec = (ns % PG_NANOS_PER_SEC);
            pTimespec->tv_sec  = ((self.seconds + ts.tv_sec) + (ns / PG_NANOS_PER_SEC));
        }
        else @throw PGMakeException(NSInvalidArgumentException, @"%@ is null", @"Timespec");
    }

    -(void)getTimeval:(PGTimeval *)pTimeval {
        if(pTimeval) {
            PGTimespec ts;
            [self getTimespec:&ts];
            pTimeval->tv_sec  = ts.tv_sec;
            pTimeval->tv_usec = (int32_t)(ts.tv_nsec / PG_MICROS_PER_NANO);
        }
        else @throw PGMakeException(NSInvalidArgumentException, @"%@ is null", @"Timeval");
    }

    -(PGTimespec)toTimespec {
        PGTimespec ts;
        [self getTimespec:&ts];
        return ts;
    }

    -(PGTimeval)toTimesval {
        PGTimeval tv;
        [self getTimeval:&tv];
        return tv;
    }

    +(instancetype)timeWithTime:(NSInteger)time units:(PGTimeUnits)units {
        return [[self alloc] initWithTime:time units:units];
    }

    +(instancetype)timeWithTime:(NSInteger)time units:(PGTimeUnits)units add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:time units:units add:plus];
    }

    +(instancetype)timeWithSeconds:(int64_t)seconds nanos:(int64_t)nanos {
        return [[self alloc] initWithSeconds:seconds nanos:nanos];
    }

    +(instancetype)Nanos:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_NANOS];
    }

    +(instancetype)Micros:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MICROS];
    }

    +(instancetype)Millis:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MILLIS];
    }

    +(instancetype)Secs:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_SECONDS];
    }

    +(instancetype)Mins:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MINUTES];
    }

    +(instancetype)Hours:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_HOURS];
    }

    +(instancetype)Days:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_DAYS];
    }

    +(instancetype)Months:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MONTHS];
    }

    +(instancetype)Years:(int64_t)nanos {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_YEARS];
    }

    +(instancetype)Nanos:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_NANOS add:plus];
    }

    +(instancetype)Micros:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MICROS add:plus];
    }

    +(instancetype)Millis:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MILLIS add:plus];
    }

    +(instancetype)Secs:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_SECONDS add:plus];
    }

    +(instancetype)Mins:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MINUTES add:plus];
    }

    +(instancetype)Hours:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_HOURS add:plus];
    }

    +(instancetype)Days:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_DAYS add:plus];
    }

    +(instancetype)Months:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_MONTHS add:plus];
    }

    +(instancetype)Years:(int64_t)nanos add:(nullable PGTime *)plus {
        return [[self alloc] initWithTime:nanos units:PG_TIMEUNIT_YEARS add:plus];
    }

@end
