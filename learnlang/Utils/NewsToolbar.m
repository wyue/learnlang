//
//  NewsToolbar.m
//  learnlang
//
//  Created by mooncake on 13-7-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsToolbar.h"
#import "DownloadsManager.h"
#import "AudioButton.h"
#import "NewsDetailViewController.h"
#import <Social/Social.h>
#define kProgressViewHeight 2

@implementation NewsToolbar

@synthesize news;
@synthesize parentViewController;
@synthesize audioButton;
@synthesize _audioPlayer;

@synthesize audioLabel;

@synthesize recordButton;
@synthesize shareButton;

@synthesize progressView;

@synthesize isRecording = _isRecording;
@synthesize isChinese = _isChinese;

@synthesize isAllPlay = _isAllPlay;

@synthesize isAudioPlaying=_isAudioPlaying;

@synthesize playIndex;

@synthesize localplayer;

@synthesize sharingImage,sharingText,slComposerSheet;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.opaque = NO;
//        self.backgroundColor = [UIColor clearColor];  //设置为背景透明，可以在这里设置背景图片
//        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//        self.clearsContextBeforeDrawing = YES;
        
        
        
        
    
        
        
        
        
        
        //[self.view addSubview:scrollView];
        //[self.view addSubview:toolBar];
        
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height-kNewsToolBarHeight, self.frame.size.width, kNewsToolBarHeight);
        
        
//       self.opaque = YES;
//        self.backgroundColor=[UIColor colorWithHexString:@"0C0C0C"];
//        self.tintColor=[UIColor colorWithHexString:@"0C0C0C"];
////        self.barStyle=UIBarStyleBlack;
//        self.alpha=1;
      
        if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [self setBackgroundImage:[ [UIImage imageNamed:@"floatbg_03.png"] resizedImageToFitInSize:self.bounds.size scaleIfSmaller:NO] forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
        }
        
        NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:4];
        
        //设置添加按钮的数量
        
        // UIBarButtonItem *flexibleSpaceItem;
        // flexibleSpaceItem =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
        // [buttons addObject:flexibleSpaceItem];
        
        //UIBarButtonSystemItemFixedSpace和UIBarButtonSystemItemFlexibleSpace都是系统提供的用于占位的按钮样式。
        //使按钮与按钮之间有间距
        
        UIBarButtonItem *Item;
        
        //添加第1个图标按钮
        recordButton =     [UIButton buttonWithType:UIButtonTypeCustom];
        [recordButton setImage:[UIImage imageNamed:@"musicbar-_05.png"] forState:UIControlStateNormal];
        recordButton.frame=CGRectMake(0, kProgressViewHeight, 57.5, 58.5);
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
        audioButton =     [[AudioButton alloc] initWithFrame:CGRectMake(50, kProgressViewHeight, 56.5, 58.5)];
        [audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:audioButton
                ];
        [buttons addObject:Item];
        
        //添加第3个图标按钮
        audioLabel =     [[UILabel alloc] initWithFrame:CGRectMake(100, kProgressViewHeight, 100, 50)];
        
        audioLabel.backgroundColor = [UIColor clearColor];
        audioLabel.textColor=[UIColor colorWithHexString:@"756860"];
        
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:audioLabel
                ];
        [buttons addObject:Item];
        
        //添加第4个图标按钮
        shareButton=  [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"musicbar-_11.png"] forState:UIControlStateNormal];
        
        shareButton.frame=CGRectMake(200, kProgressViewHeight, 60, 58.5);
        
        [shareButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        Item = [[UIBarButtonItem alloc]
                initWithCustomView:shareButton
                ];
        [buttons addObject:Item];
        
        // flexibleSpaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL]autorelease];
        //[buttons addObject:flexibleSpaceItem];
        
        
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
        
        
        //默认顺序播放
        _isAllPlay=YES;
    }
    return self;
}
- (void)viewDidUnload
{
    
    recorder = nil;
    localplayer = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // [fileManager removeItemAtPath:recordedFile.path error:nil];
    [fileManager removeItemAtURL:recordedFile error:nil];
    recordedFile = nil;
    //[super viewDidUnload];
}

