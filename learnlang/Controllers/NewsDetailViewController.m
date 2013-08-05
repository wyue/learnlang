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
#import "DownloadManager.h"


#define kProgressViewHeight 10
#define kSaveType 0
#define kDownloadType 1


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
@synthesize isChinese = _isChinese;

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
    
    [shareButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
            
            l.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [l addGestureRecognizer:singleTap];
            [singleTap release];
            
            
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
- (void)popAction:(id)sender
{
    UIButton *button =sender;
    
     PopoverView*   pv = [PopoverView showPopoverAtPoint:button.center
                                      inView:button
                             withStringArray:[NSArray arrayWithObjects:@"YES", @"NO", nil]
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
            
            [Config ToastNotification:@"收藏成功" andView:self.view andLoading:NO andIsBottom:NO];
        }else{
            //取消保存
            [Config ToastNotification:@"已取消收藏" andView:self.view andLoading:NO andIsBottom:NO];
        }
    }else{
        //无法保存
        [Config ToastNotification:@"操作失败" andView:self.view andLoading:NO andIsBottom:NO];
    }
    
    
}

- (void)downloadAction:(id)sender
{
    NSString * json =  [DataManager getNewsForJson:news];
    if (json) {
        Boolean isInsert =    [DataManager insertOrRemoveNews:kDownloadType andID:news._id andString:json];
        
        if (isInsert) {
            //保存
            
            news.voiceUrl =@"http://learn.china.cn/article/mp3/8/p_60.mp3";
            
            
          //下载
            if (news.voiceUrl&&![news.voiceUrl isEqualToString:@""]) {
                [Config ToastNotification:@"开始下载" andView:self.view andLoading:NO andIsBottom:NO];
                FileModel *selectFileInfo=[[FileModel alloc]init];
                selectFileInfo.fileName=[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id];
                selectFileInfo.fileURL=news.voiceUrl;
                
                
                
                selectFileInfo.news = news;
                //选择点击的行
                //    UITableView *tableView=(UITableView *)[sender superview];
                //    NSLog(@"%d",[fileInfo.fileID integerValue]);
                //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[fileInfo.fileID integerValue] inSection:0];
                //    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                
                //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
                NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:selectFileInfo.fileName];
                NSString *tempPath=[[[Config getTempFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName]stringByAppendingString:@".temp"];
                if([Config isExistFile:targetPath])//已经下载过一次该音乐
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                    [alert release];
                    return;
                }
                //存在于临时文件夹里
                if([Config isExistFile:tempPath])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                    [alert release];
                    return;
                }
                selectFileInfo.isDownloading=YES;
                //若不存在文件和临时文件，则是新的下载
                
                [[DownloadManager Instance] beginRequest:selectFileInfo isBeginDown:YES];
                
                
                
                
                
                
            }
            
           
            
            
            
            
            
        }else{
            //取消保存
            [Config ToastNotification:@"停止下载" andView:self.view andLoading:NO andIsBottom:NO];
            [[DownloadManager Instance] loadTempfiles];
             [[DownloadManager Instance] loadFinishedfiles];
            NSMutableDictionary*finishedList=[DownloadManager Instance].finishedlist;
            NSMutableDictionary*downingList=[DownloadManager Instance].downinglist;
            
            
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            NSError *error;
            if(TRUE)//正在下载的表格
            {
                ASIHTTPRequest *theRequest=[downingList objectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
                if([theRequest isExecuting])
                {
                    [theRequest cancel];
                }
                FileModel *fileInfo=(FileModel*)[theRequest.userInfo objectForKey:@"File"];
                NSString *path=[[Config getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
                NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
                NSString *name=[fileInfo.fileName substringToIndex:index];
                NSString *configPath=[[Config getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
                [fileManager removeItemAtPath:path error:&error];
                [fileManager removeItemAtPath:configPath error:&error];
                if(!error)
                {
                    NSLog(@"%@",[error description]);
                }
                [downingList removeObjectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
                
            }
            else//已经完成下载的表格
            {
                FileModel *selectFile=[finishedList objectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
                NSString *path=[[Config getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",selectFile.fileName]];
                
                [fileManager removeItemAtPath:path error:&error];
                if(!error)
                {
                    NSLog(@"%@",[error description]);
                }
                [finishedList removeObjectForKey:[NSString stringWithFormat:@"%@%d",kDownloadFileName,news._id]];
                
            }

         
            
            
            
            
        }
    }else{
        //无法保存
        [Config ToastNotification:@"操作失败" andView:self.view andLoading:NO andIsBottom:NO];
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
