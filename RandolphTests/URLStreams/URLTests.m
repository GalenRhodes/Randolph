/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: URLTests.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/28/19
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

#import "URLTests.h"

typedef void (^compHndlr_t)(NSURLSessionResponseDisposition);

@implementation URLTests {
    }

    -(void)setUp {
    }

    -(void)tearDown {
    }

    -(void)testURLLoad {
        NSURL                     *url     = [NSURL URLWithString:@"http://www.thissmallworld.com/"];
        NSURLSessionConfiguration *conf    = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"galen"];
        NSURLSession              *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
        NSURLSessionDataTask      *task    = [session dataTaskWithURL:url];

        [task resume];

        NSInteger s = -1;

        while(s != NSURLSessionTaskStateCompleted) {
            NSURLSessionTaskState ss = task.state;

            if(s != ss) {
                switch(ss) {
                    case NSURLSessionTaskStateRunning:
                        PGLog(@"Session state: %@", @"NSURLSessionTaskStateRunning");
                        s = ss;
                        break;
                    case NSURLSessionTaskStateSuspended:
                        PGLog(@"Session state: %@", @"NSURLSessionTaskStateSuspended");
                        [task resume];
                        s = ss;
                        break;
                    case NSURLSessionTaskStateCanceling:
                        PGLog(@"Session state: %@", @"NSURLSessionTaskStateCanceling");
                        s = ss;
                        break;
                    case NSURLSessionTaskStateCompleted:
                        PGLog(@"Session state: %@", @"NSURLSessionTaskStateCompleted");
                        s = ss;
                        break;
                    default:
                        PGLog(@"Session state: %@", @"Unknown");
                        s = ss;
                        break;
                }
            }
        }
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveResponse:(NSURLResponse *)resp completionHandler:(compHndlr_t)compHndlr {
        PGLog(@"Recieved Response: %@ - %@ bytes.", resp.MIMEType, @(resp.expectedContentLength));
        compHndlr(NSURLSessionResponseAllow);
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
        PGLog(@"Did recieve %@ bytes.", @(data.length));
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
        PGLog(@"didCompleteWithError: %@; code: %@", error.description, @(((NSHTTPURLResponse *)task.response).statusCode));
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
        PGLog(@"didFinishCollectingMetrics: %@", metrics.description);
    }

@end
