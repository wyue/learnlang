//
//  NewsDetailViewController.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "News.h"
#import "Voice.h"
#import "FileModel.h"
#import "VoiceUILabel.h"
#import "AudioButton.h"
#import "DownloadsManager.h"







@interface NewsDetailViewController ()
  
@end

@implementation NewsDetailViewController
@synthesize news;
@synthesize toolBar;
@synthesize scrollView;


@synthesize titleLabel;
@synthesize imageView;
@synthesize leftButton;
@synthesize rightButton;
@synthesize subContentLabel;




@synthesize isChinese = _isChinese;

@synthesize isAllPlay = _isAllPlay;



/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForLabel:(UILabel *)label
{
    [label setNumberOfLines:0];
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 20000)];
    [label sizeToFit];
    return label.frame.size.height;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   //CGRect rect_screen =  [[UIScreen mainScreen]bounds ];
    //CGRect rect_view =[self.view bounds];
    
   // toolBar = [[UIToolbar alloc]init];
   // [toolBar setBackgroundColor:[UIColor redColor]];
   //scrollView=[ [UIScrollView alloc]init];
    
    
    
    
    //初始化控件
    // titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
                                    
                                    initWithTitle:@"返回"
                                    
                                    style:UIBarButtonItemStyleBordered
                                    
                                    target:self
                                    
                                    action:@selector(popViewController)];
    
    
    
    backButton.image=[UIImage imageNamed:@"right_button.png"];
    
    backButton.tintColor=[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [backButton release];
    
    

    //初始化数据
    if (news) {
        
        
        [titleLabel setText:news.title];
        [imageView setImageWithURL:[NSURL URLWithString:news.imgBigUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        
        //切换按钮
        isChinese = false;
        
       
        //高度自适应
        subContentLabel.text=news.subContent;
        
        [self heightForLabel:subContentLabel];

        [subContentLabel setHidden:YES ];//隐藏中文label
        
        [scrollView sendSubviewToBack:subContentLabel];
        
        
       NSMutableArray* contentAry =  news.contentAry;
        int y = subContentLabel.frame.origin.y;
        
        for (int i=0; i<[contentAry count ]; i++) {
            
           Voice* content= [contentAry objectAtIndex:i];
            VoiceUILabel * l = [[VoiceUILabel alloc]init];
            l.indexl=i;
            
            l.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [l addGestureRecognizer:singleTap];
            [singleTap release];
            l.voice=content;
            
            l.text=content.text;
            l.voiceUrl=content.voiceUrl;
            
            [l setTextColor:[UIColor redColor]];
            
            
            //高度自适应

            [l setFrame:CGRectMake(subContentLabel.frame.origin.x, y, subContentLabel.frame.size.width, 2000)];
            
            
            
            
          float labelheight=  [self heightForLabel:l];
            y=y+labelheight;
            
            [scrollView addSubview:l];
            [l release];
            
            
            
      


        }
        
        
        
    
        
        int h =y+15;
        if(h<(subContentLabel.frame.size.height+subContentLabel.frame.origin.y))h=subContentLabel.frame.size.height+subContentLabel.frame.origin.y;
        
         
        //设置scrollView内容高度
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, h)];
        
        
         CGRect rect_view =[self.view bounds];
        toolBar = [[NewsToolbar alloc]initWithFrame:CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight)];
        toolBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        toolBar.news=news;
        [self.view addSubview:toolBar];
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    CGRect rect_view =[self.view bounds];
    toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight);
   // scrollView.frame=CGRectMake(rect_view.origin.x, rect_view.origin.y, rect_view.size.width, rect_view.size.height-kToolBarHeight);
    
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animatedd{
    
    // CGRect rect_view =[self.view bounds];
    // toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kToolBarHeight, rect_view.size.width, kToolBarHeight);
    // scrollView.frame=CGRectMake(rect_view.origin.x, rect_view.origin.y, rect_view.size.width, rect_view.size.height-kToolBarHeight);
    [self.toolBar audioStop];
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
//    recorder = nil;
//    player = nil;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // [fileManager removeItemAtPath:recordedFile.path error:nil];
//    [fileManager removeItemAtURL:recordedFile error:nil];
//    recordedFile = nil;
    [super viewDidUnload];
}

-(void)dealloc{
    
    [news release];
    [toolBar release];
    [scrollView release];
    
    
     [titleLabel release];
     [imageView release];
     [leftButton release];
     [rightButton release];
     [subContentLabel release];
          
      [super dealloc];
}



- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

//事件方法
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    //事件处理。
VoiceUILabel *l =    (VoiceUILabel*) gestureRecognizer.view;
    if( l){
        self.toolBar.isAllPlay=NO;
       NSURL*voiceurl= [DataManager isDownloadFile:l.voice andNew:news];
        if (voiceurl) {
            //本地
            [self.toolBar audioPlay:voiceurl andIndex:l.indexl andIsLocalFile:YES  andIsNew:YES];
        }else{
            //网络
            [self.toolBar audioPlay:[NSURL URLWithString:l.voice.voiceUrl] andIndex:l.indexl andIsLocalFile:NO andIsNew:YES];
        }
        
        
        
    }
    
}




- (IBAction)tabButtonAction:(id)sender
{
    UIButton* button =(UIButton *)sender;
    if (button) {
        if([button isEqual:rightButton]){
            isChinese=TRUE;
        }else{
            isChinese=FALSE;
        }
    }
    NSArray *array = [scrollView subviews];
    if (isChinese) {
        
        for(id label in array){
            if([label isKindOfClass:[UILabel class]]){
                if (![label isEqual:titleLabel]) {
                    UILabel *btn = (UILabel *)label;
                    [btn setHidden:YES];
                }
            }  
        }
        
        [leftButton setHighlighted:NO];
         [leftButton setSelected:NO];
        [rightButton setHighlighted:YES];
        [rightButton setSelected:YES];
        [subContentLabel setHidden:NO];
       [scrollView bringSubviewToFront:subContentLabel];
        
        
        
        
        
    }else{
        
        
        
        for(id label in array){
            if([label isKindOfClass:[UILabel class]]){
                if (![label isEqual:titleLabel]) {
                    UILabel *btn = (UILabel *)label;
                    [btn setHidden:NO];
                }
               
            }
        }
        
        [leftButton setHighlighted:YES];
        [leftButton setSelected:YES];
        [rightButton setHighlighted:NO];
        [rightButton setSelected:NO];
        [subContentLabel setHidden:YES ];
        
        [scrollView sendSubviewToBack:subContentLabel];
        
        
    }
    
    
}




@end
