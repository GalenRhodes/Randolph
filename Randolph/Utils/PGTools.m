/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTools.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2019-08-13
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
#import "PGDOMNode.h"
#import <objc/runtime.h>

static NSNotificationCenter *_pgNotificationCenter_ = nil;
static dispatch_once_t      _pgNotificationOnce_    = 0;
static dispatch_once_t      _randomOnce_            = 0;

BOOL PGSleep(NSUInteger millis) {
    NSUInteger nanos = (millis * 1000000);
    PGTimespec ts    = { .tv_sec = (nanos / 1000000000), .tv_nsec = (nanos % 1000000000) };
    return (nanosleep(&ts, NULL) == 0);
}

NSString *PGFormat2(NSString *format, va_list args) {
    return [[NSString alloc] initWithFormat:format arguments:args];
}

NSRect PGCenterRects(NSRect outer, NSSize inner) {
    NSRect res;

    res.size     = inner;
    res.origin.x = (outer.origin.x + ((outer.size.width - inner.width) * 0.5));
    res.origin.y = (outer.origin.y + ((outer.size.height - inner.height) * 0.5));

    return res;
}

CGFloat PGGetScaling(NSSize srcSize, NSSize dstSize) {
    CGFloat sw     = srcSize.width;
    CGFloat dw     = dstSize.width;
    CGFloat sh     = srcSize.height;
    CGFloat dh     = dstSize.height;
    CGFloat scaleX = ((sw > dw) ? (dw / sw) : 1.0);
    CGFloat scaleY = ((sh > dh) ? (dh / sh) : 1.0);
    return MIN(scaleX, scaleY);
}

NSImageRep *PGDrawOnOffscreenImage(NSSize imageSize, PGDrawingBlock block) {
    NSBitmapImageRep  *img   = PGCreateBitmapImageRep(imageSize.width, imageSize.height);
    NSGraphicsContext *oldgc = [NSGraphicsContext currentContext];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:img]];

    @try {
        block(img.size);
    }
    @finally {
        [NSGraphicsContext setCurrentContext:oldgc];
        [NSGraphicsContext restoreGraphicsState];
    }

    return img;
}

NSAffineTransform *PGFlipOrigin(CGFloat height) {
    NSAffineTransform *tx = [NSAffineTransform transform];
    [tx translateXBy:0 yBy:height];
    [tx scaleXBy:1.0 yBy:-1.0];
    [tx concat];
    return tx;
}

NSAffineTransform *PGFlipOriginForImageRep(NSImageRep *img) {
    return PGFlipOrigin(img.size.height);
}

void PGTransparentBackground(NSRect rect) {
    PGFillBackground(rect, [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0]);
}

void PGFillBackground(NSRect rect, NSColor *backgroundColor) {
    [NSGraphicsContext saveGraphicsState];
    NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRect:rect];
    [backgroundColor setFill];
    [rectanglePath fill];
    [NSGraphicsContext restoreGraphicsState];
}

NSPoint PGGetOffsetPointOnEllipse(NSSize *ellipseSize, CGFloat angle, NSSize *offset) {
    NSPoint ellipsePoint = PGGetPointOnEllipse(ellipseSize, angle);
    ellipsePoint.x += offset->width;
    ellipsePoint.y += offset->height;
    return ellipsePoint;
}

