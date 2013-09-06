//
//  CustomAudioToolbar.m
//  learnlang
//
//  Created by mooncake on 13-8-30.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "CustomAudioToolbar.h"
#import <Social/Social.h>
#import "DownloadManager.h"

#import "ASIFormDataRequest.h"  


#define kStringArray [NSArray arrayWithObjects:@"收 藏", @"下 载", @"分 享", nil]
#define kProgressViewHeight 2

/* Asset keys */
#define kTracksKey          @"tracks"
#define kPlayableKey		 @"playable"

/* PlayerItem keys */
#define kStatusKey          @"status"

/* AVPlayer keys */
#define kRateKey			 @"rate"
#define kCurrentItemKey	 @"currentItem"

//@interface CustomAudioToolbar 
//
//@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@implementation CustomAudioToolbar

@synthesize news;
@synthesize parentViewController;
@synthesize playButton,audioLabel,recordButton,shareButton;

@synthesize progressView;
@synthesize isRecording = _isRecording;
//音频
@synthesize arrayItemList = _arrayItemList;

@synthesize mPlayer, mPlayerItem;


@synthesize sharingImage,sharingText,slComposerSheet;

@synthesize extMenuTable;

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"floatbg_03.png"];
    CGContextDrawImage(c, rect, image.CGImage);
}
- (id)initWithFrame:(CGRect)frame andShare:(BOOL)isShare
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        //初始化
        
        
        //self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height-kNewsToolBarHeight, self.frame.size.width, kNewsToolBarHeight);
        
        
        
        
//        if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//            [self setBackgroundImage:[ [UIImage imageNamed:@"floatbg_03.png"] resizedImageToFitInSize:self.frame.size scaleIfSmaller:NO] forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
//        }
        
        NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:4];
        
        //设置添加按钮的数量
        
         UIBarButtonItem *flexibleSpaceItem;
         flexibleSpaceItem =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
         [buttons addObject:flexibleSpaceItem];
        
        //UIBarButtonSystemItemFixedSpace和UIBarButtonSystemItemFlexibleSpace都是系统提供的用于占位的按钮样式。
        //使按钮与按钮之间有间距
        
        UIBarButtonItem *Item;
        
        //        //添加第1个图标按钮
        //        recordButton =     [UIButton buttonWithType:UIButtonTypeCustom];
        //        [recordButton setImage:[UIImage imageNamed:@"musicbar-_05.png"] forState:UIControlStateNormal];
        //        recordButton.frame=CGRectMake(0, kProgressViewHeight, 57.5, 58.5);
        //        [recordButton addTarget:self action:@selector(recordingAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        //        Item = [[UIBarButtonItem alloc]
        //                initWithCustomView:recordButton
        //                ];
        //        [buttons addObject:Item];
        //        //录音器
        //        self.isRecording = NO;
        //
        //
        //
        //        AVAudioSession *session = [AVAudioSession sharedInstance];
        //
        //        NSError *sessionError;
        //        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        //
        //        if(session == nil)
        //            NSLog(@"Error creating session: %@", [sessionError description]);
        //        else
        //            [session setActive:YES error:nil];
        //
        //
        //
        
        
        //添加第2个图标按钮
        
        playButton=  [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"musicbar-_07.png"] forState:UIControlStateNormal];
        
        playButton.frame=CGRectMake(50, kProgressViewHeight, 56.5, 58.5);
        
        [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:playButton
                ];
        [buttons addObject:Item];
        
        
        
        
        
        //空间
        [buttons addObject:[self barButtonSystemItem:UIBarButtonSystemItemFlexibleSpace]];
        //竖线
        
        UIImageView *splitline = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"musicbar-_06.png"]]autorelease];
        splitline.frame=CGRectMake(58.5, kProgressViewHeight, 1, 58.5);
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:splitline
                ];
        [buttons addObject:Item];
        
        //空间
        [buttons addObject:[self barButtonSystemItem:UIBarButtonSystemItemFlexibleSpace]];

        
        
        //添加第3个图标按钮
        audioLabel =     [[UILabel alloc] initWithFrame:CGRectMake(100, kProgressViewHeight, 100, 50)];
        
        audioLabel.backgroundColor = [UIColor clearColor];
        audioLabel.textColor=[UIColor colorWithHexString:@"756860"];
        
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:audioLabel
                ];
        [buttons addObject:Item];
        if (isShare==YES) {
            //空间
            [buttons addObject:[self barButtonSystemItem:UIBarButtonSystemItemFlexibleSpace]];
            //竖线
            
            splitline = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"musicbar-_06.png"]]autorelease];
            splitline.frame=CGRectMake(58.5, kProgressViewHeight, 1, 58.5);
            Item = [[UIBarButtonItem alloc]
                    initWithCustomView:splitline
                    ];
            [buttons addObject:Item];
            
            //空间
            [buttons addObject:[self barButtonSystemItem:UIBarButtonSystemItemFlexibleSpace]];
            
            
            //添加第4个图标按钮
            shareButton=  [UIButton buttonWithType:UIButtonTypeCustom];
            [shareButton setImage:[UIImage imageNamed:@"musicbar-_11.png"] forState:UIControlStateNormal];
            
            shareButton.frame=CGRectMake(200, kProgressViewHeight, 60, 58.5);
            
            [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            Item = [[UIBarButtonItem alloc]
                    initWithCustomView:shareButton
                    ];
            [buttons addObject:Item];
        }
       
        
    flexibleSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
        [buttons addObject:flexibleSpaceItem];
        
        
        // toolBar.barStyle = UIBarStyleBlackOpaque ;
        [self setItems:buttons animated:YES];
        [self sizeToFit];
        
        //进度条
        progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kProgressViewHeight)];
        progressView.gradientColors = @[[UIColor colorWithHexString:@"E20001"],
                                        [UIColor colorWithHexString:@"ED3F00"],
                                        [UIColor colorWithHexString:@"FEAB00"]];
        progressView.verticalGradient = NO;
        
        [self addSubview:progressView ];
        
        
        
    
    }
    return self;
}

