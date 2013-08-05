//
//  AFCustomClient.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFCustomClient : AFHTTPClient

+ (AFCustomClient *)sharedClient;

@end
