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

typedef void (^compHndlr_t)(NSURLSessionResponseDisposition);

typedef void (^cacheCompHndlr2_t)(NSCachedURLResponse *);

const NSInteger PGForceDownloadThreshold = 134217728; // 128MB threshold

@implementation PGURLBufferElement {
        NSRecursiveLock *_lock;
    }

    @synthesize urlTask = _urlTask;
    @synthesize dataBuild = _dataBuild;
    @synthesize urlSession = _urlSession;
    @synthesize forceDownload = _forceDownload;
    @synthesize isCompleted = _isCompleted;

    -(instancetype)initWithBytesFromURL:(NSString *)url forceDownload:(BOOL)forceDownload error:(NSError **)error {
        self = [super init];

        if(self) {
            _lock       = [NSRecursiveLock new];
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

    -(NSHTTPURLResponse *)urlTaskResponse {
        return ((NSHTTPURLResponse *)self.urlTask.response);
    }

    -(NSURLSessionDataTask *)taskForURL:(NSString *)url {
        if(self.forceDownload) [self.urlSession downloadTaskWithURL:[NSURL URLWithString:url]];
        return [self.urlSession dataTaskWithURL:[NSURL URLWithString:url]];
    }

    -(BOOL)isAtEOF {
        return (self.isCompleted && super.isAtEOF);
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveResponse:(NSURLResponse *)resp completionHandler:(compHndlr_t)compHndlr {
        NSLInteger len = resp.expectedContentLength;
        PGLog(@"didReceiveResponse: %@ - %@ bytes.", resp.MIMEType, @(len));
        compHndlr((((len >= 0) && (len < PGForceDownloadThreshold)) ? NSURLSessionResponseAllow : NSURLSessionResponseBecomeDownload));
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
        PGLog(@"didBecomeDownloadTask:");
        _urlTask = downloadTask;
    }

    -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
        PGLog(@"didReceiveData: %@ bytes.", @(data.length));
        if(data.length) [_dataBuild appendData:data];
    }

    -(BOOL)isStatusSuccess {
        NSInteger statusCode = self.urlTaskResponse.statusCode;
        return (statusCode >= 200) && (statusCode < 300);
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
        PGLog(@"didCompleteWithError: %@; code: %@", error.description, @(self.urlTaskResponse.statusCode));

        if(self.isStatusSuccess) {
            self.buffer = _dataBuild;
        }
    }

    -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
        PGLog(@"didFinishCollectingMetrics: %@", metrics.description);
    }

    -(void)URLSession:(NSURLSession *)s dataTask:(NSURLSessionDataTask *)t willCacheResponse:(NSCachedURLResponse *)r completionHandler:(cacheCompHndlr2_t)h {
        PGLog(@"willCacheResponse: NO");
        h(nil);
    }

    -(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
        NSError *error = nil;
        @try {
            PGLog(@"didFinishDownloadingToURL: %@", location.path);
            self.buffer = [NSData dataWithContentsOfFile:location.path options:NSDataReadingMappedIfSafe error:&error];
            _dataBuild = nil;
        }
        @finally {
            if(!self.buffer && error) self.lastError = error;
            _isCompleted = YES;
        }
    }

    -(void)    URLSession:(NSURLSession *)session
             downloadTask:(NSURLSessionDownloadTask *)task
             didWriteData:(int64_t)bytes
        totalBytesWritten:(int64_t)totalBytes
totalBytesExpectedToWrite:(int64_t)expectedBytes {
        PGLog(@"didWriteData:totalBytesWritten:totalBytesExpectedToWrite:");
    }

@end
