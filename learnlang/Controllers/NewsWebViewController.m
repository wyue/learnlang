//
//  NewsWebViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsWebViewController.h"
#import "UIImageView+AFNetworking.h"
#import "News.h"
#import "Voice.h"
#import "FileModel.h"
#import "VoiceUILabel.h"
#import "AudioButton.h"
#import "DownloadsManager.h"

@interface NewsWebViewController ()

@end

@implementation NewsWebViewController

@synthesize news;
@synthesize toolBar;
@synthesize webView;



@synthesize textSize;









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

    
    textSize= [Config getUserSettingForTextSize];
    if (textSize==0) {
        textSize=[[TextSizeDictionary objectForKey:TextSizeForMiddle]intValue];
    }
    
    
    //初始化控件
    // titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UIImage *lImg = [UIImage imageNamed:@"myaudio_02.png"];
    UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lBtn.frame = CGRectMake(0, 0, 36.5, 45);
    [lBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:lImg forState:UIControlStateNormal];
    lBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *lBarBtn = [[UIBarButtonItem alloc] initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = lBarBtn;
    
    
    [lBtn release];
    [lBarBtn release];
    
    //backButton.tintColor=[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
    
 
    
    
    
    //初始化数据
    if (news) {
        //增加点击数
        [DataManager postClickToServer:news];
        
        
        if (!_tempArrayList)
        {
            _tempArrayList = [[NSMutableArray alloc] init];
        }
        
        if (!_arrayItemList)
        {
            _arrayItemList = [[NSMutableArray alloc] init];
        }
        NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"lrc"];
        NSError *error=nil;
        NSString * textContent = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:&error];
        //NSLog(@"textContent = %@",[error debugDescription]);
        NSArray * tempArray=[textContent componentsSeparatedByString:@"\n"];
        //NSLog(@"tempArray = %@",tempArray);
        
        for (NSString * str in tempArray)
        {
            if (!str || str.length <= 0)
                continue;
            [self parseLrcLine:str];
            [self parseTempArray:_tempArrayList];
        }
        
        [self sortAllItem:_arrayItemList];
        
        // NSLog(@"_tempArray = %@",_tempArrayList);
        
        
        NSMutableString * str = [[NSMutableString alloc] init];
        for (int i=0; i<_arrayItemList.count; i++) {
            NSDictionary *dic = [_arrayItemList objectAtIndex:i];
            NSString *key = @"key is nil";
            NSString *value = @"value is nil";
            if (dic)
            {
                key = [dic.allKeys objectAtIndex:0];
                value = [dic objectForKey:key];
                [str appendFormat:@"<font id=%d onclick='noticeAudioPlay(this)' name='voice_span'  size=6>%@</font>",i,value];
            }
        }
        
       
        
        
        CGRect rect_view =[self.view bounds];
        
        self.webView = [[UIWebView alloc]initWithFrame:rect_view];
        webView.backgroundColor = [UIColor clearColor];
        webView.scalesPageToFit =YES;
        webView.delegate =self;
        //        NSString * path = [[NSBundle mainBundle] pathForResource:@"MyGermanTest1" ofType:@"html"];
        //
        //        NSURL *url = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
        //
        //
        //        NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
        //        [_webView loadRequest:request];
        NSString * path = [[NSBundle mainBundle] bundlePath];
        NSURL * baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlFile = [[NSBundle mainBundle] pathForResource:@"news_detail" ofType:@"html"];
        NSString * htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:(NSUTF8StringEncoding) error:nil];
        
         htmlString=[NSString stringWithFormat:htmlString ,str];
        
        
        [webView loadHTMLString:htmlString baseURL:baseURL];
        [self.view addSubview:webView];
        
       
       
        
        
        toolBar = [[CustomToolbar alloc]initWithArrayItem:_arrayItemList];
        toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight);
        toolBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        toolBar.news=news;
        toolBar.parentViewController=self;
        toolBar.arrayItemList=_arrayItemList;
        [self.view addSubview:toolBar];
        
        
        
        
        
//        NSURL*voiceurl= [DataManager isDownloadFile:news];
//        if (voiceurl) {
//            //本地
//            
//            [toolBar setupAVPlayerForURL:voiceurl];
//        }else{
//            //网络
//            [toolBar setupAVPlayerForURL:[NSURL URLWithString:news.voiceUrl]];
//            
//        }
      
        
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    CGRect rect_view =[self.view bounds];
    toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight);
    
    
    
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animatedd{
    
    // CGRect rect_view =[self.view bounds];
    // toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kToolBarHeight, rect_view.size.width, kToolBarHeight);
    [toolBar pause:nil];
   
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
    [webView release];
    
    [_tempArrayList release];
    [_arrayItemList release];

    
    [super dealloc];
}



