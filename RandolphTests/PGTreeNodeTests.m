/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGTreeNodeTests.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/10/19
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

#import "PGTreeNodeTests.h"
#import "EnglishWords.h"
#import <Randolph/PGTreeNode.h>
#import <Randolph/PGTools.h>
#import <Randolph/PGTreeNode+PGTreeNodeDraw.h>

static const NSInteger NUMBER_OF_NODES_FOR_TEST = 50;

NSString *const NodeTestFilename          = @"~/Desktop/NodeTest/NodeTest_Step%03lu_%@.png";
NSString *const GalenLoveMichelleFilename = @"~/Desktop/NodeTest/GalenLovesMichelle.png";

NSString *nextWord(NSMutableArray<NSString *> *source);

PGTreeNode<NSString *, NSString *> *findRedNodeToDelete(PGTreeNode<NSString *, NSString *> *node);

PGTreeNode<NSString *, NSString *> *findNthBlackNodeToDelete(PGTreeNode<NSString *, NSString *> *node, NSUInteger *count);

@implementation PGTreeNodeTests {
    }

    -(void)testPGTreeNodeDraw {
#if (DRAW_TREE_IMAGES)
        PGTreeNode<NSString *, NSString *> *root  = [PGTreeNode nodeWithValue:@"Galen" forKey:@"Galen"];
        NSData                             *data  = [root drawTree];
        NSError                            *error = nil;

        NSString *filename = [PGFormat(NodeTestFilename, 999lu, @"Simple") stringByExpandingTildeInPath];

        PGLog(@"Writing PNG to file: %@", filename);

        [data writeToFile:filename options:0 error:&error];

        if(error) PGLog(@"Error writing file: %@", error.localizedDescription);
#endif
        PGLog(@"Done.");
    }

    -(BOOL)saveTreeImage:(PGTreeNode<NSString *, NSString *> *)root filename:(NSString *)filename error:(NSError **)error {
#if (DRAW_TREE_IMAGES)
        BOOL b = [root drawTree:filename error:error];
        XCTAssertTrue(b, @"Error drawing tree and saving to file: %@", (*error).localizedDescription);
        if(b) PGLog(@"Successfully saved drawing of tree to file: %@", filename);
        return b;
#else
        return YES;
#endif
    }

    -(void)testPGTreeNodeGalen {
        NSString                           *saying = @"Galen Rhodes loves Michelle Leising to the moon and back and to the stars and beyond!";
        NSArray<NSString *>                *array  = [saying componentsSeparatedByString:@" "];
        PGTreeNode<NSString *, NSString *> *root   = [PGTreeNode nodeWithValue:@"" forKey:array[0]];

        for(NSUInteger i = 1; i < array.count; i++) {
            root = [root insertValue:@"" forKey:array[i]];
        }

        NSError *error = nil;
        [self saveTreeImage:root filename:GalenLoveMichelleFilename error:&error];
        XCTAssert((error == nil), @"Error saving image: %@", error.localizedDescription);
    }

    -(void)testPGTreeNodeComplex {
        NSUInteger                         cc       = 0;
        NSUInteger                         limit    = NUMBER_OF_NODES_FOR_TEST;
        NSUInteger                         testStep = 0;
        NSError                            *error   = nil;
        NSMutableArray<NSString *>         *source  = EnglishWords.words.mutableCopy;
        PGTreeNode<NSString *, NSString *> *root    = [PGTreeNode nodeWithValue:[@(++cc) description] forKey:nextWord(source)];

        for(NSUInteger i = 1; ((source.count > 0) && (i < limit)); i++) {
            root = [root insertValue:[@(++cc) description] forKey:nextWord(source)];
        }

        [self saveTreeImage:root filename:PGFormat(NodeTestFilename, ++testStep, @"Draw") error:&error];
        root   = [self treeDeleteTest:root source:[self checkTree:root insertCount:cc] testStep:&testStep];
    }

    -(PGTreeNode<NSString *, NSString *> *)treeDeleteTest:(PGTreeNode<NSString *, NSString *> *)root source:(NSMutableArray<NSString *> *)source testStep:(NSUInteger *)pTestStep {
        /*
         * Now let's remove half the nodes and run the checks again.
         */
        NSError    *error    = nil;
        NSUInteger origCount = root.count;
        NSUInteger j         = (NSUInteger)ceil(origCount * 0.75);
        PGLog(@"Removing %lu items from the tree...", j);

        for(NSUInteger i = 0; i < j; i++) {
            NSUInteger erc = (root.count - 1);

            @autoreleasepool {
                NSString   *word = nextWord(source);
                PGTreeNode *node = [root nodeForKey:word];

                XCTAssertNotNil(node, "We didn't find the node for \"%@\"!", word);
                if(!node) break;

                PGLog(@"Removing \"%@\"...", node.key);
                root = [node remove];
                [self saveTreeImage:root filename:PGFormat(NodeTestFilename, ++(*pTestStep), PGFormat(@"Delete_[%@]", word)) error:&error];
            }

            XCTAssertEqual(erc, root.count, "Incorrect number of items left in tree: %lu != %lu", erc, root.count);
            if(erc != root.count) break;
        }

        return root;
    }

    -(NSMutableArray<NSString *> *)checkTree:(PGTreeNode<NSString *, NSString *> *)root insertCount:(NSUInteger)insertCount {
        NSMutableArray<NSString *> *source = [NSMutableArray new];
        /*
         * When we're done inserting the number of items in the tree
         * better be the same as the number of words we inserted.
         */
        XCTAssertEqual(insertCount, root.count, "Number of items in the tree, %lu, doesn't equal the number of items inserted, %lu.", root.count, insertCount);

        /*
         * Traverse the tree and reinsert the items into the working array.
         */
        /*@f:0*/[root doForEach:^BOOL(NSString *key, NSString *value) { [source addObject:key]; return NO; }];/*@f:1*/
        /*
         * Again, the numbers should match...
         */
        XCTAssertEqual(insertCount, root.count, "Number of items in the tree, %lu, doesn't equal the number of items in the source array, %lu.", root.count, insertCount);

        /*
         * And they should be sorted...
         */
        NSString     *last = nil;
        for(NSString *word in source) {
            BOOL cs = ((last == nil) || ([last compare:word] == NSOrderedAscending));
            XCTAssertTrue(cs, @"\"%@\" does not come after \"%@\".", word, last);
            if(!cs) break;
            last = word;
        }

        [self checkTreeDepth:root];
        return source;
    }

    -(void)checkTreeDepth:(PGTreeNode<NSString *, NSString *> *)node {
        NSUInteger depthAllowed = (PGBitsRequired(node.count) + 3); // Even a well balanced tree can extends up to 3 levels more than needed.
        NSUInteger depthUsed    = [node branchDepth];
        PGLog(@"Depth Allowed: %lu; Depth Used: %lu", depthAllowed, depthUsed);
        XCTAssertTrue((depthUsed <= depthAllowed), @"Tree has too many levels to be well balanced: %lu > %lu", depthUsed, depthAllowed);
    }

@end

NSString *nextWord(NSMutableArray<NSString *> *source) {
    NSUInteger idx   = ((source.count > 4) ? PGRandomUInt(source.count) : 0);
    NSString   *word = source[idx];
    [source removeObjectAtIndex:idx];
    return word;
}

PGTreeNode<NSString *, NSString *> *findRedNodeToDelete(PGTreeNode<NSString *, NSString *> *node) {
    if(!node) return nil;
    if(node.isRed && node.leftChild == nil && node.rightChild == nil) return node;

    PGTreeNode<NSString *, NSString *> *n = findRedNodeToDelete(node.leftChild);
    if(n) return n;
    return findRedNodeToDelete(node.rightChild);
}

PGTreeNode<NSString *, NSString *> *findNthBlackNodeToDelete(PGTreeNode<NSString *, NSString *> *node, NSUInteger *count) {
    if(!node) return nil;

    if(!(node.isRed || node.leftChild || node.rightChild)) {
        if(*count) --(*count); else return node;
    }

    PGTreeNode<NSString *, NSString *> *n = findNthBlackNodeToDelete(node.leftChild, count);
    if(n) return n;
    return findNthBlackNodeToDelete(node.rightChild, count);
}

