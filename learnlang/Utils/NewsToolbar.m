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
#define kProgressViewHeight 10

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
        progressView.gradientColors = @[[UIColor colorWithRed:0.0f green:0.0f blue:0.3f alpha:1.00f],
                                        [UIColor colorWithRed:0.3f green:0.3f blue:0.6f alpha:1.00f],
                                        [UIColor colorWithRed:0.6f green:0.6f blue:0.9f alpha:1.00f]];
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
        [self._audioPlayer stop];
    }
    if (self.localplayer) {
        [self.localplayer stop];
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
        Voice* content= [news.contentAry objectAtIndex:0];
        if(content){
            
            NSURL* url=  [DataManager isDownloadFile:content andNew:news];
            
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
        
        
    }else{
        
        
        
        
        if (_isAudioPlaying==YES) {
            if ([_audioPlayer.button isEqual:audioButton]) {
                
                [_audioPlayer play];
            }
        }else{
            if ([localplayer.button isEqual:audioButton]) {
                
                [localplayer play];
            }
        }
        
        
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
        localplayer = nil;
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
    
    PopoverView*   pv = [PopoverView showPopoverAtPoint:button.center
                                                 inView:button
                                        withStringArray:[NSArray arrayWithObjects:@"收藏", @"下载", nil]
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
    NSString * json =  [DataManager getNewsForJson:news];
    if (json) {
        Boolean isDownload =   [DataManager isDownload:news._id];
        
        
        if (FALSE) {
            
            [Config ToastNotification:@"已下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
            
            //未保存
            //            [Config ToastNotification:@"下载" andView:self.view andLoading:NO andIsBottom:NO];
            //            [[DownloadsManager Instance] loadTempfiles];
            //             [[DownloadsManager Instance] loadFinishedfiles];
            //            NSMutableDictionary*finishedList=[DownloadsManager Instance].finishedlist;
            //            NSMutableDictionary*downingList=[DownloadsManager Instance].downinglist;
            //
            //
            //
            //            NSFileManager *fileManager=[NSFileManager defaultManager];
            //            NSError *error;
            //            if(FALSE)//正在下载的表格
            //            {
            //                ASIHTTPRequest *theRequest=[downingList objectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
            //                if([theRequest isExecuting])
            //                {
            //                    [theRequest cancel];
            //                }
            //                FileModel *fileInfo=(FileModel*)[theRequest.userInfo objectForKey:@"File"];
            //                NSString *path=[[Config getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
            //                NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
            //                NSString *name=[fileInfo.fileName substringToIndex:index];
            //                NSString *configPath=[[Config getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
            //                [fileManager removeItemAtPath:path error:&error];
            //                [fileManager removeItemAtPath:configPath error:&error];
            //                if(!error)
            //                {
            //                    NSLog(@"%@",[error description]);
            //                }
            //                [downingList removeObjectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
            //
            //            }
            //            else//已经完成下载的表格
            //            {
            //                FileModel *selectFile=[finishedList objectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
            //                NSString *path=[[Config getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",selectFile.fileName]];
            //
            //                [fileManager removeItemAtPath:path error:&error];
            //                if(!error)
            //                {
            //                    NSLog(@"%@",[error description]);
            //                }
            //                [finishedList removeObjectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
            //
            //            }
            //
            
            
            
            
            
        }else{
            //保存
            
             [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
            
            
            
            
            
            //下载
            if (news.contentAry&&news.contentAry.count>0) {
                [Config ToastNotification:@"开始下载" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
                
                
                
                //选择点击的行
                //    UITableView *tableView=(UITableView *)[sender superview];
                //    NSLog(@"%d",[fileInfo.fileID integerValue]);
                //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[fileInfo.fileID integerValue] inSection:0];
                //    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                
                
                
                [[DownloadsManager Instance] beginRequest:news isBeginDown:YES];
                
                
                
                
                
                
            }
            
            
            
            
            
        }
    }else{
        //无法保存
        [Config ToastNotification:@"操作失败" andView:self.parentViewController.view andLoading:NO andIsBottom:NO];
    }
    
    
}

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
