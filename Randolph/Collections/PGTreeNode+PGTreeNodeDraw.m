/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTreeNode+PGTreeNodeDraw.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/10/19
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

#import "PGTreeNode+PGTreeNodeDraw.h"
#import "PGTools.h"
#import "TreeDrawData.h"

#define PGDrawTextFont         @"IBMPlexSerif"
#define PGDrawTextSize         30
#define PGNodeDiameter         200.0
#define PGNodeRadius           100.0
#define PGNodeHeight           230.0
#define PGNodeWidth            240.0
#define PGNodeWidth_2          120.0
#define PGNodeBufferX_2        20.0
#define PGNodeBufferY_2        15.0
#define PGChildLineDotRad      4.0
#define PGChildLineDotDiam     8.0
#define PGAngle90              -M_PI_2
#define PGAngle210             -3.665191429188092
#define PGAngle330             -5.759586531581288
#define PGChildLineCPYOffset   -50.0
#define PGChildLineWidth       3.0
#define PGNodeBorderWidth      5.0
#define PGNodeShadowOffset     10.1
#define PGNodeShadowBlurRadius 17.0
#define PGLineShadowOffset     5.1
#define PGLineShadowBlurRadius 5.0

static const NSPoint PGDotRad   = { .x = -PGChildLineDotRad, .y = -PGChildLineDotRad };
static const NSSize  PGNodeSize = { .width = PGNodeDiameter, .height = PGNodeDiameter };
static const NSSize  PGDrawSize = { .width = PGNodeWidth, .height = PGNodeHeight };

NS_INLINE NSPoint PGCenter(NSRect r, NSSize s) {
    NSPoint p;
    p.x = (r.origin.x + ((r.size.width - s.width) * 0.5));
    p.y = (r.origin.y + ((r.size.height - s.height) * 0.5));
    return p;
}

@implementation PGTreeNode(PGTreeNodeDraw)

    -(NSRect)calculateMyBounds:(NSPoint)loc {
        NSRect     drawRect = { .origin = loc, .size = PGDrawSize };
        NSPoint    nx       = PGCenter(drawRect, PGNodeSize);
        NSPoint    cp       = PGOffsetPoint(loc, 0, drawRect.size.height);
        PGTreeNode *lc      = self.leftChild;
        PGTreeNode *rc      = self.rightChild;

        if(lc) {
            NSRect r = [lc calculateMyBounds:cp];
            cp.x                 = NSMaxX(r);
            nx.x                 = (cp.x - PGNodeRadius);
            drawRect.size.width  = (r.size.width + PGNodeWidth_2);
            drawRect.size.height = (drawRect.size.height + r.size.height);
        }
        else cp.x = (nx.x + PGNodeRadius);

        if(rc) {
            NSRect r = [rc calculateMyBounds:cp];
            drawRect.size.width  = (NSMaxX(r) - loc.x);
            drawRect.size.height = MAX(drawRect.size.height, (NSMaxY(r) - loc.y));
        }

        if(!self.drawData) self.drawData = [PGTreeNodeDrawData new];
        self.drawData.nodeRect->origin = nx;
        return drawRect;
    }

    -(void)drawNode {
        [(self.isRed ? self.drawData.guiData.colorRed : self.drawData.guiData.colorBlack) setFill];
        [self.drawData.guiData.colorBorder setStroke];

        NSBezierPath *ovalPath = [NSBezierPath bezierPathWithOvalInRect:*self.drawData.nodeRect];
        [NSGraphicsContext saveGraphicsState];
        [self.drawData.guiData.shadowNode set];
        [ovalPath fill];
        [NSGraphicsContext restoreGraphicsState];
        [ovalPath setLineWidth:PGNodeBorderWidth];
        [ovalPath stroke];

        [PGDrawOnOffscreenImage(self.drawData.nodeRect->size, ^(NSSize size) {
            PGFlipOrigin(size.height);
            [[self.key description] drawInside:NSMakeRect(0, 0, size.width, size.height) fontAttributes:self.drawData.guiData.textFontAttrs];
        }) drawWithTransparencyAt:self.drawData.nodeRect->origin];

        PGTreeNode *lc = self.leftChild;
        if(lc) {
            [lc drawNode];
            [self drawChildArc:lc.drawData.nodeRect leftChild:YES];
        }

        PGTreeNode *rc = self.rightChild;
        if(rc) {
            [rc drawNode];
            [self drawChildArc:rc.drawData.nodeRect leftChild:NO];
        }
    }

    -(void)drawChildArc:(NSRect *)childRect leftChild:(BOOL)isLeft {
        NSPoint myLinePoint    = [self calcLinePoint:self.drawData.nodeRect angle:(isLeft ? PGAngle210 : PGAngle330)];
        NSPoint childLinePoint = [self calcLinePoint:childRect angle:PGAngle90];

        [self.drawData.guiData.colorLine setStroke];
        [self.drawData.guiData.colorLine setFill];

        NSBezierPath *bezierPath = [NSBezierPath bezierPath];
        [bezierPath moveToPoint:myLinePoint];
        [bezierPath curveToPoint:childLinePoint controlPoint1:PGOffsetPoint(childLinePoint, 0, PGChildLineCPYOffset) controlPoint2:childLinePoint];
        [NSGraphicsContext saveGraphicsState];
        [self.drawData.guiData.shadowLine set];
        [bezierPath setLineWidth:PGChildLineWidth];
        [bezierPath stroke];
        [NSGraphicsContext restoreGraphicsState];

        NSBezierPath *ovalPath = [NSBezierPath bezierPathWithCircle:myLinePoint offset:PGDotRad diameter:PGChildLineDotDiam];
        [ovalPath fill];
        [ovalPath stroke];

        ovalPath = [NSBezierPath bezierPathWithCircle:childLinePoint offset:PGDotRad diameter:PGChildLineDotDiam];
        [ovalPath fill];
        [ovalPath stroke];
    }

    -(NSData *)drawTree {
        /*
         * The first thing we need to do is figure out how big our tree is going to be.
         * From this we can size the image accordingly.
         */
        NSRect            bounds = [self calculateMyBounds:NSMakePoint(0, 0)];
        NSBitmapImageRep  *img   = PGCreateBitmapImageRepOfSize(bounds.size);
        NSGraphicsContext *oldgc = [NSGraphicsContext currentContext];

        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:img]];

        PGFillBackground(NSMakeRect(0, 0, bounds.size.width, bounds.size.height), self.drawData.guiData.colorBackground);
        PGFlipOrigin(bounds.size.height);

        [self drawNode];
        [NSGraphicsContext restoreGraphicsState];
        [NSGraphicsContext setCurrentContext:oldgc];

        return PGConvertToPNG(img);
    }

    -(BOOL)drawTree:(NSString *)filename error:(NSError **)error {
        NSError *_error = nil;

        if(filename.length) {
            NSData *data = [self drawTree];
            BOOL   res   = [data writeToFile:filename.stringByExpandingTildeInPath options:0 error:&_error];
            PGSetError(error, _error);
            return res;
        }

        return NO;
    }

    -(NSPoint)calcLinePoint:(NSRect *)rect angle:(CGFloat)angle {
        NSSize offset = NSMakeSize((rect->origin.x + (rect->size.width * 0.5)), (rect->origin.y + (rect->size.height * 0.5)));
        return PGGetOffsetPointOnEllipse(&rect->size, angle, &offset);
    }

