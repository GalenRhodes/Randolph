/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTime.h
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

#ifndef __RANDOLPH_PGTIME_H__
#define __RANDOLPH_PGTIME_H__

#import <Cocoa/Cocoa.h>
#import <Randolph/PGTools.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PGTimeUnits) {
    PG_TIMEUNIT_NANOS = 0,
    PG_TIMEUNIT_MICROS,
    PG_TIMEUNIT_MILLIS,
    PG_TIMEUNIT_SECONDS,
    PG_TIMEUNIT_MINUTES,
    PG_TIMEUNIT_HOURS,
    PG_TIMEUNIT_DAYS,
    PG_TIMEUNIT_MONTHS,
    PG_TIMEUNIT_YEARS
};

#define PG_NANOS_PER_SEC    1000000000
#define PG_MICROS_PER_SEC   1000000
#define PG_MILLIS_PER_NANO  1000000
#define PG_MILLIS_PER_SEC   1000
#define PG_MICROS_PER_NANO  1000
#define PG_SECS_PER_MIN     60
#define PG_SECS_PER_HOUR    3600
#define PG_SECS_PER_DAY     86400
#define PG_SECS_PER_MONTH   2628000
#define PG_SECS_PER_YEAR    31536000

@interface PGTime : NSObject

    @property(nonatomic, readonly) NSInteger   time;
    @property(nonatomic, readonly) PGTimeUnits units;
    @property(nonatomic, readonly) PGTimespec  toTimespec;
    @property(nonatomic, readonly) PGTimeval   toTimesval;

    -(instancetype)initWithTime:(NSInteger)time units:(PGTimeUnits)units;

    -(instancetype)initWithTime:(NSInteger)time units:(PGTimeUnits)units add:(nullable PGTime *)plus;

    -(instancetype)initWithSeconds:(int64_t)seconds nanos:(int64_t)nanos;

    -(void)add:(PGTime *)plus;

    -(void)getTimespec:(PGTimespec *)pTimespec;

    -(void)getTimeval:(PGTimeval *)pTimeval;

    +(instancetype)timeWithTime:(NSInteger)time units:(PGTimeUnits)units;

    +(instancetype)timeWithTime:(NSInteger)time units:(PGTimeUnits)units add:(nullable PGTime *)plus;

    +(instancetype)timeWithSeconds:(int64_t)seconds nanos:(int64_t)nanos;

    +(instancetype)Nanos:(int64_t)nanos;

    +(instancetype)Micros:(int64_t)nanos;

    +(instancetype)Millis:(int64_t)nanos;

    +(instancetype)Secs:(int64_t)nanos;

    +(instancetype)Mins:(int64_t)nanos;

    +(instancetype)Hours:(int64_t)nanos;

    +(instancetype)Days:(int64_t)nanos;

    +(instancetype)Months:(int64_t)nanos;

    +(instancetype)Years:(int64_t)nanos;

    +(instancetype)Nanos:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Micros:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Millis:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Secs:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Mins:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Hours:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Days:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Months:(int64_t)nanos add:(nullable PGTime *)plus;

    +(instancetype)Years:(int64_t)nanos add:(nullable PGTime *)plus;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGTIME_H__