NSPoint PGGetPointOnEllipse(NSSize *ellipseSize, CGFloat angle) {
    NSPoint ellipsePoint;
    CGFloat a = (ellipseSize->width * 0.5);
    CGFloat b = (ellipseSize->height * 0.5);

    /* Are we an ellipse? */
    if(a == b) {
        /* No, we're a circle and that makes life a little easier. */
        ellipsePoint.x = (cos(angle) * a);
        ellipsePoint.y = (sin(angle) * b);
    }
    else {
        /* Credit: https://math.stackexchange.com/questions/22064/calculating-a-point-that-lies-on-an-ellipse-given-an-angle */
        CGFloat t  = tan(angle = PGNormalizeAngle(angle));
        BOOL    ix = ((angle > M_PI_2) && (angle < M_2PI));
        BOOL    iy = ((angle > M_PI) && (angle < M_3PI_2));
        CGFloat t2 = (t * t);
        CGFloat a2 = (a * a);
        CGFloat b2 = (b * b);
        CGFloat ab = (a * b);

        ellipsePoint.x = ((ix ? -ab : ab) / sqrt(b2 + (a2 * t2)));
        ellipsePoint.y = ((iy ? -ab : ab) / sqrt(a2 + (b2 / t2)));
    }

    return ellipsePoint;
}

CGFloat PGNormalizeAngle(CGFloat angle) {
    CGFloat angle2 = atan2(sin(angle), cos(angle));
    return ((angle2 < 0.0) ? (angle2 + (2 * M_PI)) : angle2);
}

PGPolar PGMakePolar(CGFloat radius, CGFloat angle) {
    PGPolar p;
    p.r = radius;
    p.a = angle;
    return p;
}

NSPoint PGPolarToNSPoint(PGPolar p) {
    NSPoint pnt;
    pnt.x = (p.r * cos(p.a));
    pnt.y = (p.r * sin(p.a));
    return pnt;
}

PGPolar NSPointToPGPolar(NSPoint pnt) {
    PGPolar p;
    p.r = sqrt((pnt.x * pnt.x) + (pnt.y * pnt.y));
    p.a = atan2(pnt.y, pnt.x);
    return p;
}

NSBitmapImageRep *PGCreateBitmapImageRepOfSize(NSSize size) {
    return PGCreateBitmapImageRep(size.width, size.height);
}

NSBitmapImageRep *PGCreateBitmapImageRep(CGFloat width, CGFloat height) {
    return [[NSBitmapImageRep alloc]
                              initWithBitmapDataPlanes:NULL
                                            pixelsWide:(NSInteger)ceil(width)
                                            pixelsHigh:(NSInteger)ceil(height)
                                         bitsPerSample:8
                                       samplesPerPixel:4
                                              hasAlpha:YES
                                              isPlanar:NO
                                        colorSpaceName:NSDeviceRGBColorSpace
                                          bitmapFormat:NSBitmapFormatAlphaFirst
                                           bytesPerRow:(NSInteger)(width * 4)
                                          bitsPerPixel:32];
}

NSData *PGConvertToPNG(NSBitmapImageRep *bmp) {
    return PGConvertToInterlacedPNG(bmp, NO);
}

NSData *PGConvertToInterlacedPNG(NSBitmapImageRep *bmp, BOOL interlaced) {
    return [bmp representationUsingType:NSBitmapImageFileTypePNG properties:@{ NSImageInterlaced: @(interlaced ? 1 : 0) }];
}

BOOL PGSaveAsPNG(NSBitmapImageRep *bmp, NSString *filename, NSError **error) {
    return [PGConvertToPNG(bmp) writeToFile:filename options:0 error:error];
}

double PGRandom(void) {
    dispatch_once(&_randomOnce_, ^{ srandom((unsigned int)(time(NULL) % 0x100000000)); });
    // random() returns an integer between 0 <= r <= 2147483647.  We're going
    // to convert it to a double value between 0.0 <= r < 1.0.
    long r = (((random() & 1) << 62) | (random() << 31) | random());
    return ((double)r / 9223372036854775808.0);
}

NSUInteger PGRandomUInt(NSUInteger max) {
    return (NSUInteger)(PGRandom() * max);
}

NSUInteger PGBitsRequired(NSUInteger n) {
    NSUInteger br = 0;
    while(n) {
        n = (n >> 1);
        br++;
    }
    return br;
}

NSNotificationCenter *PGNotificationCenter(void) {
    dispatch_once(&_pgNotificationOnce_, ^{ _pgNotificationCenter_ = [NSNotificationCenter new]; });
    return _pgNotificationCenter_;
}

