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
#import "VoiceUILabel.h"
#import "AudioButton.h"


#define kProgressViewHeight 10


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

@synthesize audioButton;
@synthesize _audioPlayer;

@synthesize audioLabel;
@synthesize recordButton;
@synthesize shareButton;

@synthesize progressView;

@synthesize isRecording = _isRecording;

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
        
        
   
    isChinese = false;
    
    
    
    //[self.view addSubview:scrollView];
    //[self.view addSubview:toolBar];
    
    
     toolBar.frame=CGRectMake(toolBar.frame.origin.x, toolBar.frame.origin.y+toolBar.frame.size.height-kNewsToolBarHeight, toolBar.frame.size.width, kNewsToolBarHeight);

    
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:4];
    
    //设置添加按钮的数量
    
   // UIBarButtonItem *flexibleSpaceItem;
   // flexibleSpaceItem =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
   // [buttons addObject:flexibleSpaceItem];
    
    //UIBarButtonSystemItemFixedSpace和UIBarButtonSystemItemFlexibleSpace都是系统提供的用于占位的按钮样式。
    //使按钮与按钮之间有间距
    
    UIBarButtonItem *Item;
    
     //添加第1个图标按钮
    recordButton =     [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordButton.frame=CGRectMake(0, kProgressViewHeight, 50, 50);
    [recordButton addTarget:self action:@selector(recordingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    Item = [[UIBarButtonItem alloc]
            initWithCustomView:recordButton
           ];
    [buttons addObject:Item];
    //录音器
    self.isRecording = NO;
   

    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

    
    
    
    
    //添加第2个图标按钮
    audioButton =     [[AudioButton alloc] initWithFrame:CGRectMake(50, kProgressViewHeight, 50, 50)];
    [audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    Item = [[UIBarButtonItem alloc]
            initWithCustomView:audioButton
            ];
    [buttons addObject:Item];
    
     //添加第3个图标按钮
     audioLabel =     [[UILabel alloc] initWithFrame:CGRectMake(100, kProgressViewHeight, 100, 50)];
    
    
    
    Item = [[UIBarButtonItem alloc]
            initWithCustomView:audioLabel
            ];
    [buttons addObject:Item];

    //添加第4个图标按钮
    shareButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    shareButton.frame=CGRectMake(200, kProgressViewHeight, 50, 50);
    Item = [[UIBarButtonItem alloc]
            initWithCustomView:shareButton
            ];
    [buttons addObject:Item];
    
   // flexibleSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
    //[buttons addObject:flexibleSpaceItem];
    
   
   // toolBar.barStyle = UIBarStyleBlackOpaque ;
        [toolBar setItems:buttons animated:YES];
    [toolBar sizeToFit];
    
    //进度条
    progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(0, 0, toolBar.frame.size.width, kProgressViewHeight)];
    progressView.gradientColors = @[[UIColor colorWithRed:0.0f green:0.0f blue:0.3f alpha:1.00f],
                                [UIColor colorWithRed:0.3f green:0.3f blue:0.6f alpha:1.00f],
                                [UIColor colorWithRed:0.6f green:0.6f blue:0.9f alpha:1.00f]];
    progressView.verticalGradient = NO;
    
    [toolBar addSubview:progressView ];
    
    

    //初始化数据
    if (news) {
        
        
        [titleLabel setText:news.title];
        [imageView setImageWithURL:[NSURL URLWithString:news.imgBigUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
        
        
        
       NSMutableArray* contentAry =  news.contentAry;
        int y = subContentLabel.frame.origin.y;
        for (int i=0; i<[contentAry count ]; i++) {
            
           NSString* content= [contentAry objectAtIndex:i];
            VoiceUILabel * l = [[VoiceUILabel alloc]init];
            
            l.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [l addGestureRecognizer:singleTap];
            [singleTap release];
            
            
            l.text=content;
            l.voiceUrl=news.voiceUrl;
            
            [l setTextColor:[UIColor redColor]];
            
            
            //高度自适应
            
            CGRect frame = CGRectMake(subContentLabel.frame.origin.x, y, subContentLabel.frame.size.width,2000);
            CGSize labelsize = [l.text sizeWithFont:[UIFont boldSystemFontOfSize: 11.0f]
                                           constrainedToSize:CGSizeMake(subContentLabel.frame.size.width, 2000)
                                               lineBreakMode:UILineBreakModeTailTruncation];
            frame.size.width = labelsize.width;
            frame.size.height = labelsize.height;
            
            
             frame = CGRectMake(subContentLabel.frame.origin.x, y, labelsize.width,labelsize.height);
           
            l.frame = frame;
             y=y+labelsize.height;
            [scrollView addSubview:l];
            [l release];
            
            
            
            
            
            
            
            //高度自适应
            subContentLabel.text=news.subContent;
            CGRect sublabeframe = CGRectMake(subContentLabel.frame.origin.x, y, subContentLabel.frame.size.width,2000);
            CGSize sublabelsize = [subContentLabel.text sizeWithFont:[UIFont boldSystemFontOfSize: 11.0f]
                                  constrainedToSize:CGSizeMake(subContentLabel.frame.size.width, 2000)
                                      lineBreakMode:UILineBreakModeTailTruncation];
            sublabeframe.size.width = labelsize.width;
            sublabeframe.size.height = labelsize.height;
            
            
            sublabeframe = CGRectMake(subContentLabel.frame.origin.x, subContentLabel.frame.origin.y, sublabelsize.width,sublabelsize.height);
            
            subContentLabel.frame = sublabeframe;
            
            [self.view sendSubviewToBack:subContentLabel];


        }
        
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
    [_audioPlayer stop];
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
    recorder = nil;
    player = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // [fileManager removeItemAtPath:recordedFile.path error:nil];
    [fileManager removeItemAtURL:recordedFile error:nil];
    recordedFile = nil;
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
       [_audioPlayer release];
    [audioButton release];
    
    
    [audioLabel release];
    [recordButton release];
     [shareButton release];
    
    [progressView release];
    
      [super dealloc];
}


//事件方法
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    //事件处理。
VoiceUILabel *l =    (VoiceUILabel*) gestureRecognizer.view;
    if( l){
        
        
        if (_audioPlayer == nil) {
            _audioPlayer = [[AudioPlayer alloc] init];
        }
        [_audioPlayer stop]; 
        if ([_audioPlayer.button isEqual:audioButton]) {
           
        } else {
            
            
            
            _audioPlayer.button = audioButton;
            _audioPlayer.progressView = progressView;
            _audioPlayer.audioLabel=audioLabel;
           
        }
        
        _audioPlayer.url = [NSURL URLWithString:l.voiceUrl];
        [_audioPlayer play];
        
    }
    
}




- (IBAction)tabButtonAction:(id)sender
{
    
    if (isChinese) {
        
        [leftButton setHighlighted:NO];
        [rightButton setHighlighted:YES];
        [subContentLabel setHidden:NO];
       [self.view bringSubviewToFront:subContentLabel];
        
        
        
        
        
    }else{
        [leftButton setHighlighted:YES];
        [rightButton setHighlighted:NO];
        [subContentLabel setHidden:YES ];
        
        [self.view sendSubviewToBack:subContentLabel];
        
        
    }
    
    
}


- (void)playAudio:(AudioButton *)button
{
   // NSInteger index = button.tag;
   // NSDictionary *item = [itemArray objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:audioButton]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = audioButton;
        _audioPlayer.progressView = progressView;
        _audioPlayer.audioLabel=audioLabel;
        
        _audioPlayer.url = [NSURL URLWithString:news.voiceUrl];
        
        [_audioPlayer play];
    }
}

- (void)recordingAction:(id)sender
{
    
    //recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    recordedFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    //If the app is not recording, we want to start recording, disable the play button, and make the record button say "STOP"
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        //[self.playButton setEnabled:NO];
        //[self.playButton.titleLabel setAlpha:0.5];
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];
        player = nil;
    }
    //If the app is recording, we want to stop recording, enable the play button, and make the record button say "REC"
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        //[self.playButton setEnabled:YES];
        //[self.playButton.titleLabel setAlpha:1];
        [recorder stop];
        recorder = nil;
        
        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
}


#pragma AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //[self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

@end