-  (UIBarButtonItem*)barButtonSystemItem :(UIBarButtonSystemItem)

systemItem {
    
    UIBarButtonItem* button =
    
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
      
                                                   target:nil
      
                                                   action:nil] autorelease];
    
    return button;
    
}
//-(id)initWithArrayItem:(NSMutableArray *)arrayItemValue {
//    self = [super init];
//    if (self)
//    {
//        //        if (!_timerPlay)
//        //        {
//        //            _timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(currentPlayTime) userInfo:nil repeats:YES];
//        //        }
//        self.arrayItemList = arrayItemValue;
//        
//        
//        
//        
//        
//        
//        //初始化
//        
//        
//        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height-kNewsToolBarHeight, self.frame.size.width, kNewsToolBarHeight);
//        
//        
//        
//        
//        if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//            [self setBackgroundImage:[ [UIImage imageNamed:@"floatbg_03.png"] resizedImageToFitInSize:self.bounds.size scaleIfSmaller:NO] forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
//        }
//        
//        NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:4];
//        
//        //设置添加按钮的数量
//        
//        // UIBarButtonItem *flexibleSpaceItem;
//        // flexibleSpaceItem =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
//        // [buttons addObject:flexibleSpaceItem];
//        
//        //UIBarButtonSystemItemFixedSpace和UIBarButtonSystemItemFlexibleSpace都是系统提供的用于占位的按钮样式。
//        //使按钮与按钮之间有间距
//        
//        UIBarButtonItem *Item;
//        
////        //添加第1个图标按钮
////        recordButton =     [UIButton buttonWithType:UIButtonTypeCustom];
////        [recordButton setImage:[UIImage imageNamed:@"musicbar-_05.png"] forState:UIControlStateNormal];
////        recordButton.frame=CGRectMake(0, kProgressViewHeight, 57.5, 58.5);
////        [recordButton addTarget:self action:@selector(recordingAction:) forControlEvents:UIControlEventTouchUpInside];
////        
////        Item = [[UIBarButtonItem alloc]
////                initWithCustomView:recordButton
////                ];
////        [buttons addObject:Item];
////        //录音器
////        self.isRecording = NO;
////        
////        
////        
////        AVAudioSession *session = [AVAudioSession sharedInstance];
////        
////        NSError *sessionError;
////        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
////        
////        if(session == nil)
////            NSLog(@"Error creating session: %@", [sessionError description]);
////        else
////            [session setActive:YES error:nil];
////        
////        
////        
//        
//        
//        //添加第2个图标按钮
//        
//        playButton=  [UIButton buttonWithType:UIButtonTypeCustom];
//        [playButton setImage:[UIImage imageNamed:@"musicbar-_07.png"] forState:UIControlStateNormal];
//        
//        playButton.frame=CGRectMake(50, kProgressViewHeight, 56.5, 58.5);
//        
//        [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
//        
//        Item = [[UIBarButtonItem alloc]
//                initWithCustomView:playButton
//                ];
//        [buttons addObject:Item];
//        
//        //添加第3个图标按钮
//        audioLabel =     [[UILabel alloc] initWithFrame:CGRectMake(100, kProgressViewHeight, 100, 50)];
//        
//        audioLabel.backgroundColor = [UIColor clearColor];
//        audioLabel.textColor=[UIColor colorWithHexString:@"756860"];
//        
//        Item = [[UIBarButtonItem alloc]
//                initWithCustomView:audioLabel
//                ];
//        [buttons addObject:Item];
//        
////        //添加第4个图标按钮
////        shareButton=  [UIButton buttonWithType:UIButtonTypeCustom];
////        [shareButton setImage:[UIImage imageNamed:@"musicbar-_11.png"] forState:UIControlStateNormal];
////        
////        shareButton.frame=CGRectMake(200, kProgressViewHeight, 60, 58.5);
////        
////        [shareButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
////        
////        
////        
////        Item = [[UIBarButtonItem alloc]
////                initWithCustomView:shareButton
////                ];
////        [buttons addObject:Item];
//        
//        // flexibleSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
//        //[buttons addObject:flexibleSpaceItem];
//        
//        
//        // toolBar.barStyle = UIBarStyleBlackOpaque ;
//        [self setItems:buttons animated:YES];
//        [self sizeToFit];
//        
//        //进度条
//        progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kProgressViewHeight)];
//        progressView.gradientColors = @[[UIColor colorWithHexString:@"E20001"],
//                                        [UIColor colorWithHexString:@"ED3F00"],
//                                        [UIColor colorWithHexString:@"FEAB00"]];
//        progressView.verticalGradient = NO;
//        
//        [self addSubview:progressView ];
//        
//        
//        
//    }
//    return self;
//}



