//
//  NewsWebViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolbar.h"
#import "RecordToolbar.h"
#import "UAModalPanel.h"
@class News;
@interface NewsWebViewController  : UIViewController<UIWebViewDelegate,UAModalPanelDelegate>{
@private News *news;
    
@private IBOutlet CustomToolbar *toolBar;
    @private  RecordToolbar *recordToolBar;
@private IBOutlet UIWebView *webView;
    
@private IBOutlet UIScrollView *scrollView;
@private IBOutlet UILabel *titleLabel;
@private IBOutlet UIImageView *imageView;
@private IBOutlet UIButton *leftButton;
@private IBOutlet UIButton *rightButton;
    
    
    NSMutableArray *_tempArrayList;
    NSMutableArray *_arrayItemList;
    
    
    
    BOOL isChinese;
    
    BOOL isAllPlay;//是否顺序播放
    
    int buttonY;
    
    
}

@property(nonatomic,retain)News *news;

@property(nonatomic,retain)CustomToolbar *toolBar;
 @property(nonatomic,retain) RecordToolbar *recordToolBar;
@property(nonatomic,retain)UIWebView *webView;


@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UIButton *leftButton;
@property(nonatomic,retain) UIButton *rightButton;
- (IBAction)tabButtonAction:(id)sender;

-(NSMutableString*)getHtmlContentForTemplate;

@property int textSize;


@property (nonatomic) BOOL isChinese;


@end