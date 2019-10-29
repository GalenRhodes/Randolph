/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTreeNode+PGTreeNodeDraw.h
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

#ifndef __RANDOLPH_PGTREENODE_PGTREENODEDRAW_H__
#define __RANDOLPH_PGTREENODE_PGTREENODEDRAW_H__

#import <Cocoa/Cocoa.h>
#import <Randolph/PGTreeNode.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGTreeNode(PGTreeNodeDraw)

    -(NSData *)drawTree;

    -(BOOL)drawTree:(NSString *)filename error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGTREENODE_PGTREENODEDRAW_H__
