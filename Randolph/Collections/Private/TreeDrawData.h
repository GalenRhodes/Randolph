/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: TreeDrawData.h
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

#ifndef ____TREEDRAWDATA_H____
#define ____TREEDRAWDATA_H____

#import <Cocoa/Cocoa.h>
#import <Randolph/PGTreeNode.h>

@interface PGTreeNodeGUIData : NSObject

    @property(nonatomic, readonly) NSColor      *colorRed;
    @property(nonatomic, readonly) NSColor      *colorBlack;
    @property(nonatomic, readonly) NSColor      *colorBorder;
    @property(nonatomic, readonly) NSColor      *colorText;
    @property(nonatomic, readonly) NSColor      *colorLine;
    @property(nonatomic, readonly) NSColor      *colorNodeShadow;
    @property(nonatomic, readonly) NSColor      *colorLineShadow;
    @property(nonatomic, readonly) NSColor      *colorBackground;
    @property(nonatomic, readonly) NSShadow     *shadowNode;
    @property(nonatomic, readonly) NSShadow     *shadowLine;
    @property(nonatomic, readonly) NSDictionary *textFontAttrs;

    +(instancetype)instance;

@end

@interface PGTreeNodeDrawData : NSObject

    @property(nonatomic, readonly) NSRect            *nodeRect;
    @property(nonatomic, readonly) PGTreeNodeGUIData *guiData;

@end

@interface PGTreeNode()

    @property(nonatomic) PGTreeNodeDrawData *drawData;

@end

#endif // ____TREEDRAWDATA_H____
