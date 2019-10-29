/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTreeNode.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 9/28/19
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

#import "PGFastEnumState.h"
#import "PGTreeNode.h"
#import "PGTools.h"
#import "TreeDrawData.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

static const NSUInteger PG_MASK_RED_NODE     = 9223372036854775808lu;
static const NSUInteger PG_MASK_STOP_RECOUNT = 4611686018427387904lu;
static const NSUInteger PG_MASK_COUNT        = 4611686018427387903lu;

void balanceRemove(PGTreeNode *n);

PGTreeNode *balanceInsert(PGTreeNode *n);

PGTreeNode *nodeForKey(PGTreeNode *n, id key);

PGTreeNode *insert(PGTreeNode *n, id<NSCopying> key, id value);

void recount(PGTreeNode *n);

@interface PGTreeNode()

    @property(nonatomic, copy)/**/ id         key;
    @property(nonatomic)/*      */ BOOL       isRed;
    @property(nonatomic)/*      */ PGTreeNode *parentNode;
    @property(nonatomic)/*      */ PGTreeNode *leftChild;
    @property(nonatomic)/*      */ PGTreeNode *rightChild;
    @property(nonatomic, readonly) PGTreeNode *rootNode;
    @property(nonatomic)/*      */ NSUInteger count;
    @property(nonatomic)/*      */ BOOL       stopRecount;

    -(instancetype)initWithValue:(id)value forKey:(id<NSCopying>)key isRed:(BOOL)isRed;

    -(void)branchDepth:(NSUInteger)cDepth maxDepth:(NSUInteger *)mDepth;

@end

NS_INLINE void makeEmpty(PGTreeNode *n) {
    n.isRed      = NO;
    n.leftChild  = nil;
    n.rightChild = nil;
    n.parentNode = nil;
}

NS_INLINE PGTreeNode *makeOrphan(PGTreeNode *n) {
    PGTreeNode *p = n.parentNode;
    if(p) { if(n == p.leftChild) p.leftChild = nil; else p.rightChild = nil; }
    return n;
}

NS_INLINE PGTreeNode *replace(PGTreeNode *oldNode, PGTreeNode *newNode) {
    PGTreeNode *p = oldNode.parentNode;
    if(p) { if(oldNode == p.leftChild) p.leftChild = newNode; else p.rightChild = newNode; } else makeOrphan(newNode);
    return oldNode;
}