- (void)viewDidUnload
{
    
    recorder = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // [fileManager removeItemAtPath:recordedFile.path error:nil];
    [fileManager removeItemAtURL:recordedFile error:nil];
    recordedFile = nil;
    //[super viewDidUnload];
}

-(void)dealloc {
    //[_player release];
    [self removePlayerTimeObserver];
	
	[self.mPlayer removeObserver:self forKeyPath:@"rate"];
	[mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
	
	[self.mPlayer pause];
	self.mPlayer = nil;
	
    [mTimeObserver release];
    [_timerPlay invalidate];
    [mURL release];
    
    [news release];
    
    [parentViewController release];
    
    
    [playButton release];
    
    
    [audioLabel release];
    
    [recordButton release];
    [shareButton release];
    
    [progressView release];
    
    
    [sharingText release];
    [sharingImage release];
    [slComposerSheet release];
    
    [extMenuTable release];
    [_arrayItemList release];
    [super dealloc];
}

- (void)playAudio:(id *)sender
{
    
    if ([self isPlaying]) {
        [self pause:nil];
    }else{
        
//        if (self.URL==nil) {
//            NSURL*voiceurl= [DataManager isDownloadFile:news];
//            if (voiceurl) {
//                //本地
//                
//                [self setupAVPlayerForURL:voiceurl];
//                
//            }else{
//                //网络
//                [self setupAVPlayerForURL:[NSURL URLWithString:news.voiceUrl]];
//                
//            }
//        }
        
        [self play:nil];
    }
    
    
    
    
}

//音频begin
#pragma mark Asset URL

- (void)setURL:(NSURL*)URL
{
	if (mURL != URL)
	{
		[mURL release];
		mURL = [URL copy];
		
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset keys "tracks", "playable".
         */
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mURL options:nil];
        
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
	}
}