- (void)popViewController
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//事件方法
//- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
//{
//    //事件处理。
//    VoiceUILabel *l =    (VoiceUILabel*) gestureRecognizer.view;
//    if( l){
//        [self.toolBar setIsAllPlay:NO];
//        NSURL*voiceurl= [DataManager isDownloadFile:l.voice andNew:news];
//        if (voiceurl) {
//            //本地
//            [self.toolBar audioPlay:voiceurl andIndex:l.indexl andIsLocalFile:YES  andIsNew:YES];
//        }else{
//            //网络
//            [self.toolBar audioPlay:[NSURL URLWithString:l.voice.voiceUrl] andIndex:l.indexl andIsLocalFile:NO andIsNew:YES];
//        }
//        
//        //设置字体颜色
//        NSArray *array = [scrollView subviews];
//        
//        
//        for(id label in array){
//            if([label isKindOfClass:[VoiceUILabel class]]){
//                VoiceUILabel *le =  label;
//                le.textColor=[UIColor blackColor];
//            }
//        }
//        
//        l.textColor=[UIColor redColor];
//        
//    }
//    
//    
//    
//}


// 解析每一行，将每一行的[time]和内容分开
-(NSString*) parseLrcLine:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        return nil;
    NSRange range = [sourceLineText rangeOfString:@"]"];
    if (range.length > 0)
    {
        NSString * time = [sourceLineText substringToIndex:range.location + 1];
       // NSLog(@"time = %@",time);
        NSString * other = [sourceLineText substringFromIndex:range.location + 1];
       // NSLog(@"other = %@",other);
        if (time && time.length > 0)
            [_tempArrayList addObject:time];
        if (other)
            [self parseLrcLine:other];
    }else
    {
        [_tempArrayList addObject:sourceLineText];
    }
    return nil;
    
}

-(BOOL) sortForPlayData:(NSString*) firstData WithSecondData:(NSString *)secondData
{
    NSString * firstMinute = [firstData substringWithRange:NSMakeRange(1, 2)];
    int i_firstMinute = firstMinute.intValue;
    
    NSString * secondMinute = [secondData substringWithRange:NSMakeRange(1, 2)];
    int i_secondMinute = secondMinute.intValue;
    
    if (i_firstMinute > i_secondMinute)
    {
        return YES;
    }else if (i_firstMinute == i_secondMinute)
    {
        NSString * firstS = [firstData substringWithRange:NSMakeRange(4, 5)];
        float f_FirstS = firstS.floatValue;
        
        NSString * secondS = [secondData substringWithRange:NSMakeRange(4, 5)];
        float f_SecondS = secondS.floatValue;
        
        if (f_FirstS > f_SecondS)
            return YES;
        else
            return NO;
    }
    else
    {
        return NO;
    }
    
}

-(void) parseTempArray:(NSMutableArray *) tempArray
{
    if (!tempArray || tempArray.count <= 0)
        return;
    NSString *value = [tempArray lastObject];
    if (!value || ([value rangeOfString:@"["].length > 0 && [value rangeOfString:@"]"].length > 0))
    {
        [_tempArrayList removeAllObjects];
        return;
    }
    
    for (int i = 0; i < tempArray.count - 1; i++)
    {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString * key = [tempArray objectAtIndex:(NSUInteger)i];
        NSString *secondKey = [self timeToSecond:key]; // 转换成以秒为单位的时间计数器
        [dic setObject:value forKey:secondKey];
        [_arrayItemList addObject:dic];
    }
    [_tempArrayList removeAllObjects];
}

// 以时间顺序进行排序
-(void)sortAllItem:(NSMutableArray *)array {
    if (!array || array.count <= 0)
        return;
    for (int i = 0; i < array.count - 1; i++)
    {
        for (int j = i + 1; j < array.count; j++)
        {
            id firstDic = [array objectAtIndex:(NSUInteger )i];
            id secondDic = [array objectAtIndex:(NSUInteger)j];
            if (firstDic && [firstDic isKindOfClass:[NSDictionary class]] && secondDic && [secondDic isKindOfClass:[NSDictionary class]])
            {
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                BOOL b = firstTime.floatValue > secondTime.floatValue;
                if (b) // 第一句时间大于第二句，就要进行交换
                {
                    [array replaceObjectAtIndex:(NSUInteger )i withObject:secondDic];
                    [array replaceObjectAtIndex:(NSUInteger )j withObject:firstDic];
                }
            }
        }
    }
}

-(NSString *)timeToSecond:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0)
        return nil;
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0)
        return nil;
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(4, 5)];
    float finishSecond = minutes.floatValue * 60 + second.floatValue;
    return [NSString stringWithFormat:@"%f",finishSecond];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    if (url&&[[url scheme] isEqualToString:@"voice"]) {
        
        NSString *indexStr = [[url absoluteString] substringFromIndex:6 ];
        if (indexStr) {
            
            
            if (toolBar.URL==nil) {
                NSURL*voiceurl= [DataManager isDownloadFile:news];
                if (voiceurl) {
                    //本地
                    
                    [toolBar setupAVPlayerForURL:voiceurl];
                    
                }else{
                    //网络
                    [toolBar setupAVPlayerForURL:[NSURL URLWithString:news.voiceUrl]];
                    
                }
            }
            
            [toolBar playToTime:indexStr.intValue];
            [toolBar play:nil];
            
            
        }
        
        
//        UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"test" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//        [alertView show];
        return NO;
    }
    
    return YES;
}




@end

