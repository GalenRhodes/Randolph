/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTools.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2019-06-09
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

#ifndef __RANDOLPH_PGTOOLS_H__
#define __RANDOLPH_PGTOOLS_H__

#import <Randolph/PGDefines.h>
#import <Randolph/PGIndexedList.h>
#import <math.h>

#define PGEqu(o1, o2)    (((o1) == (o2)) || ((o1) && (o2) && [(o1) isEqual:(o2)]))
#define PGStrEqu(s1, s2) (((s1) == (s2)) || ((s1) && (s2) && [(s1) isEqualToString:(s2)]))
#define WHICH(s1, s2)    ((s1).length ? (s1) : (s2))

/* Even though these might be more useful as long doubles,
   POSIX requires that they be double-precision literals.                */
#define M_2PI    4.71238898038468985769396507491925432 /* (2 * PI)       */
#define M_3PI_2  6.28318530717958647692528676655900576 /* (3 * (PI / 2)) */
#define M_PI_180 0.01745329251994329508812465664990832 /* (PI / 180) aka - 1 degree */

NS_ASSUME_NONNULL_BEGIN

typedef struct __pg_polar__ {
    CGFloat r; // radius
    CGFloat a; // angle (in radians)
} PGPolar;

typedef void (^PGDrawingBlock)(NSSize size);

typedef u_int8_t PGByte;
typedef PGByte   *pPGByte;

@interface NSObject(Randolph)

    /****************************************************************************************************************************************************//**
     * Since I can never remember the difference between @selector(isKindOfClass) and @selector(isMemberOfClass) I created this
     * method which is easier for me to remember. It calls @selector(isKindOfClass) and behaves the same as the Java operator
     * "instanceof".
     *
     * @param cls The class.
     * @return YES if the receiver is an instance of the given class or an instance of any class that inherits from that class.
     */
    -(BOOL)isInstanceOf:(Class)cls;

    -(nullable Class)superclassInCommonWith:(id)object;

    -(BOOL)canCompareTo:(id)object;

@end

@interface NSString(Randolph)

    -(nullable NSString *)nilIfEmpty;

    -(NSRect)getTextBounds:(NSRect)rect fontAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)fontAttrs;

    -(NSRect)drawInside:(NSRect)rect fontAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)fontAttrs;

    -(NSString *)trim;

    -(NSArray<NSString *> *)split:(NSString *)pattern;

    -(NSArray<NSString *> *)split:(NSString *)pattern limit:(NSInteger)limit;

@end

@interface NSMutableArray<ObjectType>(Randolph)

    @property(nonatomic) ObjectType push;

    -(ObjectType)pop;

    -(ObjectType)popObjectAtIndex:(NSUInteger)index;

@end