Class PGCommonSuperclass(Class c1, Class c2) {
    Class _c2 = c2;

    while(c1) {
        while(c2) {
            if(c1 == c2) return c2;
            c2 = class_getSuperclass(c2);
        }

        c1 = class_getSuperclass(c1);
        c2 = _c2;
    }

    return nil;
}

BOOL PGCanCompare(id o1, id o2) {
    Class c1     = object_getClass(o1);
    Class c2     = object_getClass(o2);
    Class common = PGCommonSuperclass(c1, c2);
    return (common && class_respondsToSelector(common, @selector(compare:)));
}

NSComparisonResult PGCompare(id o1, id o2) {
    if(PGEqu(o1, o2)) return NSOrderedSame;
    else if(o1 && !o2) return NSOrderedDescending;
    else if(o2 && !o1) return NSOrderedAscending;
    else if(PGCanCompare(o1, o2)) return [o1 compare:o2];
    else {
        NSString *o1s    = NSStringFromClass([o1 class]);
        NSString *o2s    = NSStringFromClass([o2 class]);
        NSString *reason = PGFormat(PGLocalizedString(@"PGErrorUnableToCompareObjects"), o1s, o2s);
        @throw PGMakeException(PGComparisonException, PGF, reason);
    }
}

NSComparisonResult PGStrCmp(NSString *s1, NSString *s2) {
    return ((s1 == s2) ? NSOrderedSame : ((s1 && s2) ? [s1 compare:s2] : (s1 ? NSOrderedDescending : NSOrderedAscending)));
}

NSString *PGFormat(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *str = PGFormat2(format, args);
    va_end(args);
    return str;
}

NSString *PGAppend(NSUInteger numberOfObjects, ...) {
    NSMutableString *str = [NSMutableString new];
    va_list         args;

    va_start(args, numberOfObjects);
    for(NSUInteger i = 0; i < numberOfObjects; i++) {
        NSObject *obj = va_arg(args, NSObject *);
        if(obj) [str appendString:obj.description];
    }
    va_end(args);

    return str;
}

NSString *PGLocalizedString(NSString *key) {
    static NSBundle        *_bundle = nil;
    static dispatch_once_t _pred    = 0;
    dispatch_once(&_pred, ^{ _bundle = [NSBundle bundleForClass:[PGDOMNode class]]; });
    return [_bundle localizedStringForKey:key value:@"" table:nil];
}

NSString *PGLocalizedFormat(NSString *formatKey, ...) {
    va_list args;
    va_start(args, formatKey);
    NSString *format = PGLocalizedString(formatKey);
    NSString *str    = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return str;
}

NSException *PGMakeException(NSExceptionName name, NSString *reasonFormat, ...) {
    va_list args;
    va_start(args, reasonFormat);

    NSString     *reason = [[NSString alloc] initWithFormat:reasonFormat arguments:args];
    NSDictionary *info   = @{ NSLocalizedDescriptionKey: reason };
    NSException  *e      = [NSException exceptionWithName:name reason:reason userInfo:info];

    va_end(args);
    return e;
}

NSException *PGMakeRangeException(NSUInteger index, NSUInteger max) {
    return PGMakeException(NSRangeException, PGF, PGFormat(PGErrorMsgBadIndex, @(index), @(max)));
}

NSError *PGMakeError(NSInteger code, NSString *description, ...) {
    va_list args;
    va_start(args, description);
    NSString *strDesc = (description.length ? PGFormat2(description, args) : PGErrorUnknown);
    va_end(args);
    return [NSError errorWithDomain:PGRandolphDomain code:code userInfo:@{ NSLocalizedDescriptionKey: strDesc }];
}

void PGLog(NSString *format, ...) {
    va_list a;
    va_start(a, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:a];
    if(DEBUG) NSLog(@"%@", str);
    va_end(a);
}

