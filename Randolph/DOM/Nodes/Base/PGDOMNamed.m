/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNamed.m
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

@implementation PGDOMNamed {
        NSString *_localName;
        NSString *_namespaceURI;
        NSString *_prefix;
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)document nodeName:(NSString *)nodeName {
        self = [super initWithOwnerDocument:document];

        if(self) {
            _localName    = PGDOMValidateNodeName(nodeName.nilIfEmpty).copy;
            _namespaceURI = nil;
            _prefix       = nil;
            if(!_localName) @throw PGMakeDOMException(PGDOMErrorNoNames, PGF, PGDOMErrorMissingNodeName);
        }

        return self;
    }

    -(instancetype)initWithOwnerDocument:(PGDOMDocument *)ownerDocument qualifiedName:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        if((namespaceURI = namespaceURI.nilIfEmpty).length) {
            self = [super initWithOwnerDocument:ownerDocument];

            if(self) {
                PGDOMQName *qname = [PGDOMQName qnameWithQualifiedName:qualifiedName];

                _namespaceURI = namespaceURI.copy;
                _localName    = PGDOMValidateLocalName(qname.localName).copy;
                _prefix       = PGDOMValidatePrefix(qname.prefix).copy;

                PGDOMValidateNameCombo(_prefix, _localName, _namespaceURI);
            }

            return self;
        }
        else {
            return (self = [self initWithOwnerDocument:ownerDocument nodeName:qualifiedName]);
        }
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMNamed *copy = (PGDOMNamed *)[super copyWithZone:zone];

        if(copy != nil) {
            copy->_localName    = _localName.copy;
            copy->_namespaceURI = _namespaceURI.copy;
            copy->_prefix       = _prefix.copy;
            copy.isReadOnly     = NO;
        }

        return copy;
    }

    -(BOOL)hasNamespace {
        PGDOMSyncData;
        return (_namespaceURI.length != 0);
    }

    -(NSString *)nodeName {
        PGDOMSyncData;
        return ((self.hasNamespace && (self.prefix.length != 0)) ? PGFormat(PGDOMFormatNodeNameNS, self.prefix, self.localName) : self.localName);
    }

    -(NSString *)localName {
        PGDOMSyncData;
        return _localName;
    }

    -(NSString *)namespaceURI {
        PGDOMSyncData;
        return _namespaceURI;
    }

    -(NSString *)prefix {
        PGDOMSyncData;
        return (self.hasNamespace ? _prefix : nil);
    }

    -(void)setPrefix:(NSString *)prefix {
        PGDOMSyncData;
        if(prefix.length == 0) {
            _prefix = nil;
        }
        else if(self.hasNamespace) {
            NSString *p = (prefix.length ? PGDOMValidatePrefix(prefix) : nil);
            PGDOMValidateNameCombo(p, self.localName, self.namespaceURI);
            _prefix = p.copy;
        }
        else {
            @throw PGMakeDOMException(PGDOMErrorNamespaceError, PGF, PGDOMErrorPrefixNotAllowed);
        }
    }

    -(instancetype)rename:(NSString *)nodeName {
        return [self renameWithEventsAndBlock:^(PGDOMNamed *node) {
            if(!nodeName.nilIfEmpty) @throw PGMakeDOMException(PGDOMErrorNoNames, PGF, PGDOMErrorMissingNodeName);
            self->_localName    = PGDOMValidateNodeName(nodeName).copy;
            self->_namespaceURI = nil;
            self->_prefix       = nil;
            return self;
        }];
    }

    -(instancetype)rename:(NSString *)qualifiedName namespaceURI:(NSString *)namespaceURI {
        return [self renameWithEventsAndBlock:^(PGDOMNamed *node) {
            PGDOMQName *q = PGDOMParseQualifiedName(qualifiedName);
            NSString   *l = PGDOMValidateLocalName(q.localName);
            NSString   *p = PGDOMValidatePrefix(q.prefix);

            PGDOMValidateNameCombo(p, l, namespaceURI);
            self->_localName    = l.copy;
            self->_prefix       = p.copy;
            self->_namespaceURI = namespaceURI.copy;

            return self;
        }];
    }

    -(PGDOMNamed *)renameWithEventsAndBlock:(RenameAction)block {
        NSMutableDictionary *userInfo = [NSMutableDictionary new];

        userInfo[PGDOMRenameEventNodeKey]                               = self;
        if(_localName) userInfo[PGDOMRenameEventOrigLocalNameKey]       = _localName.copy;
        if(_namespaceURI) userInfo[PGDOMRenameEventOrigNamespaceURIKey] = _namespaceURI.copy;
        if(self.nodeName) userInfo[PGDOMRenameEventOrigNodeNameKey]     = self.nodeName.copy;

        PGDOMNamed *dest = [self renameWithBlock:block];

        [PGNotificationCenter() postNotificationName:PGDOMNamedNodeDidChange object:self userInfo:userInfo];
        [self postUserDataEvent:PGDOM_USERDATA_NODE_RENAMED src:self dest:dest];
        return (dest ?: self);
    }

    -(PGDOMNamed *)renameWithBlock:(RenameAction)block {
        if(self.isReadOnly) {
            if(self.parentNode.isReadOnly) @throw PGMakeDOMException(PGDOMErrorNotRenamable, PGF, PGDOMErrorMsgNotRenamable);
            PGDOMNamed *dest = block([self copy:YES]);
            [self.parentNode replaceChildNode:self withNode:dest];
            return dest;
        }
        else {
            block(self);
            return nil;
        }
    }

@end
