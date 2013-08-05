//
//  DataSingleton.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadingCell.h"

@interface DataSingleton : NSObject

#pragma 单例模式
+ (DataSingleton *) Instance;
+ (id)allocWithZone:(NSZone *)zone;

//返回标示正在加载的选项
- (UITableViewCell *)getLoadMoreCell:(UITableView *)tableView
                       andIsLoadOver:(BOOL)isLoadOver
                   andLoadOverString:(NSString *)loadOverString
                    andLoadingString:(NSString *)loadingString
                        andIsLoading:(BOOL)isLoading;

@end
