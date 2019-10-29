/************************************************************************//**
 *     PROJECT: Randolph
 *    FILENAME: PGURLBufferElement.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 10/27/19
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

#import "PGBufferElement_Private.h"
#import "PGURLBufferElement.h"

typedef void (^compHndlr_t)(NSURLSessionResponseDisposition);

@implementation PGURLBufferElement {
        NSMutableData *_dataBuild;
        NSURLSession  *_urlSession;
    }

    @synthesize urlTask = _urlTask;

    -(instancetype)initWithURL:(NSString *)url error:(NSError **)error {
        self = [super init];

        if(self) {
            _dataBuild  = [NSMutableData new];
            _urlSession = [NSURLSession sessionWithConfiguration:[PGURLBufferElement backgroundSessionConfiguration] delegate:self delegateQueue:nil];
            _urlTask    = [self taskForURL:url];
            [_urlTask resume];
        }

        return self;
    }

    +(NSURLSessionConfiguration *)backgroundSessionConfiguration {
        static NSURLSessionConfiguration *_sessionConf    = nil;
        static dispatch_once_t           _sessionConfOnce = 0;
        _dispatch_once(&_sessionConfOnce, ^{ _sessionConf = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID.UUID UUIDString]]; });
        return _sessionConf;
    }

    -(NSURLSessionDataTask *)taskForURL:(NSString *)url {
        return [_urlSession dataTaskWithURL:[NSURL URLWithString:url]];
    }

    -(BOOL)isCompleted {
        return ((_urlTask == nil) || !((_urlTask.state == NSURLSessionTaskStateRunning) || (_urlTask.state == NSURLSessionTaskStateSuspended)));
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveResponse:(NSURLResponse *)resp completionHandler:(compHndlr_t)compHndlr {
        PGLog(@"didReceiveResponse: %@ - %@ bytes.", resp.MIMEType, @(resp.expectedContentLength));
        compHndlr(NSURLSessionResponseAllow);
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
        PGLog(@"didReceiveData: %@ bytes.", @(data.length));
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
        PGLog(@"didCompleteWithError: %@; code: %@", error.description, @(((NSHTTPURLResponse *)task.response).statusCode));
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
        PGLog(@"didFinishCollectingMetrics: %@", metrics.description);
    }

@end