- (NSURL*)URL
{
	return mURL;
}

-(void)playToTime:(NSUInteger)index {
    // [self playAudio:nil];
    if (mPlayer) {
        NSDictionary *dic = [self.arrayItemList objectAtIndex:index];
        NSString *key = @"key is nil";
        NSString *value = @"value is nil";
        if (dic)
        {
            key = [dic.allKeys objectAtIndex:0];
            value = [dic objectForKey:key];
            CMTime t = CMTimeMake([key intValue], 1);
            [mPlayer seekToTime:t];
            
        }
    }
    
    
    
}

-(void) setupAVPlayerForURL: (NSURL*) url {
    //    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    //    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    //
    //    _player = [[AVPlayer playerWithPlayerItem:anItem] retain];
    //    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
    [self setURL:url];
    
    [ [NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    
    
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance]; [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//    if (object == _player && [keyPath isEqualToString:@"status"]) {
//        if (_player.status == AVPlayerStatusFailed) {
//            NSLog(@"AVPlayer Failed");
//        } else if (_player.status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayer Ready to Play");
//        } else if (_player.status == AVPlayerItemStatusUnknown) {
//            NSLog(@"AVPlayer Unknown");
//        }
//    }
//}

-(Float64) currentPlayTime
{
    if (mPlayer)
    {
        CMTime currentTime = mPlayer.currentItem.currentTime;
        Float64 fCurrentTime = CMTimeGetSeconds(currentTime);
        //        NSLog(@"fCurrentPlayTime = %f",fCurrentTime);
        int currentIndex = [self currentPlayIndex:[NSString stringWithFormat:@"%f",fCurrentTime]];
        
//        [((NewsWebViewController*)self.parentViewController).webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setHighlight(%d);",currentIndex ]];
        [self updateProgress];
        //js
        
        //[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(NSUInteger )currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        //NSLog(@"currentIndex = %d",currentIndex);
        return fCurrentTime;
    }
    return -1.0f;
}

//- (NSString *)totalTime
//{
//    NSString *total = [NSString stringWithFormat:@"-%d:%02d",
//                       (int)((int)[self duration] ) / 60,
//                       (int)((int)[self duration]) % 60, nil];
//    return total;
//}

- (void)updateProgress
{
    
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        [progressView setProgress:0.0f];
        audioLabel.text=@"";
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        
        double time = CMTimeGetSeconds([self.mPlayer currentTime]);
        
        [self.progressView setProgress: time / duration];
        
        NSString *total = [NSString stringWithFormat:@"%d:%02d",
                           (int)((int)duration ) / 60,
                           (int)((int)duration) % 60, nil];
        
        NSString *current = [NSString stringWithFormat:@"%d:%02d",
                             (int)time/ 60,
                             (int)time % 60, nil];
        
        audioLabel.text=[NSString stringWithFormat:@"%@/%@",current,total];
    }
    
    // } else {
    //    [button setProgress:0.0f];
    //    [progressView setProgress:0.0f];
    //    audioLabel.text=@"";
    
    //}
}




- (IBAction)play:(id)sender
{
	/* If we are at the end of the movie, we must seek to the beginning first
     before starting playback. */
	if (YES == seekToZeroBeforePlay)
	{
		seekToZeroBeforePlay = NO;
		[self.mPlayer seekToTime:kCMTimeZero];
	}
    if ([Config getUserSettingForAudioPlayInBackground]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }else{
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
        [audioSession setActive:YES error:nil];
    }
	[self.mPlayer play];
    
    if (!_timerPlay)
    {
        _timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(currentPlayTime) userInfo:nil repeats:YES];
    }
    
    
	
    [self showStopButton];
}

- (IBAction)pause:(id)sender
{
	[self.mPlayer pause];
    
    // if ([_timerPlay isValid]) { [_timerPlay setFireDate:[NSDate distantFuture]]; }
    if (_timerPlay) {
        [_timerPlay invalidate];
        _timerPlay=nil;
    }
    
    
    [self showPlayButton];
}

#pragma mark -
#pragma mark Play, Stop buttons

/* Show the stop button in the movie player controller. */
-(void)showStopButton
{
    //    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self items]];
    //    [toolbarItems replaceObjectAtIndex:1 withObject:self.mStopButton];
    //    self.mToolbar.items = toolbarItems;
    [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
}

/* Show the play button in the movie player controller. */
-(void)showPlayButton
{
    //    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.mToolbar items]];
    //    [toolbarItems replaceObjectAtIndex:0 withObject:self.mPlayButton];
    //    self.mToolbar.items = toolbarItems;
    [playButton setImage:[UIImage imageNamed:@"musicbar-_07.png"] forState:UIControlStateNormal];
}

/* If the media is playing, show the stop button; otherwise, show the play button. */
- (void)syncPlayPauseButtons
{
	if ([self isPlaying])
	{
        [self showStopButton];
	}
	else
	{
        [self showPlayButton];
	}
}

-(void)enablePlayerButtons
{
    //self.mPlayButton.enabled = YES;
    //self.mStopButton.enabled = YES;
}

-(void)disablePlayerButtons
{
    //self.mPlayButton.enabled = NO;
    //self.mStopButton.enabled = NO;
}



-(int) currentPlayIndex:(NSString*) currentPlaySecond
{
    if (!currentPlaySecond || currentPlaySecond.length <= 0)
        return 0;
    //float fCurrentSecond = currentPlaySecond.floatValue;
    int index;
    for (index = 0; index < self.arrayItemList.count; index++)
    {
        NSDictionary *dic = [self.arrayItemList objectAtIndex:index];
        if (dic)
        {
            NSString * strSecondValue = [dic.allKeys objectAtIndex:0];
            float fValue = strSecondValue.floatValue;
            if (fValue > currentPlaySecond.floatValue)
                break;
        }
    }
    return index - 1;
}




//
//
//- (void)recordingAction:(id)sender
//{
//    
//    //recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
//    //获得系统时间
//    
//    //If the app is not recording, we want to start recording, disable the play button, and make the record button say "STOP"
//    if(!self.isRecording)
//    {
//        
//        NSDate *  senddate=[NSDate date];
//        int time=[senddate timeIntervalSince1970];
//        NSString *fileName = [NSString stringWithFormat:@"%d-%d.caf",self.news._id,time];
//        // NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        
//        recordedFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER,fileName]];
//        
//        self.isRecording = YES;
//        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
//        //[self.playButton setEnabled:NO];
//        //[self.playButton.titleLabel setAlpha:0.5];
//        [recorder release];
//        recorder = nil;
//        
//        
//        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        NSError *err = nil;
//        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
//        if(err){
//            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//            return;
//        }
//        [audioSession setActive:YES error:&err];
//        err = nil;
//        if(err){
//            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//            return;
//        }
//        
//        NSMutableDictionary * recordSetting = [[NSMutableDictionary alloc] init];
//        
//        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//        
//        [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//        
//        
//        
//        
//        
//        
//        
//        
//        NSError *error = nil;
//        
//        
//        
//        
//        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
//        if ([recorder prepareToRecord] == YES){
//            [recorder record];
//        }else {
//            int errorCode = CFSwapInt32HostToBig ([error code]);
//            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
//            
//        }
//        
//    }
//    //If the app is recording, we want to stop recording, enable the play button, and make the record button say "REC"
//    else
//    {
//        self.isRecording = NO;
//        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
//        //[self.playButton setEnabled:YES];
//        //[self.playButton.titleLabel setAlpha:1];
//        [recorder stop];
//        
//        
//        //        NSError *err = nil;
//        //        NSData *audioData = [NSData dataWithContentsOfURL:recordedFile options: 0 error:&err];
//        //        if(!audioData)
//        //            NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//        recorder = nil;
//        
//        
//        //保存
//        
//        [DataManager insertRecord:news andFilePath:recordedFile];
//        
//        //        NSError *playerError;
//        //
//        //        localplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
//        //
//        //        if (player == nil)
//        //        {
//        //            NSLog(@"ERror creating player: %@", [playerError description]);
//        //        }
//        //        player.delegate = self;
//    }
//}
//- (void)popAction:(id)sender
//{
//    UIButton *button =sender;
//    
//    if (extMenuTable==nil) {
//        extMenuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 105)];
//    }
//    extMenuTable.separatorColor=[UIColor colorWithHexString:@"BEBEBE"];
//    extMenuTable.delegate = self;
//    extMenuTable.dataSource = self;
//    
//    
//    PopoverView*   pv = [PopoverView showPopoverAtPoint:CGPointMake(button.bounds.size.width/2,0)
//                                                 inView:button
//                                        withContentView:extMenuTable
//                                               delegate:self]; // Show the string array defined at top of this file
//    [pv retain];
//    
//    
//    
//}
//- (void)saveAction:(id)sender
//{
//    NSString * json =  [DataManager getNewsForJson:news];
//    if (json) {
//        Boolean isInsert =    [DataManager insertOrRemoveNews:kSaveType andID:news._id andString:json];
//        
//        if (isInsert) {
//            //保存
//            
//            [Config ToastNotification:@"收藏成功" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//        }else{
//            //取消保存
//            [Config ToastNotification:@"已取消收藏" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//        }
//        
//        
//        
//        //增加保存
//        [DataManager postSaveToServer:news andCancel:!isInsert];
//        
//        
//    }else{
//        //无法保存
//        [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//    }
//    
//    
//}
//
//- (void)downloadAction:(id)sender
//{
//    
//    
//    [Config Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
//    if (![Config Instance].isNetworkRunning&&[Config getUserSettingFor3gDownload]) {
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您现在非wifi环境，是否继续下载？"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"取消"
//                                             destructiveButtonTitle:nil
//                                                  otherButtonTitles:@"下载",nil];
//        [sheet showInView:self.parentViewController.view withCompletionHandler:^(NSInteger buttonIndex) {
//            NSLog(@"action:%d",buttonIndex);
//            
//            if (buttonIndex==1) {
//                return ;
//            }else{
//                
//                NSString * json =  [DataManager getNewsForJson:news];
//                if (json) {
//                    Boolean isDownload =   [DataManager isDownload:news._id];
//                    
//                    
//                    if (isDownload) {
//                        
//                        [Config ToastNotification:@"已下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//                        
//                    }else{
//                        
//                        
//                        //下载
//                        if (news.voiceUrl&&news.voiceUrl.length>0) {
//                            //保存
//                            
//                            [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
//                            [Config ToastNotification:@"开始下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//                            
//                            
//                            
//                            [[DownloadManager Instance] beginRequest:news isBeginDown:YES];
//                            //增加保存
//                            [DataManager postDownloadToServer:news];
//                            
//                        }
//                        
//                    }
//                    
//                    
//                }else{
//                    //无法保存
//                    [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//                }
//                
//            }
//            
//            
//            
//        }];
//        [ [NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        
//    }else{
//        NSString * json =  [DataManager getNewsForJson:news];
//        if (json) {
//            Boolean isDownload =   [DataManager isDownload:news._id];
//            
//            
//            if (isDownload) {
//                
//                [Config ToastNotification:@"已下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//                
//            }else{
//                
//                
//                //下载
//                if (news.voiceUrl&&news.voiceUrl.length>0) {
//                    //保存
//                    
//                    [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
//                    [Config ToastNotification:@"开始下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//                    
//                    
//                    
//                    
//                    [[DownloadManager Instance] beginRequest:news isBeginDown:YES];
//                    //增加保存
//                    [DataManager postDownloadToServer:news];
//                }
//                
//            }
//        }else{
//            //无法保存
//            [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
//        }
//        
//    }
//    
//    
//    
//}
//3、上传初始化
- (void)uploadPotoSave
{
    
    
   
    NSString *stringImage=[self.URL path];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://learn.china.com.cn/api?vkey=%@&u=%@",@"",@""]];
    ASIFormDataRequest *ASIFormDataRequest_=[[ASIFormDataRequest alloc] initWithURL:url];
    //要上传的图片
    [ASIFormDataRequest_ setFile:stringImage forKey:@"file_pic_big"];
    //上传结果委托
    ASIFormDataRequest_.delegate=self;
   
    //上传进度委托
    ASIFormDataRequest_.uploadProgressDelegate=self;
    ASIFormDataRequest_.showAccurateProgress=YES;
    
    //开始异步上传
    [ASIFormDataRequest_ startSynchronous];
    [ASIFormDataRequest_ release];
}
- (void)requestFinished:(ASIFormDataRequest *)requestForm{
    NSString *string=[requestForm responseString];
    NSLog(@"string:%@",string);
//    NSMutableDictionary *_dic=[string JSONValue];
//    if ([[_dic objectForKey:@"status"] intValue]==1) {
//        if (isPoto==NO) {
//            //非图片上传
//        }else{
//            //图片上传
//            UtilMethod *utlMethod=[[UtilMethod alloc] init];
//            NSString *documemnt=[utlMethod documentFolderPath];
//            NSString *stringImage=[NSString stringWithFormat:@"%@%@",documemnt,@"/tmp_30.jpg"];
//            [utlMethod release];
//            //可以把30×30的图片显示到界面适当的位置上
//            
//        }
//        
//    }else{
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:[_dic objectForKey:@"info"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        
//    }
    
    
    //成功后记录上传成功
   // [DataManager saveUpload:self.URL.path];
}
- (void)shareAction:(id)sender
{
    
    //如果没上传先上传
    if (![DataManager isUpload:self.URL.path]) {
        
        
        
        [self uploadPotoSave];
        
        
        
        
    }
    
    
    
    
    if([SLComposeViewController class] != nil)
    {
        //
        //
        //        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        //            NSLog(@"start completion block");
        //            NSString *output;
        //            switch (result) {
        //                case SLComposeViewControllerResultCancelled:
        //                    output = @"Action Cancelled";
        //                    break;
        //                case SLComposeViewControllerResultDone:
        //                    output = @"Post Successfull";
        //                    break;
        //                default:
        //                    break;
        //            }
        //            if (result != SLComposeViewControllerResultCancelled)
        //            {
        //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享内容" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //                [alert show];
        //            }
        //        }];
        //        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
        //        {
        //            slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        //
        //            self.sharingText=[NSString stringWithFormat:@"我正在通过%@学习%@，快来一起吧 %@",AppTitle,AppLang,AppUrl];
        //
        //
        //
        //            [slComposerSheet setInitialText:self.sharingText];
        //            [slComposerSheet addImage:self.sharingImage];
        //            [slComposerSheet addURL:[NSURL URLWithString:@"http://www.weibo.com/"]];
        //            [self.parentViewController presentViewController:slComposerSheet animated:YES completion:nil];
        //        }
        SLComposeViewController *currentComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [currentComposeViewController setInitialText:[NSString stringWithFormat:@"我正在通过%@分享一段学习音频，快来听听说的怎么样 ",AppTitle]];
        //[currentComposeViewController addImage:[UIImage imageNamed:@"1.jpg"]];
        [currentComposeViewController addURL:[NSURL URLWithString:AppUrl]];
        currentComposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
            switch (result)
            {
                case SLComposeViewControllerResultDone:
                    
                    break;
                case SLComposeViewControllerResultCancelled:
                    
                default:
                    break;
            }
            [currentComposeViewController	dismissViewControllerAnimated:YES
                                                             completion:nil];
        };
        [self.parentViewController presentViewController:currentComposeViewController
                                                animated:YES
                                              completion:nil];
        
    } else {
        UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您的iOS版本低于6.0，无法支持微博分享功能." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [osAlert show];
        NSLog(@"Your iOS version is below iOS6");
        
    }
    
    
    
    
    
}




-(void) changeVoiceLabelColor:(Voice*)content{
    //设置字体颜色
    //    if (self.parentViewController&&[self.parentViewController isKindOfClass:[NewsDetailViewController class]]) {
    //        NewsDetailViewController *pview = (NewsDetailViewController *) self.parentViewController;
    //
    //
    //        NSArray *array = [pview.scrollView subviews];
    //
    //
    //        for(id label in array){
    //            if([label isKindOfClass:[VoiceUILabel class]]){
    //                VoiceUILabel *le =  label;
    //                if (le.tag==content.id) {
    //                    le.textColor=[UIColor redColor];
    //                }else{
    //                    le.textColor=[UIColor blackColor];
    //                }
    //
    //            }
    //        }
    //
    //
    //
    //
    //    }
}


#pragma mark  - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [kStringArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor=[UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    
    cell.textLabel.text=[kStringArray objectAtIndex:indexPath.row];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSelector:@selector(saveAction:) withObject:nil afterDelay:0.5f];
            break;
        case 1:
            [self performSelector:@selector(downloadAction:) withObject:nil afterDelay:0.5f];
            break;
        case 2:
            [self performSelector:@selector(shareAction:) withObject:nil afterDelay:0.5f];
            break;
            
        default:
            break;
    }
    
}