@implementation PGTreeNode {
        NSUInteger _flags;
    }

    @synthesize key = _key;
    @synthesize value = _value;
    @synthesize parentNode = _parentNode;
    @synthesize leftChild = _leftChild;
    @synthesize rightChild = _rightChild;
    @synthesize drawData = _drawData;

    -(instancetype)initWithValue:(id)value forKey:(id<NSCopying>)key isRed:(BOOL)isRed {
        self = [super init];

        if(self) {
            if(!value) @throw PGMakeException(NSInvalidArgumentException, PGErrorMsgObjectIsNull, PGMsgValue);
            if(!key)
                @throw
                    PGMakeException(NSInvalidArgumentException, PGErrorMsgObjectIsNull, PGMsgKey);
            if(![((NSObject *)key) respondsToSelector:@selector(compare:)]) PGMakeException(NSInvalidArgumentException, PGErrorMsgNoSelector, PGMsgKey, PGMsgSelectorCompare);

            _flags = 0;
            _value = value;
            _key   = [key copyWithZone:nil];

            self.count = 1;
            self.isRed = isRed;
        }

        return self;
    }

    +(instancetype)nodeWithValue:(id)value forKey:(id<NSCopying>)key {
        return [[self alloc] initWithValue:value forKey:key isRed:NO];
    }

    -(BOOL)isRed {
        return ((_flags & PG_MASK_RED_NODE) == PG_MASK_RED_NODE);
    }

    -(void)setIsRed:(BOOL)f {
        _flags = (f ? (_flags | PG_MASK_RED_NODE) : (_flags & ~PG_MASK_RED_NODE));
    }

    -(BOOL)stopRecount {
        return ((_flags & PG_MASK_STOP_RECOUNT) == PG_MASK_STOP_RECOUNT);
    }

    -(void)setStopRecount:(BOOL)f {
        _flags = (f ? (_flags | PG_MASK_STOP_RECOUNT) : (_flags & ~PG_MASK_STOP_RECOUNT));
    }

    -(NSUInteger)count {
        return (_flags & PG_MASK_COUNT);
    }

    -(void)setCount:(NSUInteger)i {
        _flags = ((_flags & ~PG_MASK_COUNT) | (i & PG_MASK_COUNT));
    }

    -(void)setLeftChild:(PGTreeNode *)node {
        if(_leftChild != node) {
            _leftChild.parentNode                      = nil;
            (_leftChild = makeOrphan(node)).parentNode = self;
            recount(self);
        }
    }

    -(void)setRightChild:(PGTreeNode *)node {
        if(_rightChild != node) {
            _rightChild.parentNode                      = nil;
            (_rightChild = makeOrphan(node)).parentNode = self;
            recount(self);
        }
    }

    -(void)branchDepth:(NSUInteger)cDepth maxDepth:(NSUInteger *)mDepth {
        NSUInteger d = (cDepth + 1);
        [self.leftChild branchDepth:d maxDepth:mDepth];
        [self.rightChild branchDepth:d maxDepth:mDepth];
        *mDepth = MAX(cDepth, *mDepth);
    }

    -(NSUInteger)branchDepth {
        NSUInteger mDepth = 0;
        [self branchDepth:1 maxDepth:&mDepth];
        return mDepth;
    }

    -(PGTreeNode *)rootNode {
        PGTreeNode *n = self;
        while(n.parentNode) n = n.parentNode;
        return n;
    }

    -(PGTreeNode *)nodeForKey:(id)key {
        return ((key && PGHasCompare(key)) ? nodeForKey(self, key) : nil);
    }

    -(PGTreeNode *)remove {
        PGTreeNode *lc = self.leftChild;
        PGTreeNode *rc = self.rightChild;

        if(lc && rc) {
            while(rc.leftChild) rc = rc.leftChild;
            self.key   = rc.key;
            self.value = rc.value;
            return [rc remove];
        }
        else if(self.isRed) {
            PGTreeNode *rt = self.rootNode;
            makeOrphan(self);
            makeEmpty(self);
            return rt;
        }
        else {
            PGTreeNode *p = self.parentNode;
            PGTreeNode *c = (lc ?: rc);

            if(c.isRed) c.isRed = NO; else balanceRemove(self);
            replace(self, c);
            makeEmpty(self);
            return (p ?: c).rootNode;
        }
    }

    -(PGTreeNode *)insertValue:(id)value forKey:(id<NSCopying>)key {
        if(!value) PGMakeException(NSInvalidArgumentException, PGErrorMsgObjectIsNull, PGMsgValue);
        if(!key) PGMakeException(NSInvalidArgumentException, PGErrorMsgObjectIsNull, PGMsgKey);
        if(!PGHasCompare(key)) PGMakeException(NSInvalidArgumentException, PGErrorMsgNoSelector, PGMsgKey, PGMsgSelectorCompare);
        return insert(self, key, value);
    }

    -(void)removeAll {
        [self.leftChild removeAll];
        [self.rightChild removeAll];
        makeEmpty(self);
    }

    -(void)removeAllWithAction:(void (^)(id key, id value))actionBlock {
        [self.leftChild removeAllWithAction:actionBlock];
        @try { actionBlock(self.key, self.value); } @catch(NSException *exception) {}
        [self.rightChild removeAllWithAction:actionBlock];
        makeEmpty(self);
    }

    -(void)toNSArray:(NSMutableArray<id> *)array {
        [self.leftChild toNSArray:array];
        [array addObject:self.value];
        [self.rightChild toNSArray:array];
    }

    -(BOOL)doForEach:(BOOL (^)(id key, id value))block {
        if(![self.leftChild doForEach:block]) {
            if(!block(self.key, self.value)) {
                return [self.rightChild doForEach:block];
            }
        }

        return YES;
    }

    -(NSUInteger)index {
        PGTreeNode *p = self.parentNode;

        if(p) {
            NSUInteger pi = p.index;
            return ((self == p.leftChild) ? (pi - self.leftChild.count - 1) : (pi + self.leftChild.count + 1));
        }

        return self.leftChild.count;
    }

    -(PGTreeNode *)nodeAtIndex:(NSUInteger)index {
        NSInteger c = (((NSInteger)index) - ((NSInteger)self.index));
        return ((c == 0) ? self : [((c < 0) ? self.leftChild : self.rightChild) nodeAtIndex:index]);
    }


