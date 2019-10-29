/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMPrivate.h
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

#ifndef __RANDOLPH_PGDOMPRIVATE_H__
#define __RANDOLPH_PGDOMPRIVATE_H__

#import "PGDOMTools.h"
#import "PGDOMChild.h"
#import "PGDOMElement.h"
#import "PGDOMAttr.h"
#import "PGDOMDocument.h"
#import "PGDOMCData.h"
#import "PGDOMComment.h"
#import "PGDOMNamedNodeMap.h"
#import "PGDOMNodeList.h"
#import "PGDOMLocator.h"
#import "PGDOMEntity.h"
#import "PGDOMEntityReference.h"
#import "PGDOMNotation.h"
#import "PGDOMProcessingInstruction.h"
#import "PGDOMDocumentType.h"
#import "PGDOMDocumentFragment.h"
#import "PGDOMUserData.h"
#import "PGDOMUserDataHandler.h"
#import "PGTreeNode.h"
#import "PGDOMNonChildParent.h"
#import "PGDOMNamed_Private.h"

@class PGDOMNamedKey;

NS_ASSUME_NONNULL_BEGIN

typedef PGDOMNamedKey                     *NamedKey;
typedef PGTreeNode<NamedKey, PGDOMAttr *> *AttrTNode;

typedef NS_OPTIONS(uint16_t, PGDOMIntFlags) {
    PGDOMIntFlag_SyncData            = (1 << 0),
    PGDOMIntFlag_SyncChildren        = (1 << 1),
    PGDOMIntFlag_SyncAttribs         = (1 << 2),
    PGDOMIntFlag_ReadOnly            = (1 << 3),
    PGDOMIntFlag_Normalized          = (1 << 4),
    PGDOMIntFlag_IDAttribute         = (1 << 5),
    PGDOMIntFlag_IgnorableWhitespace = (1 << 6),
    PGDOMIntFlag_Specified           = (1 << 7),
    PGDOMIntFlag_Owned               = (1 << 8)
};

#define PGDOMSyncData     ({ if(self.needsSyncData) [self synchronizeData]; })
#define PGDOMSyncChildren ({ if(self.needsSyncChildren) [self synchronizeChildren]; })
#define PGDOMReadOnly     ({ if(self.isReadOnly) @throw PGMakeDOMException(PGDOMErrorNoModificationAllowed, PGF, PGDOMErrorMsgNodeReadOnly); })
#define PGDOMSyncAttribs  ({ if(self.needsSyncAttribs) [self synchronizeAttributes]; })

NS_INLINE BOOL nodeIsEntityRef(PGDOMNode *node) {
    return (node.nodeType == PGDOMNodeTypeEntityRef);
}

NS_INLINE BOOL nodeIsText(PGDOMNode *node) {
    PGDOMNodeType type = node.nodeType;
    return ((type == PGDOMNodeTypeText) || (type == PGDOMNodeTypeCData));
}

NS_INLINE PGDOMNode *getSibling(BOOL next, PGDOMNode *node) {
    return (next ? node.nextSibling : node.prevSibling);
}

NS_INLINE PGDOMNode *getChild(BOOL first, PGDOMNode *node) {
    return (first ? node.firstChild : node.lastChild);
}

FOUNDATION_EXPORT NSException *PGMakeDOMException(NSString *reason, NSString *__nullable descriptionFormat, ...) NS_FORMAT_FUNCTION(2, 3);

@interface PGDOMNode()

    @property(nonatomic)/*                 */ BOOL                                             needsSyncData;
    @property(nonatomic)/*                 */ BOOL                                             needsSyncChildren;
    @property(nonatomic)/*                 */ BOOL                                             isReadOnly;
    @property(nonatomic)/*                 */ BOOL                                             isNormalized;
    @property(nonatomic)/*                 */ BOOL                                             isIgnorableWhitespace;
    @property(nonatomic)/*                 */ BOOL                                             isOwned;
    @property(nonatomic, readonly) NSMutableDictionary<NSString *, PGDOMUserData *> *userDataMap;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument;

    -(BOOL)hasFlag:(PGDOMIntFlags)flag;

    -(void)setFlag:(PGDOMIntFlags)flag value:(BOOL)value;

    -(void)nodeHierarchyChanged;

    -(void)synchronizeData;

    -(void)synchronizeChildren;

    -(void)postUserDataEvent:(PGDOMUserDataEvent)event src:(PGDOMNode *)src dest:(nullable PGDOMNode *)dest;

    -(void)postNodeAdoptedUserDataNotification;

    -(void)postNodeClonedUserDataNotification:(PGDOMNode *)clone;

    -(void)postNodeImportedUserDataNotification:(PGDOMNode *)clone;