@end

@implementation PGTreeNodeDrawData {
        NSRect _nodeRect;
    }

    -(NSRect *)nodeRect {
        return &_nodeRect;
    }

    -(instancetype)init {
        self = [super init];

        if(self) {
            _nodeRect.origin.x    = 0;
            _nodeRect.origin.y    = 0;
            _nodeRect.size.width  = PGNodeDiameter;
            _nodeRect.size.height = PGNodeDiameter;
        }

        return self;
    }

    -(PGTreeNodeGUIData *)guiData {
        return [PGTreeNodeGUIData instance];
    }

@end

@implementation PGTreeNodeGUIData {
    }

    @synthesize colorRed = _colorRed;
    @synthesize colorBlack = _colorBlack;
    @synthesize colorBorder = _colorBorder;
    @synthesize colorText = _colorText;
    @synthesize colorLine = _colorLine;
    @synthesize colorNodeShadow = _colorNodeShadow;
    @synthesize colorLineShadow = _colorLineShadow;
    @synthesize colorBackground = _colorBackground;
    @synthesize shadowNode = _shadowNode;
    @synthesize shadowLine = _shadowLine;
    @synthesize textFontAttrs = _textFontAttrs;

    -(instancetype)init {
        self = [super init];

        if(self) {
            _colorRed        = [NSColor colorWithCalibratedRed:0.8 green:0.32 blue:0.32 alpha:1];
            _colorBlack      = [NSColor colorWithCalibratedRed:0.452 green:0.452 blue:0.452 alpha:1];
            _colorBorder     = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:1];
            _colorText       = [NSColor colorWithCalibratedRed:1 green:0.997 blue:0.729 alpha:1];
            _colorLine       = [NSColor colorWithCalibratedRed:0.224 green:0.262 blue:0.722 alpha:1];
            _colorNodeShadow = [NSColor.blackColor colorWithAlphaComponent:0.6];
            _colorLineShadow = [NSColor.blackColor colorWithAlphaComponent:0.71];
            _colorBackground = [NSColor colorWithCalibratedRed:0.872 green:0.872 blue:0.872 alpha:1];

            _shadowNode = [NSShadow new];
            [self.shadowNode setShadowColor:self.colorNodeShadow];
            [self.shadowNode setShadowOffset:NSMakeSize(PGNodeShadowOffset, -PGNodeShadowOffset)];
            [self.shadowNode setShadowBlurRadius:PGNodeShadowBlurRadius];

            _shadowLine = [[NSShadow alloc] init];
            [self.shadowLine setShadowColor:self.colorLineShadow];
            [self.shadowLine setShadowOffset:NSMakeSize(PGLineShadowOffset, -PGLineShadowOffset)];
            [self.shadowLine setShadowBlurRadius:PGLineShadowBlurRadius];

            NSMutableParagraphStyle *textStyle = [NSMutableParagraphStyle new];
            textStyle.alignment = NSTextAlignmentCenter;

            _textFontAttrs = @{
                NSFontAttributeName           : [NSFont fontWithName:PGDrawTextFont size:PGDrawTextSize], // font name and size
                NSForegroundColorAttributeName: self.colorText,                                           // foreground color
                NSParagraphStyleAttributeName : textStyle                                                 // alignment
            };
        }

        return self;
    }

    +(PGTreeNodeGUIData *)instance {
        static PGTreeNodeGUIData *_guiData    = nil;
        static dispatch_once_t   _guiDataOnce = 0;
        dispatch_once(&_guiDataOnce, ^{ _guiData = [PGTreeNodeGUIData new]; });
        return _guiData;
    }

@end