NSString *PGErrorString(int eno) {
    size_t bsize = 8192;
    char   *buf  = (char *)malloc(bsize);

    @try {
        do {
            if(!buf) {
                return PGErrorOutOfMemory;
            }
            else {
                int i = strerror_r(eno, buf, bsize);

                if(i == 0) {
                    return [NSString stringWithUTF8String:buf];
                }
                else if(((i < 0) ? errno : i) == ERANGE) {
                    free(buf);
                    buf = (char *)malloc(bsize *= 2);
                }
                else {
                    return PGErrorUnknown;
                }
            }
        }
        while(bsize < NSIntegerMax);
    }
    @finally {
        if(buf) free(buf);
    }

    return PGErrorUnknown;
}

@implementation NSObject(Randolph)

    -(BOOL)isInstanceOf:(Class)cls {
        return [self isKindOfClass:cls];
    }

    -(Class)superclassInCommonWith:(id)object {
        if(object) {
            Class c1 = [self class];

            while(c1) {
                Class c2 = object_getClass(object);

                while(c2) {
                    if(c1 == c2) return c2;
                    c2 = class_getSuperclass(c2);
                }

                c1 = class_getSuperclass(c1);
            }
        }

        return nil;
    }

    -(BOOL)canCompareTo:(id)object {
        Class common = [self superclassInCommonWith:object];
        return (common && class_respondsToSelector(common, @selector(compare:)));
    }

@end

@implementation NSString(Randolph)

    -(NSString *)nilIfEmpty {
        return (self.length ? self : nil);
    }

    -(NSRect)getTextBounds:(NSRect)rect fontAttributes:(NSDictionary<NSAttributedStringKey, id> *)fontAttrs {
        CGFloat textHeight = NSHeight([self boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttrs]);
        return NSMakeRect(NSMinX(rect), NSMinY(rect) + (NSHeight(rect) - textHeight) / 2, NSWidth(rect), textHeight);
    }

    -(NSRect)drawInside:(NSRect)rect fontAttributes:(NSDictionary<NSAttributedStringKey, id> *)fontAttrs {
        [NSGraphicsContext saveGraphicsState];

        @try {
            NSRectClip(rect);
            NSRect textRect = [self getTextBounds:rect fontAttributes:fontAttrs];
            [self drawInRect:textRect withAttributes:fontAttrs];
            return textRect;
        }
        @finally {
            [NSGraphicsContext restoreGraphicsState];
        }
    }

    -(NSString *)trim {
        return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }

    -(NSArray<NSString *> *)split:(NSString *)pattern {
        return [self split:pattern limit:0];
    }

    -(NSArray<NSString *> *)split:(NSString *)pattern limit:(NSInteger)limit {
        NSUInteger selflen = self.length;
        if((limit == 1) || (selflen == 0)) return @[ self ];

        NSError             *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if(regex == nil) {
            NSString *msg = (error ? error.localizedDescription : PGErrorRegex);
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:msg userInfo:nil];
        }

        NSMutableArray<NSString *> *arr = [NSMutableArray new];
        __block NSUInteger         p    = 0;
        __block NSUInteger         l    = 0;

        [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, selflen) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange  rng  = result.range;
            NSString *str = [self substringWithRange:NSMakeRange(p, rng.location)];

            [arr addObject:str];
            p = (rng.location + rng.length);

            NSUInteger arrlen = arr.count;

            if(str.length) l = arrlen;

            if((limit > 0) && ((arr.count + 1) == limit)) {
                [arr addObject:[self substringWithRange:NSMakeRange(p, (selflen - p))]];
                *stop = YES;
            }
        }];

        if(arr.count == 0) return @[ self ];
        if((limit == 0) && (l < arr.count)) return [arr subarrayWithRange:NSMakeRange(0, l)];
        return arr;
    }

@end

