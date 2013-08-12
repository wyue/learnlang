//
//  DownloadViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadViewController  : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableview;
    NSMutableArray *array;
    
    NSMutableArray *arrayForEdit;
    
}
@property(nonatomic,retain) IBOutlet UITableView* tableview;
@property(nonatomic,retain) NSMutableArray *array;

@property(nonatomic,retain) NSMutableArray *arrayForEdit;


@end