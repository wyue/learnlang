//
//  RecordsViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalAudioPlay.h"
@class CustomAudioToolbar;
@interface RecordsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableview;
    NSMutableArray *array;
    
    NSMutableArray *arrayForEdit;
    
    LocalAudioPlay*localplayer;
    
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

@property (retain, nonatomic)  LocalAudioPlay*localplayer;

@property BOOL isExt;
@property(nonatomic,retain) NSIndexPath * currentIndex;

@property(nonatomic,retain) UIButton* playButton;
@property(nonatomic,retain) UIButton* postButton;
@property(nonatomic,retain) UIButton* delButton;
@property(nonatomic,retain) UIButton* delAllButton;

@property(nonatomic,retain) CustomAudioToolbar* toolBar;

@end