@end

@interface PGDOMChild()

    @property(nonatomic, nullable) PGDOMNode *parentNode;
    @property(nonatomic, nullable) PGDOMNode *nextSibling;
    @property(nonatomic, nullable) PGDOMNode *prevSibling;

@end

@interface PGDOMParent()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument;

    -(void)synchronizeChildren;

    -(void)cloneChildrenTo:(PGDOMParent *)node;

    -(void)validateNewChildNode:(PGDOMNode *)newNode;

    -(void)removeAllChildren;

@end

@interface PGDOMNamed()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)document nodeName:(NSString *)nodeName;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument
                           qualifiedName:(NSString *)qualifiedName
                            namespaceURI:(nullable NSString *)namespaceURI;

    -(instancetype)rename:(NSString *)nodeName;

    -(instancetype)rename:(NSString *)qualifiedName namespaceURI:(nullable NSString *)namespaceURI;

@end

@interface PGDOMElement()

    @property(nonatomic) BOOL needsSyncAttribs;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument tagName:(NSString *)tagName;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument
                           qualifiedName:(NSString *)qualifiedName
                            namespaceURI:(nullable NSString *)namespaceURI;

    -(void)postAttributeChangeNotification:(PGDOMAttribEventName)change attr:(PGDOMAttr *)attr;

    -(void)synchronizeAttributes;
@end

@interface PGDOMAttr()

    @property(nonatomic)/*      */ BOOL         isID;
    @property(nonatomic)/*      */ BOOL         isSpecified;
    @property(nonatomic, nullable) PGDOMElement *ownerElement;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)document name:(NSString *)name value:(NSString *)value;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)document
                           qualifiedName:(NSString *)qualifiedName
                            namespaceURI:(nullable NSString *)namespaceURI
                                   value:(NSString *)value;

@end

@interface PGDOMDocument()

    -(instancetype)init;
@end

@interface PGDOMTextContent()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument textData:(NSString *)textData;

@end

@interface PGDOMText()

    @property(nonatomic) BOOL isElementContentWhitespace;

@end

@interface PGDOMCData()
@end

@interface PGDOMComment()
@end

@interface PGDOMNodeList()

    +(instancetype)listWithParentNode:(nullable PGDOMParent *)pnode;

@end

@interface PGDOMNamedNodeMap()

    -(void)handleNamedNodeDidChange:(NSNotification *)notice;

    +(instancetype)nodeMapWithNSArray:(NSArray<PGDOMNode *> *)array;

    +(instancetype)nodeMapWithElement:(PGDOMElement *)elem attribs:(AttrTNode)attribs;

@end

@interface PGDOMLocator()

    -(instancetype)initWithLineNumber:(NSInteger)lineNumber
                         columnNumber:(NSInteger)columnNumber
                          utf16Offset:(NSInteger)utf16Offset
                                  uri:(nullable NSString *)uri
                          relatedNode:(nullable PGDOMNode *)relatedNode;

    +(instancetype)locatorWithLineNumber:(NSInteger)lineNumber
                            columnNumber:(NSInteger)columnNumber
                             utf16Offset:(NSInteger)utf16Offset
                                     uri:(nullable NSString *)uri
                             relatedNode:(nullable PGDOMNode *)relatedNode;


@end

@interface PGDOMEntity()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument
                           inputEncoding:(nullable NSString *)inputEncoding
                            notationName:(nullable NSString *)notationName
                                publicId:(nullable NSString *)publicId
                                systemId:(nullable NSString *)systemId
                             xmlEncoding:(nullable NSString *)xmlEncoding
                              xmlVersion:(nullable NSString *)xmlVersion;


@end

@interface PGDOMEntityReference()

    @property(nonatomic) PGDOMEntity *entity;

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument entity:(PGDOMEntity *)entity;

@end

@interface PGDOMProcessingInstruction()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument target:(NSString *)target data:(NSString *)data;

@end

@interface PGDOMNotation()

    -(instancetype)initWithOwnerDocument:(nullable PGDOMDocument *)ownerDocument
                                publicId:(nullable NSString *)publicId
                                systemId:(nullable NSString *)systemId;

@end

NS_ASSUME_NONNULL_END

#endif // __RANDOLPH_PGDOMPRIVATE_H__
