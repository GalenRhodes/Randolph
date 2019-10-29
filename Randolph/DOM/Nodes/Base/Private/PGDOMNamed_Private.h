/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMNamed_Private.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/4/19
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

#ifndef __PGDOMNAMED_PRIVATE_H__
#define __PGDOMNAMED_PRIVATE_H__

#import "PGDOMNamed.h"

typedef PGDOMNamed *(^RenameAction)(PGDOMNamed *node);

@interface PGDOMNamed()

    -(PGDOMNamed *)renameWithBlock:(RenameAction)block;

    -(PGDOMNamed *)renameWithEventsAndBlock:(RenameAction)block;

@end

#endif // __PGDOMNAMED_PRIVATE_H__