@implementation NSMutableArray(Randolph)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

    -(id)pop {
        if(self.count) {
            id obj = self.lastObject;
            [self removeLastObject];
            return obj;
        }

        @throw [NSException exceptionWithName:NSObjectNotAvailableException reason:PGErrorEmptyArray userInfo:nil];
    }

    -(id)popObjectAtIndex:(NSUInteger)index {
        id obj = self[index];
        [self removeObjectAtIndex:index];
        return obj;
    }

    -(id)push {
        return (self.count ? [self lastObject] : nil);
    }

    -(void)setPush:(id)obj {
        [self addObject:obj];
    }

#pragma clang diagnostic pop

@end

@implementation NSRegularExpression(Randolph)

    -(NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)str options:(NSMatchingOptions)options {
        return [self matchesInString:str options:options range:NSMakeRange(0, str.length)];
    }

    -(NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)str {
        return [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    }

    -(BOOL)matchesEntireString:(NSString *)str options:(NSMatchingOptions)options results:(NSTextCheckingResult **)results {
        NSUInteger                      slen = str.length;
        NSArray<NSTextCheckingResult *> *ar  = [self matchesInString:str options:options range:NSMakeRange(0, slen)];
        NSTextCheckingResult            *res = ((ar.count == 1) ? ar[0] : nil);
        if(results) *results = res;
        return (res && (res.range.location == 0) && (res.range.length == slen));
    }

    -(BOOL)matchesEntireString:(NSString *)str results:(NSTextCheckingResult **)results {
        return [self matchesEntireString:str options:0 results:results];
    }

    -(BOOL)matchesEntireString:(NSString *)str {
        return [self matchesEntireString:str options:0 results:nil];
    }

    -(BOOL)matchesEntireString:(NSString *)str options:(NSMatchingOptions)options {
        return [self matchesEntireString:str options:options results:nil];
    }

    +(NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern error:(NSError **)error {
        return [self regularExpressionWithPattern:pattern options:0 error:error];
    }

    +(NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options {
        NSError             *error = nil;
        NSRegularExpression *regex = [self regularExpressionWithPattern:pattern options:options error:&error];
        if(error && !regex) @throw [NSException exceptionWithName:NSParseErrorException reason:WHICH(error.localizedDescription, PGErrorRegex) userInfo:nil];
        return regex;
    }

    +(NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern {
        return [self regularExpressionWithPattern:pattern options:0];
    }

    +(NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error {
        static NSMutableDictionary<NSString *, NSRegularExpression *> *_cache = nil;
        static dispatch_once_t                                        _flag   = 0;

        NSString *key = PGFormat(@"%@Ð%@", pattern, @(options));
        dispatch_once(&_flag, ^{ _cache = [NSMutableDictionary new]; });

        @synchronized(_cache) {
            NSRegularExpression *regex = _cache[key];

            if(!regex) {
                regex = [self regularExpressionWithPattern:pattern options:options error:error];
                if(regex) _cache[key] = regex;
            }

            return regex;
        }
    }

    +(NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern error:(NSError **)error {
        return [self cachedRegexWithPattern:pattern options:0 error:error];
    }

    +(NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options {
        NSError             *error = nil;
        NSRegularExpression *regex = [self cachedRegexWithPattern:pattern options:options error:&error];
        if(error && !regex) @throw [NSException exceptionWithName:NSParseErrorException reason:WHICH(error.localizedDescription, PGErrorRegex) userInfo:nil];
        return regex;
    }

    +(NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern {
        return [self cachedRegexWithPattern:pattern options:0];
    }

@end

@implementation NSImageRep(Randolph)

    -(void)drawWithTransparencyAt:(NSPoint)location {
        [self drawWithTransparencyAtX:location.x Y:location.y];
    }

    -(void)drawWithTransparencyAtX:(CGFloat)x Y:(CGFloat)y {
        NSSize sz = self.size;
        [self drawInRect:NSMakeRect(x, y, sz.width, sz.height)
                fromRect:NSMakeRect(0, 0, sz.width, sz.height)
               operation:NSCompositingOperationSourceOver
                fraction:1.0
          respectFlipped:NO
                   hints:@{}];
    }

@end

@implementation NSBezierPath(Randolph)

    +(instancetype)bezierPathWithCircle:(NSPoint)p radius:(CGFloat)radius {
        return [NSBezierPath bezierPathWithOvalInRect:PGMakeSquare(p, radius * 2.0)];
    }

    +(instancetype)bezierPathWithCircle:(NSPoint)p diameter:(CGFloat)diameter {
        return [NSBezierPath bezierPathWithOvalInRect:PGMakeSquare(p, diameter)];
    }

    +(instancetype)bezierPathWithCircle:(NSPoint)p offset:(NSPoint)offset radius:(CGFloat)radius {
        return [NSBezierPath bezierPathWithOvalInRect:NSOffsetRect(PGMakeSquare(p, radius * 2.0), offset.x, offset.y)];
    }

    +(instancetype)bezierPathWithCircle:(NSPoint)p offset:(NSPoint)offset diameter:(CGFloat)diameter {
        return [NSBezierPath bezierPathWithOvalInRect:NSOffsetRect(PGMakeSquare(p, diameter), offset.x, offset.y)];
    }

@end

@implementation NSStream(Randolph)

    -(BOOL)isStatusEOF {
        return (self.streamStatus == NSStreamStatusAtEnd);
    }

    -(BOOL)isStatusNotOpen {
        return (self.streamStatus == NSStreamStatusNotOpen);
    }

    -(BOOL)isStatusOpening {
        return (self.streamStatus == NSStreamStatusOpening);
    }

    -(BOOL)isStatusOpen {
        return (self.streamStatus == NSStreamStatusOpen);
    }

    -(BOOL)isStatusClosed {
        return (self.streamStatus == NSStreamStatusClosed);
    }

    -(BOOL)isStatusReading {
        return (self.streamStatus == NSStreamStatusReading);
    }

    -(BOOL)isStatusWriting {
        return (self.streamStatus == NSStreamStatusWriting);
    }

    -(BOOL)isStatusError {
        return (self.streamStatus == NSStreamStatusError);
    }

    -(NSString *)streamDirection {
        return (([self isKindOfClass:[NSInputStream class]]) ? PGMsgInput : (([self isKindOfClass:[NSOutputStream class]]) ? PGMsgOutput : PGMsgIO));
    }

    -(BOOL)testStreamStatus:(NSError **)error {
        if(self.streamError) {
            PGSetError(error, self.streamError);
            return NO;
        }

        PGSetError(error, nil);

        switch(self.streamStatus) {
            case NSStreamStatusNotOpen:
                PGSetError(error, PGMakeError(1300, PGErrorMsgNSStream, self.streamDirection, PGMsgNotOpen));
                return NO;
            case NSStreamStatusOpening:
                while(self.streamStatus == NSStreamStatusOpening);
                return [self testStreamStatus:error];
            case NSStreamStatusReading:
                PGSetError(error, PGMakeError(1300, PGErrorMsgNSStream, self.streamDirection, PGMsgBusyReading));
                return NO;
            case NSStreamStatusWriting:
                PGSetError(error, PGMakeError(1300, PGErrorMsgNSStream, self.streamDirection, PGMsgBusyWriting));
                return NO;
            case NSStreamStatusAtEnd:
                PGSetError(error, nil);
                return NO;
            case NSStreamStatusClosed:
                PGSetError(error, PGMakeError(1300, PGErrorMsgNSStream, self.streamDirection, PGMsgClosed));
                return NO;
            case NSStreamStatusError:
                break;
            case NSStreamStatusOpen:
                return YES;
        }

        PGSetError(error, (self.streamError ?: PGMakeError(1300, PGErrorMsgNSStreamUnknown, self.streamDirection)));
        return NO;
    }

@end

