//
//  SavedViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableView;
    NSMutableArray *array;
}
@property(nonatomic,retain) IBOutlet UITableView* tableView;
@property(nonatomic,retain) NSMutableArray *array;
@end
