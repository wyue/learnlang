//
//  NewsViewController.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIProgressDelegate.h"
#import "MBProgressHUD.h"


@interface NewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate, UITabBarControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray * newsAry;
    NSMutableDictionary *newsDic;
    NSMutableArray      *sectionNames;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic, retain) NSMutableDictionary *newsDic;
@property (nonatomic, retain) NSMutableArray *sectionNames;

@property (strong, nonatomic) IBOutlet UITableView *tableNews;
@property int catalog;
- (void)reloadType:(int)ncatalog;
- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