-(void)dealloc{
    
    [news release];
    
    [parentViewController release];
   
    [_audioPlayer release];
    [audioButton release];
    
    
    [audioLabel release];
  
    [recordButton release];
    [shareButton release];
    
    [progressView release];
    
    [localplayer release];
    
    [sharingText release];
    [sharingImage release];
    [slComposerSheet release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)audioStop{
    if (self._audioPlayer) {

        [self._audioPlayer pauseAudio];
    }
    if (self.localplayer) {
        [self.localplayer stop];
//        [localplayer release];
//        localplayer =nil;
    }

}
- (void)audioPlay:(NSURL *)voiceurl andIndex:(int)indexl andIsLocalFile:(BOOL)isLocal andIsNew:(BOOL)newPlay{
    
    
    _isAudioPlaying=!isLocal;
    
    if (isLocal==YES) {
        
        
        if (localplayer == nil) {
            localplayer = [[LocalAudioPlay alloc] init];
            //if (localplayer.player) {
                
                localplayer.delegate=self;
            //}
            
        }
        
        if ([localplayer.button isEqual:audioButton]&&newPlay==NO) {
            
            [localplayer play];
        } else {
            
            [localplayer stop];
            
            localplayer.button = audioButton;
            localplayer.progressView =  self.progressView;
            localplayer.audioLabel=audioLabel;
            localplayer.url = voiceurl;
            [localplayer play];
            
        }
        
       
        
        
        
        
    }else{
        
        
        
        
        
        
        
        
        if (_audioPlayer == nil) {
            _audioPlayer = [[AudioPlayer alloc] init];
        }
        
        if ([_audioPlayer.button isEqual:audioButton]&&newPlay==NO) {
           
            [_audioPlayer play];
        } else {
            
            [_audioPlayer stop];
            
            _audioPlayer.button = audioButton;
            _audioPlayer.progressView =  self.progressView;
            _audioPlayer.audioLabel=audioLabel;
             _audioPlayer.url = voiceurl;
             [_audioPlayer play];
            
        }
                       
         
        
        
       
        
        
    }
    
    
    
    
    
}

- (void)playAudio:(AudioButton *)button
{
    // NSInteger index = button.tag;
    // NSDictionary *item = [itemArray objectAtIndex:index];
    
    //默认顺序播放
    
    if (self._audioPlayer==nil&&self.localplayer==nil) {
        
                
        playIndex=0;
        _isAllPlay=YES;
        if (news.contentAry&&news.contentAry.count>0) {
            Voice* content= [news.contentAry objectAtIndex:0];
            if(content){
                
                NSURL* url=  [DataManager isDownloadFile:content andNew:news];
                
                [self changeVoiceLabelColor:content];
                
                if (url) {//本地播放
                    
                    
                    [self audioPlay:url andIndex:playIndex andIsLocalFile:YES andIsNew:YES];
                    
                    
                    
                    
                    
                }else{
                    //设置循环播放
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(playbackStateFinish:)
                                                                 name:StatusFinishNotificationForAudio
                                                               object:self._audioPlayer];
                    
                    
                    
                    [self audioPlay:[NSURL URLWithString:content.voiceUrl] andIndex:playIndex andIsLocalFile:NO andIsNew:YES];
                    
                }
            }
        }
        
        
        
    }else{
        
        
        
        
        if (_isAudioPlaying==YES) {
            if ([_audioPlayer.button isEqual:button]) {
                
                [_audioPlayer play];
            }
        }else{
            if ([localplayer.button isEqual:button]) {
                
                [localplayer play];
            }
        }
        
        
    }
    
    
  
    
    
    
    
    
    
}


//-(NSString *)getPathForCacheResource:(NSString*) relativePath{
//    static NSString* documentsPath = nil;
//    if (nil == documentsPath) {
//        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        documentsPath = [dirs[0] retain];
//    }
//    //return documentsPath;//[documentsPath stringByAppendingPathComponent:relativePath];
////    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    return [paths  objectAtIndex:0];
//    return DOCUMENTS_FOLDER;
//}

