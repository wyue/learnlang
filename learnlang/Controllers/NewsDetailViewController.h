//
//  NewsDetailViewController.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsToolbar.h"


@class News;

@interface NewsDetailViewController : UIViewController{
@private News *news;
    
@private IBOutlet NewsToolbar *toolBar;
@private IBOutlet UIScrollView *scrollView;
    
    
    
@private IBOutlet UILabel *titleLabel;
@private IBOutlet UIImageView *imageView;
@private IBOutlet UIButton *leftButton;
@private IBOutlet UIButton *rightButton;
@private IBOutlet UILabel * subContentLabel;
    
    
   
    
        
    BOOL isChinese;
    
    BOOL isAllPlay;//是否顺序播放
    
    
}

@property(nonatomic,retain)News *news;

@property(nonatomic,retain)NewsToolbar *toolBar;
@property(nonatomic,retain)UIScrollView *scrollView;


@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UIButton *leftButton;
@property(nonatomic,retain) UIButton *rightButton;
@property(nonatomic,retain) UILabel * subContentLabel;



@property (nonatomic) BOOL isChinese;

@property (nonatomic) BOOL isAllPlay;



- (IBAction)tabButtonAction:(id)sender;

@end
