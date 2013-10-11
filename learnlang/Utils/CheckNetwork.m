//
//  CheckNetwork.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "CheckNetwork.h"
#import "Reachability.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
    	BOOL isExistenceNetwork;
    	Reachability *r = [Reachability reachabilityWithHostName:@"www.china.com.cn"];
        switch ([r currentReachabilityStatus]) {
           case NotReachable:
    			isExistenceNetwork=FALSE;
                //   NSLog(@"离线");
                break;
            case ReachableViaWWAN:
    			isExistenceNetwork=TRUE;
                //   NSLog(@"3G");
                break;
          case ReachableViaWiFi:
    			isExistenceNetwork=TRUE;
                //  NSLog(@"wifi");
                break;
    }
    	return isExistenceNetwork;
    
    return YES;
}

+(BOOL)isExistence3G
{
    BOOL isExistenceNetwork;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.china.com.cn"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            //   NSLog(@"离线");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            //   NSLog(@"3G");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=FALSE;
            //  NSLog(@"wifi");
            break;
    }
    return isExistenceNetwork;
    
    return YES;
}

@end
