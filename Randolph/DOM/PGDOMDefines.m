/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMDefines.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2019-08-20
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

#import "PGDOMDefines.h"

NSExceptionName const PGDOMException = @"PGDOMException";

PGDOMAttribEventName const AttribEventAdd    = @"AttribEventAdd";
PGDOMAttribEventName const AttribEventRemove = @"AttribEventRemove";
PGDOMAttribEventName const AttribEventIsID   = @"AttribEventIsID";

NSString *const PGDOMAttribEventNameKey = @"PGDOMAttribEventNameKey";
NSString *const PGDOMAttribEventNodeKey = @"PGDOMAttribEventNodeKey";

NSNotificationName const PGDOMElementAttribsDidChange = @"PGDOMElementAttribsDidChange";
NSNotificationName const PGDOMNodeHierarchyDidChange  = @"PGDOMNodeHierarchyDidChange";
NSNotificationName const PGDOMNamedNodeMapDidChange   = @"PGDOMNamedNodeMapDidChange";
NSNotificationName const PGDOMNamedNodeDidChange      = @"PGDOMNamedNodeDidChange";

NSString *const PGDOMRenameEventNodeKey             = @"PGDOMRenameEventNodeKey";
NSString *const PGDOMRenameEventOrigLocalNameKey    = @"PGDOMRenameEventOrigLocalNameKey";
NSString *const PGDOMRenameEventOrigNamespaceURIKey = @"PGDOMRenameEventOrigNamespaceURIKey";
NSString *const PGDOMRenameEventOrigNodeNameKey     = @"PGDOMRenameEventOrigNodeNameKey";

NSString *const PGDOMPatternNameStartChar      = @"[a-zA-Z_\\xC0-\\xD6\\xD8-\\xF6\\u00F8-\\u02ff\\u0370-\\u037D\\u037F-\\u1FFF\\u200C-\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD\\U00010000-\\U000EFFFF]";
NSString *const PGDOMPatternNameCharAddon      = @"[0-9\\xB7\\u0300-\\u036F\\u203F-\\u2040.-]";
NSString *const PGDOMPatternParseQualifiedName = @"^(?:([^:]*):)?(.*)$";

NSString *const W3NS1998URI = @"http://www.w3.org/XML/1998/namespace";
NSString *const W3NS2000URI = @"http://www.w3.org/2000/xmlns";
NSString *const W3NS1998PFX = @"xml";
NSString *const W3NS2000PFX = @"xmlns";

NSString *const PGDOMFormatNodeNameNS            = @"%@:%@";
NSString *const PGDOMFormatNameParserPattern     = @"(%1$@(?:%1$@|%2$@)*)";
NSString *const PGDOMFormatPrefixParserPattern   = @"(%1$@(?:%1$@|%2$@)*)";
NSString *const PGDOMFormatNodeNameParserPattern = @"((?:%1$@|:)(?:%1$@|%2$@|:)*)";

NSString *const PGDOMDescNewNode       = @"new node";
NSString *const PGDOMDescNodeToRemove  = @"node to remove";
NSString *const PGDOMDescNodeToReplace = @"node to replace";
NSString *const PGDOMDescReference     = @"reference node";
NSString *const PGDOMDescLocalName     = @"Local name";
NSString *const PGDOMDescQName         = @"Qualified name";
NSString *const PGDOMDescNode          = @"node";
NSString *const PGDOMDescLeft          = @"left";
NSString *const PGDOMDescRight         = @"right";

NSString *const PGDOMErrorNamespaceError        = @"PGDOMErrorNamespaceError";
NSString *const PGDOMErrorInvalidCharacter      = @"PGDOMErrorInvalidCharacter";
NSString *const PGDOMErrorNotSupported          = @"PGDOMErrorNotSupported";
NSString *const PGDOMErrorNoNames               = @"PGDOMErrorNoNames";
NSString *const PGDOMErrorMissingNamespaceURI   = @"PGDOMErrorMissingNamespaceURI";
NSString *const PGDOMErrorMissingNodeName       = @"PGDOMErrorMissingNodeName";
NSString *const PGDOMErrorMissingLocalName      = @"PGDOMErrorMissingLocalName";
NSString *const PGDOMErrorPrefixNotAllowed      = @"PGDOMErrorPrefixNotAllowed";
NSString *const PGDOMErrorHierarchy             = @"PGDOMErrorHierarchy";
NSString *const PGDOMErrorNoModificationAllowed = @"PGDOMErrorNoModificationAllowed";
NSString *const PGDOMErrorWrongDocument         = @"PGDOMErrorWrongDocument";
NSString *const PGDOMErrorAttribInUse           = @"PGDOMErrorAttribInUse";
NSString *const PGDOMErrorNotRenamable          = @"PGDOMErrorNotRenamable";

NSString *const PGDOMErrorMsgNotParentNode         = @"This node does not support child nodes.";
NSString *const PGDOMErrorMsgNotTextNode           = @"This node does not support text.";
NSString *const PGDOMErrorMsgNoSettingValue        = @"This node does not support setting the node value.";
NSString *const PGDOMErrorMsgNotChildNode          = @"This node type cannot be a child node.";
NSString *const PGDOMErrorMsgNodeNotChild          = @"The %@ is not a child of this node.";
NSString *const PGDOMErrorMsgNotRenamable          = @"Node cannot be renamed.";
NSString *const PGDOMErrorMsgNodeNull              = @"The %@ is null.";
NSString *const PGDOMErrorMsgWrongDocument         = @"The %@ is not owned by the same document as this node.";
NSString *const PGDOMErrorMsgChildIsParent         = @"The %@ is a parent of this node or actually is this node.";
NSString *const PGDOMErrorMsgNodeReadOnly          = @"Node is read-only.";
NSString *const PGDOMErrorMsgNoModificationAllowed = @"No modification allowed.";
NSString *const PGDOMErrorMsgNodeNameMissing       = @"Node name is missing.";
NSString *const PGDOMErrorMsgLocalNameMissing      = @"Local name is missing.";
NSString *const PGDOMErrorMsgNoName                = @"%@ cannot be empty or null.";
NSString *const PGDOMErrorMsgCannotRotate          = @"Cannot rotate node to the %@.";
NSString *const PGDOMErrorMsgAttribNotFound        = @"Attribute not found.";
NSString *const PGDOMErrorMsgAttribInUse           = @"The new attribute is already in use by another element.";
NSString *const PGDOMErrorMsgAttribWrongDocument   = @"The new attribute belongs to a different document than this element.";
