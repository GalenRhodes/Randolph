/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNodeList.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/17/19
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

#import "PGDOMPrivate.h"
#import "PGEmptyEnumerator.h"

@interface PGDOMParentNodeList : PGDOMNodeList<NSLocking>

    -(instancetype)initWithParentNode:(PGDOMParent *)pnode;

    -(void)loadChildNodes:(PGDOMParent *)pnode;

    -(void)handleHierarchyChangeNotification:(NSNotification *)notification;

@end

@implementation PGDOMNodeList {
    }

    -(instancetype)init {
        return (self = [super init]);
    }

    -(NSEnumerator<PGDOMNode *> *)nodeEnumerator {
        return [PGEmptyEnumerator new];
    }

    -(NSUInteger)count {
        return 0;
    }

    -(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer count:(NSUInteger)len {
        return 0;
    }

    -(PGDOMNode *)objectAtIndexedSubscript:(NSUInteger)idx {
        @throw PGMakeException(NSRangeException, PGF, PGFormat(PGErrorMsgBadIndex, @(idx), @(self.count - 1)));
    }

    +(instancetype)listWithParentNode:(PGDOMParent *)pnode {
        return [[PGDOMParentNodeList alloc] initWithParentNode:pnode];
    }

    -(void)dealloc {
        [PGNotificationCenter() removeObserver:self];
    }

@end

@implementation PGDOMParentNodeList {
        NSMutableArray<PGDOMNode *> *_nodeList;
        NSRecursiveLock             *_lock;
    }

    -(instancetype)initWithParentNode:(PGDOMParent *)pnode {
        self = [super init];

        if(self) {
            _lock     = [NSRecursiveLock new];
            _nodeList = [NSMutableArray new];
            [self loadChildNodes:pnode];
            [PGNotificationCenter() addObserver:self selector:@selector(handleHierarchyChangeNotification:) name:PGDOMNodeHierarchyDidChange object:pnode];
        }

        return self;
    }

    -(void)loadChildNodes:(PGDOMParent *)pnode {
        [pnode lock];
        @try {
            PGDOMNode *n = pnode.firstChild;
            while(n) {
                [_nodeList addObject:n];
                n = n.nextSibling;
            }
        }
        @finally { [pnode unlock]; }
    }

    -(void)handleHierarchyChangeNotification:(NSNotification *)notification {
        PGDOMParent *pnode = notification.object;

        if(pnode && [PGDOMNodeHierarchyDidChange isEqualToString:notification.name]) {
            [self lock];
            @try {
                [_nodeList removeAllObjects];
                [self loadChildNodes:pnode];
            }
            @finally { [self unlock]; }
        }
    }

    -(NSEnumerator<PGDOMNode *> *)nodeEnumerator {
        return _nodeList.objectEnumerator;
    }

    -(void)lock {
        [_lock lock];
    }

    -(void)unlock {
        [_lock unlock];
    }

    -(NSUInteger)count {
        /*@f:0*/NSUInteger cc = 0; [self lock]; @try { cc = _nodeList.count; } @finally { [self unlock]; } return cc;/*@f:1*/
    }

    -(PGDOMNode *)objectAtIndexedSubscript:(NSUInteger)idx {
        /*@f:0*/PGDOMNode *n = nil; [self lock]; @try { n = _nodeList[idx]; } @finally { [self unlock]; } return n;/*@f:1*/
    }

    -(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer count:(NSUInteger)len {
        /*@f:0*/NSUInteger cc = 0; [self lock]; @try { cc = [_nodeList countByEnumeratingWithState:state objects:buffer count:len]; } @finally { [self unlock]; } return cc;/*@f:1*/
    }

@end
