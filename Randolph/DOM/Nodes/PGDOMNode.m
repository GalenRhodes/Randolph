/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNode.m
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
#import "PGDOMUserData.h"

@implementation PGDOMNode {
        NSUInteger _flags;
    }

    @synthesize ownerDocument = _ownerDocument;
    @synthesize userDataMap = _userDataMap;

    -(instancetype)init {
        return (self = [self initWithOwnerDocument:nil]);
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument {
        self = [super init];

        if(self) {
            _userDataMap   = [NSMutableDictionary new];
            _ownerDocument = ownerDocument;
            _flags         = 0;
        }

        return self;
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMSyncData;
        PGDOMSyncChildren;
        PGDOMNode *copy = [((PGDOMNode *)[[self class] allocWithZone:zone]) initWithOwnerDocument:_ownerDocument];

        if(copy != nil) {
            copy->_flags = _flags;
        }

        return copy;
    }

    -(instancetype)copy {
        return [self copy:NO];
    }

    -(instancetype)copy:(BOOL)deep {
        return [self copyWithZone:nil];
    }

    /**
     * When an object is being deallocated it should remove itself from the notifications list.
     */
    -(void)dealloc {
        [PGNotificationCenter() removeObserver:self];
        for(PGDOMUserData *ud in self.userDataMap.allValues) {
            @try { if(ud.handlerBlock) ud.handlerBlock(PGDOM_USERDATA_NODE_REMOVED, ud.key, ud.data, nil, nil); } @catch(NSException *e) { /* Ignore */ }
        }
    }

    -(BOOL)hasNamespace {
        return NO;
    }

    -(BOOL)hasFlag:(PGDOMIntFlags)flag {
        return ((_flags & flag) == flag);
    }

    -(void)setFlag:(PGDOMIntFlags)flag value:(BOOL)value {
        _flags = (value ? (_flags | flag) : (_flags & ~flag));
    }

    -(BOOL)needsSyncData {
        return [self hasFlag:PGDOMIntFlag_SyncData];
    }

    -(void)setNeedsSyncData:(BOOL)value {
        [self setFlag:PGDOMIntFlag_SyncData value:value];
    }

    -(BOOL)needsSyncChildren {
        return [self hasFlag:PGDOMIntFlag_SyncChildren];
    }

    -(void)setNeedsSyncChildren:(BOOL)value {
        [self setFlag:PGDOMIntFlag_SyncChildren value:value];
    }

    -(BOOL)isReadOnly {
        return [self hasFlag:PGDOMIntFlag_ReadOnly];
    }

    -(void)setIsReadOnly:(BOOL)value {
        [self setFlag:PGDOMIntFlag_ReadOnly value:value];
    }

    -(BOOL)isNormalized {
        return [self hasFlag:PGDOMIntFlag_Normalized];
    }

    -(void)setIsNormalized:(BOOL)value {
        [self setFlag:PGDOMIntFlag_Normalized value:value];
    }

    -(BOOL)isIgnorableWhitespace {
        return [self hasFlag:PGDOMIntFlag_IgnorableWhitespace];
    }

    -(void)setIsIgnorableWhitespace:(BOOL)value {
        [self setFlag:PGDOMIntFlag_IgnorableWhitespace value:value];
    }

    -(BOOL)isOwned {
        return [self hasFlag:PGDOMIntFlag_Owned];
    }

    -(void)setIsOwned:(BOOL)value {
        [self setFlag:PGDOMIntFlag_Owned value:value];
    }

    -(PGDOMNodeType)nodeType {
        return PGDOMNodeTypeNone;
    }

    -(NSString *)nodeName {
        return @"";
    }

    -(NSString *)localName {
        return nil;
    }

    -(NSString *)namespaceURI {
        return nil;
    }

    -(NSString *)prefix {
        return nil;
    }

    -(void)setPrefix:(NSString *)prefix {
    }

    -(NSString *)nodeValue {
        return nil;
    }

    -(void)setNodeValue:(NSString *)nodeValue {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNoSettingValue);
    }

    -(NSString *)textContent {
        return @"";
    }

    -(void)setTextContent:(NSString *)textContent {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotTextNode);
    }

    -(PGDOMNode *)firstChild {
        return nil;
    }

    -(PGDOMNode *)lastChild {
        return nil;
    }

    -(BOOL)hasAttributes {
        return NO;
    }

    -(BOOL)hasChildNodes {
        return NO;
    }

    -(PGDOMNamedNodeMap *)attributes {
        return [[PGDOMNamedNodeMap alloc] init];
    }

    -(PGDOMNodeList *)childNodes {
        return [[PGDOMNodeList alloc] init];
    }

    -(PGDOMNode *)addChildNode:(PGDOMNode *)newNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)insertChildNode:(PGDOMNode *)newNode beforeNode:(PGDOMNode *)refNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)replaceChildNode:(PGDOMNode *)oldNode withNode:(PGDOMNode *)newNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(PGDOMNode *)removeChildNode:(PGDOMNode *)node {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotParentNode);
    }

    -(void)nodeHierarchyChanged {
        [self.parentNode nodeHierarchyChanged];
    }

    -(PGDOMNode *)parentNode {
        return nil;
    }

    -(PGDOMNode *)nextSibling {
        return nil;
    }

    -(PGDOMNode *)prevSibling {
        return nil;
    }

    -(void)setParentNode:(PGDOMNode *)parentNode {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

    -(void)setNextSibling:(PGDOMNode *)nextSibling {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

    -(void)setPrevSibling:(PGDOMNode *)prevSibling {
        @throw PGMakeDOMException(PGDOMErrorNotSupported, PGF, PGDOMErrorMsgNotChildNode);
    }

    -(void)synchronizeData {
        self.needsSyncData = NO;
    }

    -(void)synchronizeChildren {
        self.needsSyncChildren = NO;
    }

    -(void)normalize {
        self.isNormalized = YES;
    }

    -(id)setUserData:(id)data forKey:(NSString *)key {
        return [self setUserData:data forKey:key handlerBlock:nil];
    }

    -(id)setUserData:(id)data forKey:(NSString *)key handler:(id<PGDOMUserDataHandler>)handler {
        return [self setUserData:data forKey:key handlerBlock:(handler ? ^(PGDOMUserDataEvent o, NSString *k, id d, PGDOMNode *s, PGDOMNode *t) {
            [handler handleOperation:o key:k data:d source:s destination:t];
        } : nil)];
    }

    -(id)setUserData:(id)data forKey:(NSString *)key handlerBlock:(PGDOMUserDataHandlerBlock)block {
        if(!key) @throw PGMakeException(NSInvalidArgumentException, @"User data key is null.");
        PGDOMUserData *ud = [self userData:key];
        if(data) self.userDataMap[key] = [PGDOMUserData dataWithData:data forKey:key handlerBlock:block];
        else if(ud) [self.userDataMap removeObjectForKey:key];
        return ud.data;
    }

    -(id)userData:(NSString *)key {
        return self.userDataMap[key].data;
    }

    -(void)postUserDataEvent:(PGDOMUserDataEvent)event src:(PGDOMNode *)src dest:(PGDOMNode *)dest {
        for(PGDOMUserData *ud in self.userDataMap.allValues) {
            @try { if(ud.handlerBlock) ud.handlerBlock(event, ud.key, ud.data, src, dest); } @catch(NSException *e) {}
        }
    }

    -(void)postNodeAdoptedUserDataNotification {
        [self postUserDataEvent:PGDOM_USERDATA_NODE_ADOPTED src:self dest:nil];
    }

    -(void)postNodeImportedUserDataNotification:(PGDOMNode *)clone {
        [self postUserDataEvent:PGDOM_USERDATA_NODE_IMPORTED src:self dest:clone];
    }

    -(void)postNodeClonedUserDataNotification:(PGDOMNode *)clone {
        [self postUserDataEvent:PGDOM_USERDATA_NODE_CLONED src:self dest:clone];
    }

@end
