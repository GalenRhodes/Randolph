/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGDOMTests.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/5/19
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

#import "PGDOMTests.h"

NSString *const BAR                       = @"=================================================================================================================";
NSString *const DASH                      = @"-----------------------------------------------------------------------------------------------------------------";
NSString *const TESTFUNC                  = @"Testing function %@...";
NSString *const ALLSUCCEEDED              = @"All tests succeeded.\n\n\n-";

NSString *subString(NSString *str, NSRange range);

@implementation PGDOMTests {
    }

    -(void)setUp {
    }

    -(void)tearDown {
    }

    -(void)testQualifiedNameParse {
        NSArray<NSString *> *array   = @[
            @"localname", @"prefix:localname", @":localname", @"prefix:", @":", @"", @"localname", @"prefixÐ:Ðlocalname", @":Ðlocalname", @"prefixÐ:", @":",
        ];
        NSString            *pattern = @"^(?:([^:]*):)?(.*)$";
        NSError             *error   = nil;
        NSRegularExpression *regex   = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];

        for(NSString *str in array) {
            NSArray<NSTextCheckingResult *> *results = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];

            if(results.count == 0) {
                PGLog(@"%@> No Matches!", str);
            }
            else {
                PGLog(@"%@> %@ matches", str, @(results.count));
                NSUInteger               c = 0;
                for(NSTextCheckingResult *tcresult in results) {
                    NSUInteger      d    = tcresult.numberOfRanges;
                    NSMutableString *out = [NSMutableString new];

                    [out appendFormat:@"%20lu> ", ++c];

                    if(d > 1) {
                        [out appendFormat:@"\"%@\"", subString(str, [tcresult rangeAtIndex:1])];
                        for(NSUInteger e = 2; e < d; e++) [out appendFormat:@" | \"%@\"", subString(str, [tcresult rangeAtIndex:e])];
                    }
                    else if(d == 1) [out appendFormat:@"\"%@\"", subString(str, tcresult.range)];
                    else [out appendString:@"???"];

                    PGLog(@"%@", out);
                }
            }
        }
    }

    -(void)testPGDOMValidateNameCombo {
        PGLog(BAR);
        PGLog(TESTFUNC, @"PGDOMValidateNameCombo");
        PGLog(BAR);

        NSArray<NSArray<NSString *> *> *testData = @[
            @[ @"1", @"uri:test1", @"galen:rhodes" ],                         // Test 1
            @[ @"0", @"uri:test2", @"xml:galen" ],                            // Test 2
            @[ @"1", @"http://www.w3.org/XML/1998/namespace", @"xml:galen" ], // Test 3
            @[ @"1", @"http://www.w3.org/XML/1998/namespace", @"bob:galen" ], // Test 4
            @[ @"1", @"http://www.w3.org/2000/xmlns", @"xmlns" ],             // Test 5
            @[ @"1", @"http://www.w3.org/2000/xmlns", @"xmlns:galen" ],       // Test 6
            @[ @"0", @"http://www.w3.org/2000/xmlns", @"bob" ],               // Test 7
            @[ @"0", @"http://www.w3.org/2000/xmlns", @"bob:galen" ],         // Test 8
            @[ @"0", @"uri:test", @"xmlns" ],                                 // Test 9
            @[ @"0", @"uri:test", @"xmlns:galen" ],                           // Test 10
        ];
        PGDOMQName                     *qname    = nil;

        for(NSArray<NSString *> *data in testData) {
            @try {
                qname = PGDOMParseQualifiedName(data[2]);
                PGLog(@"Parsing \"%@\" succeded.", data[2]);
            }
            @catch(NSException *e) {
                XCTFail(@"Parsing \"%@\" FAILED: %@", data[2], e);
            }

            @try {
                PGLog(@"Validating Combo: Prefix: \"%@\"; Local Name: \"%@\"; Namespace URI: \"%@\";", qname.prefix, qname.localName, data[1]);
                PGDOMValidateNameCombo(qname.prefix, qname.localName, data[1]);
                PGLog(@"Validation succeeded.");
                XCTAssertEqualObjects(@"1", data[0], @"Validation succeeded when it shouldn't have.");
            }
            @catch(NSException *e) {
                PGLog(@"Validation failed.");
                XCTAssertEqualObjects(@"0", data[0], @"Validation failed when it shouldn't have.");
            }
            PGLog(DASH);
        }

        PGLog(ALLSUCCEEDED);
    }

    -(void)testPGDOMParseQualifiedName {
        PGLog(BAR);
        PGLog(TESTFUNC, @"PGDOMParseQualifiedName");
        PGLog(BAR);

        NSArray<NSArray<NSString *> *> *testData = @[
            @[ @"galen:sherardÐrhodes", @"1", @"1", @"1", @"1", @"0" ], // Test 1
            @[ @"galen", @"1", @"1", @"1", @"1", @"1" ], // Test 2
            @[ @":galen", @"1", @"1", @"1", @"1", @"1" ], // Test 3
            @[ @"galen :rhodes", @"1", @"1", @"0", @"0", @"0" ], // Test 4
            @[ @"galen:", @"1", @"0", @"1", @"1", @"0" ], // Test 5
            @[ @":", @"1", @"0", @"1", @"0", @"0" ], // Test 6
            @[ @"", @"0", @"0", @"0", @"0", @"0" ], // Test 7
        ];
        PGDOMQName                     *qname    = nil;

        for(NSArray<NSString *> *data in testData) {
            NSString *str = data[0].nilIfEmpty;
            PGLog(@"Test String> \"%@\"", str);
            PGLog(DASH);

            @try {
                qname = PGDOMParseQualifiedName(str);
                XCTAssertEqualObjects(@"1", data[1], "Parsing \"%@\" succeeded and it shouldn't have.", str);
                PGLog(@"Parseing \"%1$@\" succeeded - Prefix: \"%4$@\"; Local Name: \"%3$@\"; Qualified Name: \"%2$@\";", str, qname.qualifiedName, qname.localName, qname.prefix);
            }
            @catch(NSException *e) {
                XCTAssertEqualObjects(@"0", data[1], "Parsing \"%@\" failed and it shouldn't have: %@", str, e);
                PGLog(@"Parsing \"%@\" failed...", str);
                continue;
            }

            @try {
                PGDOMValidateLocalName(qname.localName);
                XCTAssertEqualObjects(@"1", data[2], "Localname \"%@\" validates and it shouldn't have.", qname.localName);
                PGLog(@"Localname \"%@\" validates.", qname.localName);
            }
            @catch(NSException *e) {
                XCTAssertEqualObjects(@"0", data[2], "Localname \"%@\" DOES NOT validate and it should have: %@", qname.localName, e);
                PGLog(@"Localname \"%@\" DOES NOT validate: %@", qname.localName, e);
            }

            @try {
                PGDOMValidatePrefix(qname.prefix);
                XCTAssertEqualObjects(@"1", data[3], "Prefix \"%@\" validates and it shouldn't have.", qname.prefix);
                PGLog(@"Prefix \"%@\" validates.", qname.prefix);
            }
            @catch(NSException *e) {
                XCTAssertEqualObjects(@"0", data[3], "Prefix \"%@\" DOES NOT validate and it should have: %@", qname.prefix, e);
                PGLog(@"Prefix \"%@\" DOES NOT validate: %@", qname.prefix, e);
            }

            @try {
                PGDOMValidateNodeName(qname.qualifiedName);
                XCTAssertEqualObjects(@"1", data[4], @"Qualified name \"%@\" as a node name validates and it shouldn't have.", qname.qualifiedName);
                PGLog(@"Qualified name \"%@\" as a node name validates.", qname.qualifiedName);
            }
            @catch(NSException *e) {
                XCTAssertEqualObjects(@"0", data[4], @"Qualified name \"%@\" as a node name DOES NOT validate and it should have: %@", qname.qualifiedName, e);
                PGLog(@"Qualified name \"%@\" as a node name DOES NOT validate: %@", qname.qualifiedName, e);
            }

            @try {
                PGDOMValidateLocalName(qname.qualifiedName);
                XCTAssertEqualObjects(@"1", data[5], @"Qualified name \"%@\" as a local name validates and it shouldn't have.", qname.qualifiedName);
                PGLog(@"Qualified name \"%@\" as a local name validates.", qname.qualifiedName);
            }
            @catch(NSException *e) {
                XCTAssertEqualObjects(@"0", data[5], @"Qualified name \"%@\" as a local name DOES NOT validate and it should have: %@", qname.qualifiedName, e);
                PGLog(@"Qualified name \"%@\" as a local name DOES NOT validate: %@", qname.qualifiedName, e);
            }

            PGLog(DASH);
        }

        PGLog(ALLSUCCEEDED);
    }

@end

NSString *subString(NSString *str, NSRange range) {
    if(range.location == NSNotFound) return @"";
    else return [str substringWithRange:range];
}