@interface NSRegularExpression(Randolph)

    +(nullable NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern;

    +(nullable NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern error:(NSError **)error;

    +(nullable NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options;

    +(nullable NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern;

    +(nullable NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern error:(NSError **)error;

    +(nullable NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options;

    +(nullable NSRegularExpression *)cachedRegexWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error;

    -(BOOL)matchesEntireString:(NSString *)str;

    -(BOOL)matchesEntireString:(NSString *)str options:(NSMatchingOptions)options;

    -(BOOL)matchesEntireString:(NSString *)str results:(NSTextCheckingResult *__nullable *__nullable)results;

    -(NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)str options:(NSMatchingOptions)options;

    -(NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)str;

    -(BOOL)matchesEntireString:(NSString *)str options:(NSMatchingOptions)options results:(NSTextCheckingResult *__nullable *__nullable)results;

@end

@interface NSImageRep(Randolph)

    -(void)drawWithTransparencyAt:(NSPoint)location;

    -(void)drawWithTransparencyAtX:(CGFloat)x Y:(CGFloat)y;

@end

@interface NSBezierPath(Randolph)

    +(instancetype)bezierPathWithCircle:(NSPoint)p radius:(CGFloat)radius;

    +(instancetype)bezierPathWithCircle:(NSPoint)p diameter:(CGFloat)diameter;

    +(instancetype)bezierPathWithCircle:(NSPoint)p offset:(NSPoint)offset radius:(CGFloat)radius;

    +(instancetype)bezierPathWithCircle:(NSPoint)p offset:(NSPoint)offset diameter:(CGFloat)diameter;

@end

@interface NSStream(Randolph)

    @property(nonatomic, readonly) BOOL     isStatusEOF;
    @property(nonatomic, readonly) BOOL     isStatusNotOpen;
    @property(nonatomic, readonly) BOOL     isStatusOpening;
    @property(nonatomic, readonly) BOOL     isStatusOpen;
    @property(nonatomic, readonly) BOOL     isStatusClosed;
    @property(nonatomic, readonly) BOOL     isStatusReading;
    @property(nonatomic, readonly) BOOL     isStatusWriting;
    @property(nonatomic, readonly) BOOL     isStatusError;
    @property(nonatomic, readonly) NSString *streamDirection;

    -(BOOL)testStreamStatus:(NSError **)error;

@end

FOUNDATION_EXPORT NSRect PGCenterRects(NSRect outer, NSSize inner);

FOUNDATION_EXPORT CGFloat PGGetScaling(NSSize srcSize, NSSize dstSize);

FOUNDATION_EXPORT NSImageRep *PGDrawOnOffscreenImage(NSSize imageSize, PGDrawingBlock block);

FOUNDATION_EXPORT NSAffineTransform *PGFlipOrigin(CGFloat height);

FOUNDATION_EXPORT NSAffineTransform *PGFlipOriginForImageRep(NSImageRep *img);

FOUNDATION_EXPORT void PGTransparentBackground(NSRect rect);

FOUNDATION_EXPORT void PGFillBackground(NSRect rect, NSColor *backgroundColor);

FOUNDATION_EXPORT NSBitmapImageRep *PGCreateBitmapImageRepOfSize(NSSize size);

FOUNDATION_EXPORT NSBitmapImageRep *PGCreateBitmapImageRep(CGFloat width, CGFloat height);

FOUNDATION_EXPORT NSData *PGConvertToInterlacedPNG(NSBitmapImageRep *bmp, BOOL interlaced);

FOUNDATION_EXPORT NSData *PGConvertToPNG(NSBitmapImageRep *bmp);

FOUNDATION_EXPORT BOOL PGSaveAsPNG(NSBitmapImageRep *bmp, NSString *filename, NSError **error);

/***************************************************************************************************//**
 * This function takes an angle (in radians) and normalizes it so that it's value is between
 * 0 <= ⍬ < 2𝜋.
 *
 * @param angle the angle in radians.
 * @return the same angle normalized to fall in the range 0 <= ⍬ < 2𝜋.
 */
FOUNDATION_EXPORT CGFloat PGNormalizeAngle(CGFloat angle);

FOUNDATION_EXPORT PGPolar PGMakePolar(CGFloat radius, CGFloat angle);

FOUNDATION_EXPORT NSPoint PGPolarToNSPoint(PGPolar p);

FOUNDATION_EXPORT PGPolar NSPointToPGPolar(NSPoint pnt);

FOUNDATION_EXPORT NSPoint PGGetPointOnEllipse(NSSize *ellipseSize, CGFloat angle);

FOUNDATION_EXPORT NSPoint PGGetOffsetPointOnEllipse(NSSize *ellipseSize, CGFloat angle, NSSize *offset);

FOUNDATION_EXPORT double PGRandom(void);

FOUNDATION_EXPORT NSUInteger PGRandomUInt(NSUInteger max);

FOUNDATION_EXPORT NSUInteger PGBitsRequired(NSUInteger n);

FOUNDATION_EXPORT NSString *PGFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

FOUNDATION_EXPORT NSString *PGFormat2(NSString *format, va_list args) NS_FORMAT_FUNCTION(1, 0);

FOUNDATION_EXPORT NSString *PGAppend(NSUInteger numberOfObjects, ...);

FOUNDATION_EXPORT NSComparisonResult PGCompare(id __nullable o1, id __nullable o2);

FOUNDATION_EXPORT NSComparisonResult PGStrCmp(NSString *__nullable s1, NSString *__nullable s2);

FOUNDATION_EXPORT Class PGCommonSuperclass(Class __nullable c1, Class __nullable c2);

FOUNDATION_EXPORT BOOL PGCanCompare(id o1, id o2);

FOUNDATION_EXPORT NSString *PGLocalizedString(NSString *key);

FOUNDATION_EXPORT NSString *PGLocalizedFormat(NSString *formatKey, ...);

FOUNDATION_EXPORT NSException *PGMakeException(NSExceptionName name, NSString *reasonFormat, ...) NS_FORMAT_FUNCTION(2, 3);

FOUNDATION_EXPORT NSException *PGMakeRangeException(NSUInteger index, NSUInteger max);

FOUNDATION_EXPORT NSNotificationCenter *PGNotificationCenter(void);

FOUNDATION_EXPORT NSError *PGMakeError(NSInteger code, NSString *description, ...) NS_FORMAT_FUNCTION(2, 3);

FOUNDATION_EXPORT void PGLog(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

NS_INLINE NSError *PGSetError(NSError *__nullable *__nullable pError, NSError *__nullable error) {
    if(pError) *pError = error;
    return error;
}

NS_INLINE NSRect PGMakeSquare2(CGFloat x, CGFloat y, CGFloat s) {
    return NSMakeRect(x, y, s, s);
}

NS_INLINE NSRect PGMakeSquare(NSPoint p, CGFloat s) {
    return NSMakeRect(p.x, p.y, s, s);
}

NS_INLINE NSRect PGMakeRect(NSPoint p, NSSize s) {
    return NSMakeRect(p.x, p.y, s.width, s.height);
}

NS_INLINE NSPoint PGOffsetPoint(NSPoint p, CGFloat dx, CGFloat dy) {
    return NSMakePoint(p.x + dx, p.y + dy);
}

NS_INLINE BOOL PGHasCompare(id key) {
    return [((NSObject *)key) respondsToSelector:@selector(compare:)];
}

NS_INLINE NSString *PGSubstr(NSString *__nullable str, NSRange range) {
    return ((range.location == NSNotFound) ? nil : [str substringWithRange:range]);
}

NS_INLINE NSUInteger PGMaxRange(NSRange r) {
    return (r.location + r.length);
}

NS_INLINE void *PGCheckMemory(void *buffer, NSString *__nullable failureReason) {
    if(!buffer) @throw PGMakeException(NSMallocException, PGF, (failureReason ?: PGErrorOutOfMemory));
    return buffer;
}

NS_INLINE void *PGMalloc(NSUInteger size, NSString *__nullable failureReason) {
    return PGCheckMemory(malloc((size_t)size), (failureReason ?: PGFormat(PGErrorNotEnoughtMemory, size)));
}

NS_INLINE void *PGRealloc(void *__nullable buffer, NSUInteger size, NSString *__nullable failureReason) {
    return PGCheckMemory(realloc(buffer, (size_t)size), (failureReason ?: PGFormat(PGErrorNotEnoughtMemory, size)));
}

NS_INLINE BOOL PGRangesEqual(NSRange *r1, NSRange *r2) {
    return ((r1 == r2) || (r1 && r2 && (r1->location == r2->location) && (r1->length == r2->length)));
}

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGTOOLS_H__