#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
    //    switch (index) {
    //        case 0:
    //            [self performSelector:@selector(saveAction:) withObject:nil afterDelay:0.5f];
    //            break;
    //        case 1:
    //            [self performSelector:@selector(downloadAction:) withObject:nil afterDelay:0.5f];
    //            break;
    //        case 2:
    //            [self performSelector:@selector(shareAction:) withObject:nil afterDelay:0.5f];
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    // Figure out which string was selected, store in "string"
    // NSString *string = [kStringArray objectAtIndex:index];
    
    // Show a success image, with the string from the array
    //[popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
    
    // alternatively, you can use
    // [popoverView showSuccess];
    // or
    // [popoverView showError];
    
    // Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [popoverView release], popoverView = nil;
}



//@end
//
//
//@implementation CustomAudioToolbar (Player)

#pragma mark Player Item

- (BOOL)isPlaying
{
	return mRestoreAfterScrubbingRate != 0.f || [self.mPlayer rate] != 0.f;
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
	/* After the movie has played to its end time, seek back to time zero
     to play it again. */
	seekToZeroBeforePlay = YES;
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
	AVPlayerItem *playerItem = [self.mPlayer currentItem];
	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
	{
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}


/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[self.mPlayer removeTimeObserver:mTimeObserver];
		[mTimeObserver release];
		mTimeObserver = nil;
	}
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    // [self syncScrubber];
    //[self disableScrubber];
    [self disablePlayerButtons];
    
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
	}
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
	
	/* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.mPlayerItem removeObserver:self forKeyPath:kStatusKey];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
    }
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
	
    seekToZeroBeforePlay = NO;
	
    /* Create new player, if we don't already have one. */
    if (!self.mPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
		
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur*/
        [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        
        [self syncPlayPauseButtons];
    }
	
    //[self.mScrubber setValue:0.0];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
	/* AVPlayerItem "status" property value observer. */
	if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
	{
		[self syncPlayPauseButtons];
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                [self removePlayerTimeObserver];
                //[self syncScrubber];
                
                //[self disableScrubber];
                [self disablePlayerButtons];
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                //[self initScrubberTimer];
                
                //[self enableScrubber];
                [self enablePlayerButtons];
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
	{
        [self syncPlayPauseButtons];
	}
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [self disablePlayerButtons];
            //[self disableScrubber];
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            //[self.mPlaybackView setPlayer:mPlayer];
            
            //[self setViewDisplayName];
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
            //[self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            [self syncPlayPauseButtons];
        }
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}


@end
