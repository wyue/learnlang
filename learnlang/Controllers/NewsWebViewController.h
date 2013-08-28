//
//  NewsWebViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolbar.h"


@class News;
@interface NewsWebViewController  : UIViewController<UIWebViewDelegate>{
@private News *news;
    
@private IBOutlet CustomToolbar *toolBar;
@private IBOutlet UIWebView *webView;
    
    
    
    NSMutableArray *_tempArrayList;
    NSMutableArray *_arrayItemList;
    
    
    
    BOOL isChinese;
    
    BOOL isAllPlay;//是否顺序播放
    
    
}

@property(nonatomic,retain)News *news;

@property(nonatomic,retain)CustomToolbar *toolBar;
@property(nonatomic,retain)UIWebView *webView;





@property int textSize;





@end