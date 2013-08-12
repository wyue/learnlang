//
//  RecordsViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalAudioPlay.h"

@interface RecordsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableview;
    NSMutableArray *array;
    
    NSMutableArray *arrayForEdit;
    
    LocalAudioPlay*localplayer;
    
}
@property(nonatomic,retain) IBOutlet UITableView* tableview;
@property(nonatomic,retain) NSMutableArray *array;

@property(nonatomic,retain) NSMutableArray *arrayForEdit;

@property (retain, nonatomic)  LocalAudioPlay*localplayer;

@end