@end

NS_INLINE void rot(PGTreeNode *n, PGTreeNode *c, BOOL toTheLeft) {
    BOOL ir = c.isRed;
    c.isRed = n.isRed;
    n.isRed = ir;
    replace(n, c);
    if(toTheLeft) {
        n.rightChild = c.leftChild;
        c.leftChild  = n;
    }
    else {
        n.leftChild  = c.rightChild;
        c.rightChild = n;
    }
}

PGTreeNode *rotate(PGTreeNode *n, BOOL toTheLeft) {
    PGTreeNode *c = (toTheLeft ? n.rightChild : n.leftChild);
    if(!c) @throw PGMakeException(NSInvalidArgumentException, PGErrorMsgNoNodeRotation, (toTheLeft ? PGMsgLeft : PGMsgRight));
    PGTreeNode *p = n.parentNode;
    p.stopRecount = YES;
    @try { rot(n, c, toTheLeft); } @finally { p.stopRecount = NO; }
    return n;
}

NS_INLINE void balanceRemoveStep2(PGTreeNode *p, PGTreeNode *s, BOOL slr, BOOL srr, BOOL left) {
    if(slr || srr) {
        if((left == slr) && (left != srr)) rotate(s, !left);
        (left ? p.rightChild.rightChild : p.leftChild.leftChild).isRed = NO;
        rotate(p, left);
    }
    else {
        s.isRed = YES;
        if(p.isRed) p.isRed = NO; else balanceRemove(p);
    }
}

NS_INLINE PGTreeNode *balanceRemoveStep1(PGTreeNode *p, BOOL left) {
    PGTreeNode *s = (left ? p.rightChild : p.leftChild);

    if(s.isRed) {
        rotate(p, left);
        s = (left ? p.rightChild : p.leftChild);
    }

    return s;
}

void balanceRemove(PGTreeNode *n) {
    PGTreeNode *p = n.parentNode;

    if(p) {
        BOOL       left = (n == p.leftChild);
        PGTreeNode *s   = balanceRemoveStep1(p, left);
        balanceRemoveStep2(p, s, s.leftChild.isRed, s.rightChild.isRed, left);
    }
}

PGTreeNode *balanceInsert(PGTreeNode *n) {
    PGTreeNode *p = n.parentNode;

    if(p) {
        if(p.isRed) {
            PGTreeNode *g = p.parentNode;
            BOOL       sl = (n == p.leftChild);
            BOOL       pr = (p == g.rightChild);
            PGTreeNode *u = (pr ? g.leftChild : g.rightChild);

            if(u.isRed) {
                u.isRed = p.isRed = !(g.isRed = YES);
                balanceInsert(g);
            }
            else if(sl == pr) {
                rotate(p, !sl);
                rotate(g, sl);
            }
            else {
                rotate(g, !sl);
            }
        }
    }
    else n.isRed = NO;

    return n.rootNode;
}

void recount(PGTreeNode *n) {
    while(n) {
        if(n.stopRecount) break;
        n.count = (1 + n.leftChild.count + n.rightChild.count);
        n = n.parentNode;
    }
}

PGTreeNode *nodeForKey(PGTreeNode *n, id key) {
    while(n) {
        NSComparisonResult cr = [n.key compare:key];
        if(cr == NSOrderedAscending) n = n.rightChild;
        else if(cr == NSOrderedDescending) n = n.leftChild;
        else return n;
    }
    return nil;
}

PGTreeNode *insert(PGTreeNode *n, id<NSCopying> key, id value) {
    while(n) {
        NSComparisonResult cr = [n.key compare:((id)(key))];

        if(cr == NSOrderedAscending) {
            if(n.rightChild) n = n.rightChild; else return balanceInsert(n.rightChild = [[PGTreeNode alloc] initWithValue:value forKey:key isRed:YES]);
        }
        else if(cr == NSOrderedDescending) {
            if(n.leftChild) n = n.leftChild; else return balanceInsert(n.leftChild = [[PGTreeNode alloc] initWithValue:value forKey:key isRed:YES]);
        }
        else {
            n.value = value;
            return n.rootNode;
        }
    }
    return nil;
}

#pragma clang diagnostic pop
