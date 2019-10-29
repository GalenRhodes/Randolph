/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNodeTypes.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2019-08-19
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

#ifndef ____RANDOLPH_PGDOMNODETYPES_H____
#define ____RANDOLPH_PGDOMNODETYPES_H____

#import <Randolph/PGTools.h>

FOUNDATION_EXPORT NSExceptionName const PGDOMException;

typedef NSString *PGDOMAttribEventName;

FOUNDATION_EXPORT PGDOMAttribEventName const AttribEventAdd;
FOUNDATION_EXPORT PGDOMAttribEventName const AttribEventRemove;
FOUNDATION_EXPORT PGDOMAttribEventName const AttribEventIsID;

FOUNDATION_EXPORT NSString *const PGDOMAttribEventNameKey;
FOUNDATION_EXPORT NSString *const PGDOMAttribEventNodeKey;

FOUNDATION_EXPORT NSNotificationName const PGDOMElementAttribsDidChange;
FOUNDATION_EXPORT NSNotificationName const PGDOMNodeHierarchyDidChange;
FOUNDATION_EXPORT NSNotificationName const PGDOMNamedNodeMapDidChange;
FOUNDATION_EXPORT NSNotificationName const PGDOMNamedNodeDidChange;

FOUNDATION_EXPORT NSString *const PGDOMRenameEventNodeKey;
FOUNDATION_EXPORT NSString *const PGDOMRenameEventOrigLocalNameKey;
FOUNDATION_EXPORT NSString *const PGDOMRenameEventOrigNamespaceURIKey;
FOUNDATION_EXPORT NSString *const PGDOMRenameEventOrigNodeNameKey;

FOUNDATION_EXPORT NSString *const PGDOMPatternNameStartChar;
FOUNDATION_EXPORT NSString *const PGDOMPatternNameCharAddon;
FOUNDATION_EXPORT NSString *const PGDOMPatternParseQualifiedName;
FOUNDATION_EXPORT NSString *const PGDOMFormatNodeNameParserPattern;

FOUNDATION_EXPORT NSString *const W3NS1998URI;
FOUNDATION_EXPORT NSString *const W3NS2000URI;
FOUNDATION_EXPORT NSString *const W3NS1998PFX;
FOUNDATION_EXPORT NSString *const W3NS2000PFX;

FOUNDATION_EXPORT NSString *const PGDOMFormatNodeNameNS;
FOUNDATION_EXPORT NSString *const PGDOMFormatNameParserPattern;
FOUNDATION_EXPORT NSString *const PGDOMFormatPrefixParserPattern;

FOUNDATION_EXPORT NSString *const PGDOMDescNewNode;
FOUNDATION_EXPORT NSString *const PGDOMDescNodeToRemove;
FOUNDATION_EXPORT NSString *const PGDOMDescNodeToReplace;
FOUNDATION_EXPORT NSString *const PGDOMDescReference;
FOUNDATION_EXPORT NSString *const PGDOMDescLocalName;
FOUNDATION_EXPORT NSString *const PGDOMDescQName;
FOUNDATION_EXPORT NSString *const PGDOMDescNode;
FOUNDATION_EXPORT NSString *const PGDOMDescLeft;
FOUNDATION_EXPORT NSString *const PGDOMDescRight;

FOUNDATION_EXPORT NSString *const PGDOMErrorInvalidCharacter;
FOUNDATION_EXPORT NSString *const PGDOMErrorNamespaceError;
FOUNDATION_EXPORT NSString *const PGDOMErrorNotSupported;
FOUNDATION_EXPORT NSString *const PGDOMErrorNoNames;
FOUNDATION_EXPORT NSString *const PGDOMErrorMissingNamespaceURI;
FOUNDATION_EXPORT NSString *const PGDOMErrorMissingNodeName;
FOUNDATION_EXPORT NSString *const PGDOMErrorMissingLocalName;
FOUNDATION_EXPORT NSString *const PGDOMErrorPrefixNotAllowed;
FOUNDATION_EXPORT NSString *const PGDOMErrorHierarchy;
FOUNDATION_EXPORT NSString *const PGDOMErrorNoModificationAllowed;
FOUNDATION_EXPORT NSString *const PGDOMErrorWrongDocument;
FOUNDATION_EXPORT NSString *const PGDOMErrorAttribInUse;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNotRenamable;
FOUNDATION_EXPORT NSString *const PGDOMErrorNotRenamable;

FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNotParentNode;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNotTextNode;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNoSettingValue;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNotChildNode;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNodeNotChild;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNodeNull;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgWrongDocument;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgChildIsParent;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNodeReadOnly;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNoModificationAllowed;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNodeNameMissing;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgLocalNameMissing;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgNoName;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgCannotRotate;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgAttribNotFound;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgAttribInUse;
FOUNDATION_EXPORT NSString *const PGDOMErrorMsgAttribWrongDocument;

typedef NS_ENUM(NSUInteger, PGDOMNodeType) {
    PGDOMNodeTypeNone = 0,
    PGDOMNodeTypeAttribute,
    PGDOMNodeTypeEntity,
    PGDOMNodeTypeEntityRef,
    PGDOMNodeTypeDocument,
    PGDOMNodeTypeDocumentFragment,
    PGDOMNodeTypeElement,
    PGDOMNodeTypeText,
    PGDOMNodeTypeCData,
    PGDOMNodeTypeComment,
    PGDOMNodeTypeNotation,
    PGDOMNodeTypeProcessingInstruction,
    PGDOMNodeTypeDocumentType
};

typedef NS_ENUM(NSUInteger, PGDOMDocPosition) {
    PGDocPosDisconnected, PGDocPosContains, PGDocPosContainedBy, PGDocPosFollowing, PGDocPosPreceeding, PGDocPosImplementationSpecific
};

#endif // ____RANDOLPH_PGDOMNODETYPES_H____
