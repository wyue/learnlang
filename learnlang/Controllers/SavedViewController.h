//
//  SavedViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAudioToolbar.h"

@interface SavedViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableview;
    NSMutableArray *array;
     NSMutableArray *arrayForEdit;
    
    
    //扩展
    BOOL isExt;
    NSIndexPath * currentIndex;
    
    UIButton* playButton;
    UIButton* postButton;
    UIButton* delButton;
    UIButton* delAllButton;
    CustomAudioToolbar* toolBar;
}
@property(nonatomic,retain) IBOutlet UITableView* tableview;
@property(nonatomic,retain) NSMutableArray *array;
@property(nonatomic,retain) NSMutableArray *arrayForEdit;

@property BOOL isExt;
@property(nonatomic,retain) NSIndexPath * currentIndex;

@property(nonatomic,retain) UIButton* playButton;
@property(nonatomic,retain) UIButton* postButton;
@property(nonatomic,retain) UIButton* delButton;
@property(nonatomic,retain) UIButton* delAllButton;

@property(nonatomic,retain) CustomAudioToolbar* toolBar;
@end