- (void)recordingAction:(id)sender
{
    
    //recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    //获得系统时间
   
    //If the app is not recording, we want to start recording, disable the play button, and make the record button say "STOP"
    if(!self.isRecording)
    {
        
        NSDate *  senddate=[NSDate date];
        int time=[senddate timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d-%d.caf",self.news._id,time];
        // NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        recordedFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER,fileName]];
        
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        //[self.playButton setEnabled:NO];
        //[self.playButton.titleLabel setAlpha:0.5];
        [recorder release];
        recorder = nil;
        
        
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        if(err){
            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        [audioSession setActive:YES error:&err];
        err = nil;
        if(err){
            NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
       NSMutableDictionary * recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        

        
        
        
        
        
        
        NSError *error = nil;
        
        
        
        
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
        if ([recorder prepareToRecord] == YES){
            [recorder record];
        }else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        
    }
    //If the app is recording, we want to stop recording, enable the play button, and make the record button say "REC"
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        //[self.playButton setEnabled:YES];
        //[self.playButton.titleLabel setAlpha:1];
        [recorder stop];
        
        
//        NSError *err = nil;
//        NSData *audioData = [NSData dataWithContentsOfURL:recordedFile options: 0 error:&err];
//        if(!audioData)
//            NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        recorder = nil;
        
        
        //保存
        
        [DataManager insertRecord:news andFilePath:recordedFile];
        
//        NSError *playerError;
//        
//        localplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
//        
//        if (player == nil)
//        {
//            NSLog(@"ERror creating player: %@", [playerError description]);
//        }
//        player.delegate = self;
    }
}
- (void)popAction:(id)sender
{
    UIButton *button =sender;
    
    PopoverView*   pv = [PopoverView showPopoverAtPoint:CGPointMake(button.bounds.size.width/2,0)
                                                 inView:button
                                        withStringArray:[NSArray arrayWithObjects:@"  收藏  ", @"  下载  ", @"  分享  ", nil]
                                               delegate:self]; // Show the string array defined at top of this file
    [pv retain];
    
    
    
}
- (void)saveAction:(id)sender
{
    NSString * json =  [DataManager getNewsForJson:news];
    if (json) {
        Boolean isInsert =    [DataManager insertOrRemoveNews:kSaveType andID:news._id andString:json];
        
        if (isInsert) {
            //保存
            
            [Config ToastNotification:@"收藏成功" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
        }else{
            //取消保存
            [Config ToastNotification:@"已取消收藏" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
        }
    }else{
        //无法保存
        [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
    }
    
    
}

- (void)downloadAction:(id)sender
{
    
   
    [Config Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    if (![Config Instance].isNetworkRunning&&[Config getUserSettingFor3gDownload]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您现在非wifi环境，是否继续下载？"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"下载",nil];
        [sheet showInView:self.parentViewController.view withCompletionHandler:^(NSInteger buttonIndex) {
            NSLog(@"action:%d",buttonIndex);
            
            if (buttonIndex==1) {
                return ;
            }else{
                
                NSString * json =  [DataManager getNewsForJson:news];
                if (json) {
                    Boolean isDownload =   [DataManager isDownload:news._id];
                    
                    
                    if (isDownload) {
                        
                        [Config ToastNotification:@"已下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                        
                    }else{
                        //保存
                        
                        [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
                        
                        //下载
                        if (news.contentAry&&news.contentAry.count>0) {
                            [Config ToastNotification:@"开始下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                            
                            [[DownloadsManager Instance] beginRequest:news isBeginDown:YES];
                            
                        }
                        
                    }
                }else{
                    //无法保存
                    [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                }
                
            }
            
            
            
        }];
          [ [NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    }else{
        NSString * json =  [DataManager getNewsForJson:news];
        if (json) {
            Boolean isDownload =   [DataManager isDownload:news._id];
            
            
            if (isDownload) {
                
                [Config ToastNotification:@"已下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                
            }else{
                //保存
                
                [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
                
                //下载
                if (news.contentAry&&news.contentAry.count>0) {
                    [Config ToastNotification:@"开始下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                    
                    [[DownloadsManager Instance] beginRequest:news isBeginDown:YES];
                    
                }
                
            }
        }else{
            //无法保存
            [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
        }
        
    }
    

    
}


- (void)shareAction:(id)sender
{
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
        [currentComposeViewController setInitialText:[NSString stringWithFormat:@"我正在通过%@学习%@，快来一起吧 ",AppTitle,AppLang]];
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
//- (IBAction)shareToWeibo:(id)sender {
//    
//}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex==1)//确定按钮
//    {
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        NSError *error;
//
//        NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:self.fileInfo.fileName];
//        NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:self.fileInfo.fileName]stringByAppendingString:@".temp"];
//        if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
//        {
//            [fileManager removeItemAtPath:targetPath error:&error];
//            if(!error)
//            {
//                NSLog(@"删除文件出错:%@",error);
//            }
//            for(FileModel *file in appDelegate.finishedlist)
//            {
//                if([file.fileName isEqualToString:self.fileInfo.fileName])
//                {
//                    [[DownloadManager Instance].finishedlist removeObject:file];
//                    break;
//                }
//            }
//        }
//        //存在于临时文件夹里
//        if([CommonHelper isExistFile:tempPath])
//        {
//            [fileManager removeItemAtPath:tempPath error:&error];
//            if(!error)
//            {
//                NSLog(@"删除临时文件出错:%@",error);
//            }
//        }
//
//        for(ASIHTTPRequest *request in appDelegate.downinglist)
//        {
//            FileModel *fileModel=[request.userInfo objectForKey:@"File"];
//            if([fileModel.fileName isEqualToString:self.fileInfo.fileName])
//            {
//                [appDelegate.downinglist removeObject:request];
//                break;
//            }
//        }
//        self.fileInfo.isDownloading=YES;
//        self.fileInfo.fileReceivedSize=[CommonHelper getFileSizeString:@"0"];
//        [appDelegate beginRequest:self.fileInfo isBeginDown:YES];
//    }
//}




-(void) changeVoiceLabelColor:(Voice*)content{
    //设置字体颜色
    if (self.parentViewController&&[self.parentViewController isKindOfClass:[NewsDetailViewController class]]) {
        NewsDetailViewController *pview = (NewsDetailViewController *) self.parentViewController;
        
        
        NSArray *array = [pview.scrollView subviews];
        
        
        for(id label in array){
            if([label isKindOfClass:[VoiceUILabel class]]){
                VoiceUILabel *le =  label;
                if (le.tag==content.id) {
                    le.textColor=[UIColor redColor];
                }else{
                    le.textColor=[UIColor blackColor];
                }
                
            }
        }
        
        
        
        
    }
}




#pragma AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //[self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    NSNotification *notification = [NSNotification notificationWithName:LOCALASStatusChangedNotification object:self.localplayer.player];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    //完成一首曲子置状态
    //顺序播放
   
    if (flag) {
        if (_isAllPlay) {
            playIndex++;
            if (playIndex<news.contentAry.count) {
                Voice* content= [news.contentAry objectAtIndex:playIndex];
                if(content){
                    
                    NSURL* url=  [DataManager isDownloadFile:content andNew:news];
                    
                    if (url) {//本地播放
                        
                        //设置字体颜色
                        [self changeVoiceLabelColor:content];
                        
                        [self audioPlay:url andIndex:playIndex andIsLocalFile:YES andIsNew:YES];
//                        localplayer.url = url;
//                        [localplayer play];
                    }
//                    else{
//                        _audioPlayer.url = [NSURL URLWithString:content.voiceUrl];
//                        [_audioPlayer play];
//                    }
                }
                
                
            }
            
            
            
        }
        
        
    }
    
}




/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateFinish:(NSNotification *)notification
{
	if (_isAllPlay) {
        playIndex++;
        if (playIndex<news.contentAry.count) {
            Voice* content= [news.contentAry objectAtIndex:playIndex];
            if(content){
                //设置字体颜色
          [self changeVoiceLabelColor:content];
                
                  [self audioPlay:[NSURL URLWithString:content.voiceUrl] andIndex:playIndex andIsLocalFile:NO andIsNew:YES];
          
//                                        _audioPlayer.url = [NSURL URLWithString:content.voiceUrl];
//                                        [_audioPlayer play];
                
            }
            
            
        }
        
        
        
    }
}


#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
    switch (index) {
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


@end
