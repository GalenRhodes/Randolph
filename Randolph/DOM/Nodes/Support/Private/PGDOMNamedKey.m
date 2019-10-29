/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNamedKey.m
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

#import "PGDOMNamedKey.h"
#import "PGTools.h"
#import "PGDOMNode.h"

@interface PGDOMNamedKey()

    -(instancetype)initWithName:(NSString *)name uri:(NSString *)uri;
@end

@implementation PGDOMNamedKey {
    }

    @synthesize name = _name;
    @synthesize uri = _uri;

    -(instancetype)initWithName:(NSString *)name uri:(NSString *)uri {
        self = [super init];

        if(self) {
            _name = name.copy;
            _uri  = uri.copy;
        }

        return self;
    }

    +(instancetype)keyWithName:(NSString *)nodeName {
        return [[self alloc] initWithName:nodeName uri:nil];
    }

    +(instancetype)keyWithName:(NSString *)localName namespaceURI:(NSString *)namespaceURI {
        return [[self alloc] initWithName:localName uri:((namespaceURI.trim.length == 0) ? nil : namespaceURI)];
    }

    +(instancetype)keyWithNode:(PGDOMNode *)node {
        NSString *uri = ((node.namespaceURI.trim.length == 0) ? nil : node.namespaceURI);
        return [[self alloc] initWithName:(uri ? node.localName : node.nodeName) uri:uri];
    }

    -(NSComparisonResult)compare:(PGDOMNamedKey *)key {
        NSComparisonResult cr = PGStrCmp(self.uri, key.uri);
        return ((cr == NSOrderedSame) ? PGStrCmp(self.name, key.name) : cr);
    }

    -(instancetype)copyWithZone:(nullable NSZone *)zone {
        PGDOMNamedKey *copy = [((PGDOMNamedKey *)[[self class] allocWithZone:zone]) init];

        if(copy != nil) {
            copy->_name = _name.copy;
            copy->_uri  = _uri.copy;
        }

        return copy;
    }

    -(BOOL)isEqual:(id)object {
        return (object && ((self == object) || ([object isMemberOfClass:[self class]] && [self isEqualToKey:object])));
    }

    -(BOOL)isEqualToKey:(PGDOMNamedKey *)key {
        return (key && ((self == key) || (PGStrEqu(self.name, key.name) && PGStrEqu(self.uri, key.uri))));
    }

    -(NSUInteger)hash {
        return (((31u + self.name.hash) * 31u) + self.uri.hash);
    }

@end
