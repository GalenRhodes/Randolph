/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNamedNodeMap.m
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
#import "PGDOMNamedKey.h"
#import "PGFastEnumState.h"

typedef PGTreeNode<NSString *, PGDOMNode *>                *TreeNode;
typedef PGTreeNode<NamedKey, PGDOMNode *>                  *TreeNodeNS;
typedef NSMutableDictionary<NSNumber *, PGFastEnumState *> *EnumStates;

@interface PGDOMNamedNodeMap()

    @property(nonatomic) TreeNode   mapRoot;
    @property(nonatomic) TreeNodeNS mapRootNS;
    @property(nonatomic) EnumStates fastEnumStates;
    @property(nonatomic)/*    */ NSUInteger lastEnumStateId;
    @property(nonatomic)/*    */ NSUInteger updateCount;

@end

@interface PGDOMLiveAttributeMap : PGDOMNamedNodeMap

    -(instancetype)initWithElement:(PGDOMElement *)elem attribs:(AttrTNode)attribs;

    -(void)handleElementAttribsDidChange:(NSNotification *)notice;

@end

@implementation PGDOMNamedNodeMap {
        NSRecursiveLock *_lock;
    }

    @synthesize mapRoot = _mapRoot;
    @synthesize mapRootNS = _mapRootNS;
    @synthesize updateCount = _updateCount;
    @synthesize fastEnumStates = _fastEnumStates;
    @synthesize lastEnumStateId = _lastEnumStateId;

    -(instancetype)init {
        self = [super init];

        if(self) {
            _updateCount     = 0;
            _lastEnumStateId = 0;
            _lock            = [NSRecursiveLock new];
        }

        return self;
    }

    -(void)lock {
        [_lock lock];
    }

    -(void)unlock {
        [_lock unlock];
    }

    -(NSUInteger)count {
        [self lock];
        @try { return self.mapRoot.count; }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)itemForNodeName:(NSString *)nodeName {
        [self lock];
        @try { return [self.mapRoot nodeForKey:nodeName].value; }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)itemForLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { return [self.mapRootNS nodeForKey:[PGDOMNamedKey keyWithName:localName namespaceURI:namespaceURI]].value; }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)objectAtIndexedSubscript:(NSUInteger)index {
        [self lock];
        @try {
            PGDOMNode *n = [self.mapRoot nodeAtIndex:index].value;
            if(!n) @throw PGMakeException(NSRangeException, PGErrorMsgBadIndex2, @(index), @(self.mapRootNS.count));
            return n;
        }
        @finally { [self unlock]; }
    }

    -(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer count:(NSUInteger)len {
        [self lock];
        @try {
            NSUInteger      cc         = 0;
            PGFastEnumState *enumState = nil;

            if(self.mapRootNS) {
                if(state->state == 0) {
                    if(_fastEnumStates == nil) _fastEnumStates = [NSMutableDictionary new];
                    state->state        = ++_lastEnumStateId;
                    state->mutationsPtr = &_updateCount;
                    _fastEnumStates[@((NSUInteger)state->state)] = enumState = [[PGFastEnumState alloc] initWithTree:self.mapRoot];
                }
                else {
                    enumState = _fastEnumStates[@((NSUInteger)state->state)];
                }

                if((cc = [enumState enumerateWithObjects:buffer count:len]) == 0) [_fastEnumStates removeObjectForKey:@((NSUInteger)state->state)];
            }

            return cc;
        }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)itemAtIndex:(NSUInteger)index {
        return self[index];
    }

    -(PGDOMNode *)forEach:(BOOL (^)(PGDOMNode *node))block {
        for(PGDOMNode *node in self) {
            if(block(node)) return node;
        }
        return nil;
    }

    -(PGDOMNode *)removeItemForNodeName:(NSString *)nodeName {
        [self lock];
        @try { return [self _removeItem:[self.mapRoot nodeForKey:nodeName].value]; }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)removeItemForLocalName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        [self lock];
        @try { return [self _removeItem:[self.mapRootNS nodeForKey:[PGDOMNamedKey keyWithName:localName namespaceURI:namespaceURI]].value]; }
        @finally { [self unlock]; }
    }

    -(PGDOMNode *)removeNamedItem:(PGDOMNode *)item {
        [self lock];
        @try { return [self _removeItem:item]; }
        @finally { [self unlock]; }
    }

    -(void)removeAll {
        [self lock];
        @try {
            [self.mapRootNS removeAllWithAction:^(PGDOMNamedKey *key, PGDOMNode *value) {
                if(value) [PGNotificationCenter() removeObserver:self name:PGDOMNamedNodeDidChange object:value];
            }];
        }
        @finally {
            [self unlock];
            [self postChangeNotification];
        }
    }

    -(PGDOMNode *)setNamedItem:(PGDOMNode *)item {
        [self lock];
        @try {
            return [self _setNamedItem:item];
        }
        @finally {
            [self unlock];
            [self postChangeNotification];
        }
    }

    -(void)postChangeNotification {
        @try {
            ++self.updateCount;
            [PGNotificationCenter() postNotificationName:PGDOMNamedNodeMapDidChange object:self];
        }
        @catch(NSException *exception) {
            /* Ignore */
        }
    }

    -(void)handleNamedNodeDidChange:(NSNotification *)notice {
        if([PGDOMNamedNodeDidChange isEqualToString:notice.name]) {
            NSDictionary *ui = notice.userInfo;
            [self processNodeNameChange:ui[PGDOMRenameEventNodeKey]
                               nodeName:ui[PGDOMRenameEventOrigNodeNameKey]
                              localName:ui[PGDOMRenameEventOrigLocalNameKey]
                           namespaceURI:ui[PGDOMRenameEventOrigNamespaceURIKey]];
        }
    }

    -(void)processNodeNameChange:(PGDOMNode *)node nodeName:(NSString *)origNodeName localName:(NSString *)origLocalName namespaceURI:(NSString *)origNamespaceURI {
        if(node) {
            PGDOMNode *oNode = (origNodeName.length ? [self.mapRoot nodeForKey:origNodeName].value : nil);
            if(!oNode && origLocalName.length) oNode = [self.mapRootNS nodeForKey:[PGDOMNamedKey keyWithName:origLocalName namespaceURI:origNamespaceURI]].value;
            if(oNode) [self _removeItem:oNode];

            [self _setNamedItem:node];
        }
    }

    +(instancetype)nodeMapWithNSArray:(NSArray<PGDOMNode *> *)array {
        PGDOMNamedNodeMap *nodeMap = [[self alloc] init];

        for(PGDOMNode *node in array) {
            [nodeMap setNamedItem:node];
        }

        return nodeMap;
    }

    +(instancetype)nodeMapWithElement:(PGDOMElement *)elem attribs:(AttrTNode)attribs {
        return [[PGDOMLiveAttributeMap alloc] initWithElement:elem attribs:attribs];
    }

    -(PGDOMNode *)_setNamedItem:(PGDOMNode *)item {
        if(item) {
            PGDOMNamedKey *key  = [PGDOMNamedKey keyWithNode:item];
            TreeNodeNS    root  = self.mapRootNS;
            TreeNodeNS    tnode = [root nodeForKey:key];
            PGDOMNode     *node = tnode.value;

            if(tnode) {
                if(node == item) {
                    /*
                     * We're adding an item that we already have so nothing is changing so just return nil.
                     */
                    return nil;
                }
                else {
                    /*
                     * We're replacing an item that has the same key.
                     */
                    [PGNotificationCenter() removeObserver:self name:PGDOMNamedNodeDidChange object:node];
                    tnode.value = item;
                }
            }
            else if(root) {
                self.mapRootNS = [root insertValue:item forKey:key];
            }
            else {
                self.mapRootNS = [PGTreeNode nodeWithValue:item forKey:key];
            }

            [PGNotificationCenter() addObserver:self selector:@selector(handleNamedNodeDidChange:) name:PGDOMNamedNodeDidChange object:item];
            return node;
        }
        /*
         * No item means nothing to do.
         */
        return nil;
    }

    -(PGDOMNode *)_removeItem:(PGDOMNode *)item {
        if(item) {
            TreeNode  tNode   = [self.mapRoot nodeForKey:item.nodeName];
            PGDOMNode *_fItem = tNode.value;

            if(tNode) {
                if(_fItem) [PGNotificationCenter() removeObserver:self name:PGDOMNamedNodeDidChange object:_fItem];
                self.mapRoot = [tNode remove];

                if(item.hasNamespace) {
                    TreeNodeNS tNodeNS = [self.mapRootNS nodeForKey:[PGDOMNamedKey keyWithName:item.localName namespaceURI:item.namespaceURI]];

                    if(tNodeNS) {
                        if(tNodeNS.value && _fItem != tNodeNS.value) [PGNotificationCenter() removeObserver:self name:PGDOMNamedNodeDidChange object:tNodeNS.value];
                        self.mapRootNS = [tNodeNS remove];
                    }
                }
            }
            return _fItem;
        }
        return nil;
    }

@end

@implementation PGDOMLiveAttributeMap {
    }

    -(instancetype)initWithElement:(PGDOMElement *)elem attribs:(AttrTNode)attribs {
        self = [super init];

        if(self) {
            [PGNotificationCenter() addObserver:self selector:@selector(handleElementAttribsDidChange:) name:PGDOMElementAttribsDidChange object:elem];
            [PGNotificationCenter() postNotificationName:PGDOMElementAttribsDidChange object:elem userInfo:@{}];
        }

        return self;
    }

    -(void)dealloc {
        [PGNotificationCenter() removeObserver:self];
    }

    -(void)handleElementAttribsDidChange:(NSNotification *)notice {
        NSString  *changeName = notice.userInfo[PGDOMAttribEventNameKey];
        PGDOMAttr *attr       = notice.userInfo[PGDOMAttribEventNodeKey];

        if(attr && changeName) {
            if([AttribEventAdd isEqualToString:changeName]) {
                [self setNamedItem:attr];
            }
            else if([AttribEventRemove isEqualToString:changeName]) {
                [self removeNamedItem:attr];
            }
            else if([AttribEventIsID isEqualToString:changeName]) {
                /*Do Nothing*/
            }
        }
    }

@end
