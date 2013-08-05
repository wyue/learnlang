//
//  AFCustomClient.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "AFCustomClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFAppDotNetAPIBaseURLString = @"http://learn.china.cn/api";

@implementation AFCustomClient



+ (AFCustomClient *)sharedClient {
    static AFCustomClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFCustomClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	//[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
