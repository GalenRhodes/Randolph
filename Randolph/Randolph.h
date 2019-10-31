/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: Randolph.h
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

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT double RandolphVersionNumber;
FOUNDATION_EXPORT const unsigned char RandolphVersionString[];

#import <Randolph/sem_timedwait.h>
#import <Randolph/PGSemaphore.h>
#import <Randolph/PGIndexedList.h>
#import <Randolph/PGTreeNode.h>
#import <Randolph/PGDOMTools.h>
#import <Randolph/PGDOMNode.h>
#import <Randolph/PGDOMNode.h>
#import <Randolph/PGDOMText.h>
#import <Randolph/PGDOMCData.h>
#import <Randolph/PGDOMComment.h>
#import <Randolph/PGDOMElement.h>
#import <Randolph/PGDOMAttr.h>
#import <Randolph/PGDOMDocument.h>
#import <Randolph/PGDOMDocumentFragment.h>
#import <Randolph/PGDOMDocumentType.h>
#import <Randolph/PGDOMProcessingInstruction.h>
#import <Randolph/PGDOMNotation.h>
#import <Randolph/PGDOMEntity.h>
#import <Randolph/PGDOMEntityReference.h>
#import <Randolph/PGDOMLocator.h>
#import <Randolph/PGDOMNamedNodeMap.h>
#import <Randolph/PGDOMNodeList.h>
#import <Randolph/PGTreeNode+PGTreeNodeDraw.h>
#import <Randolph/PGByteBuffer.h>
#import <Randolph/PGURLBufferElement.h>
