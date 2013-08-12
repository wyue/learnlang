//
//  DownloadsManager.m
//  learnlang
//
//  Created by mooncake on 13-8-5.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "DownloadsManager.h"
#import "ASINetworkQueue.h"

#import "Voice.h"

@implementation DownloadsManager

@synthesize downinglist=_downinglist;


@synthesize finishedlist=_finishedList;
@synthesize downloadDelegate=_downloadDelegate;

- (void)dealloc
{
    
    [_finishedList release];
    [_downloadDelegate release];
    [_downinglist release];
    
    [super dealloc];
}




static DownloadsManager * managerinstance = nil;
+(DownloadsManager *) Instance
{
    @synchronized(self)
    {
        if(nil == managerinstance)
        {
            [[self alloc]init];
        }
    }
    return managerinstance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(managerinstance == nil)
        {
            managerinstance = [super allocWithZone:zone];
            return managerinstance;
        }
    }
    return nil;
}

//播放声音
-(void)playButtonSound
{
    //    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    //    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"btnEffect.wav"];
    //    NSError *error;
    //    if(self.buttonSound==nil)
    //    {
    //        self.buttonSound=[[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
    //        if(!error)
    //        {
    //            NSLog(@"%@",[error description]);
    //        }
    //    }
    //    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    //    {
    //        if(!self.isFistLoadSound)
    //        {
    //            self.buttonSound.volume=1.0f;
    //        }
    //    }
    //    else
    //    {
    //        self.buttonSound.volume=0.0f;
    //    }
    //    [self.buttonSound play];
}
//播放下载完毕声音呢
-(void)playDownloadSound
{
    //    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    //    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"download-complete.wav"];
    //    NSError *error;
    //    if(self.downloadCompleteSound==nil)
    //    {
    //        self.downloadCompleteSound=[[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
    //        if(!error)
    //        {
    //            NSLog(@"%@",[error description]);
    //        }
    //    }
    //    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    //    {
    //        if(!self.isFistLoadSound)
    //        {
    //            self.downloadCompleteSound.volume=1.0f;
    //        }
    //    }
    //    else
    //    {
    //        self.downloadCompleteSound.volume=0.0f;
    //    }
    //    [self.downloadCompleteSound play];
}


- (Boolean)isReDownload:(News*)news
{
    
    if (self.downinglist&&[self.downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]]) {
        return FALSE;
    }else{
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:[Config getTempFolderPath]])
        {
            [fileManager createDirectoryAtPath:[Config getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        for (int i=0; i< news.contentAry.count; i++) {
            
            Voice* voice =  [ news.contentAry objectAtIndex:i];
            if (voice) {
                FileModel *fileInfo=[[FileModel alloc]init];
                
                NSString * fileExtension = [voice.voiceUrl pathExtension];
                
                
                fileInfo.fileName=[NSString stringWithFormat:@"%@%d_%d.%@",kDownloadFileName,news._id,voice.id,fileExtension];
                fileInfo.fileExtension=fileExtension;
                fileInfo.fileURL=voice.voiceUrl;
                
                
                
                
                
                //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
                NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:fileInfo.fileName];
                NSString *tempPath=[[[Config getTempFolderPath]stringByAppendingPathComponent:fileInfo.fileName]stringByAppendingString:@".temp"];
                if(![Config isExistFile:targetPath]&&![Config isExistFile:tempPath])//已经下载过一次该音乐
                {
                    return TRUE;
                }
              
            }
            
            
        }
        
        
        return FALSE;
    }
        
    
    
}

-(void)beginRequest:(News *)news isBeginDown:(BOOL)isBeginDown
{
    if (self.downinglist==nil) {
         self.downinglist=[[[NSMutableDictionary alloc] init] autorelease];
    }
    
    if (self.finishedlist==nil) {
    self.finishedlist=[[[NSMutableDictionary alloc] init] autorelease];
    }
    //if (!networkQueue) {
	ASINetworkQueue	*networkQueue = [ASINetworkQueue queue];
	//}
	
	[networkQueue reset];
	//[networkQueue setDownloadProgressDelegate:_downloadProgress];
	[networkQueue setRequestDidFinishSelector:@selector(downLoadComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(downLoadFailed:)];
    [networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];	
	//[networkQueue setShowAccurateProgress:[accurateProgress isOn]];
	[networkQueue setDelegate:self];
	
    NSFileManager *fileManager=[NSFileManager defaultManager];
   
    if(![fileManager fileExistsAtPath:[Config getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[Config getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
        for (int i=0; i< news.contentAry.count; i++) {
            
          Voice* voice =  [ news.contentAry objectAtIndex:i];
            if (voice) {
                FileModel *fileInfo=[[FileModel alloc]init];
                
                NSString * fileExtension = [voice.voiceUrl pathExtension];
                
                
                fileInfo.fileName=[NSString stringWithFormat:@"%@%d_%d.%@",kDownloadFileName,news._id,voice.id,fileExtension];
                fileInfo.fileExtension=fileExtension;
                fileInfo.fileURL=voice.voiceUrl;
                
                
                
                fileInfo.news = news;
                
                //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
                NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:fileInfo.fileName];
                NSString *tempPath=[[[Config getTempFolderPath]stringByAppendingPathComponent:fileInfo.fileName]stringByAppendingString:@".temp"];
                if([Config isExistFile:targetPath])//已经下载过一次该音乐
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                    [alert show];
                    [alert release];
                    continue;
                }
                //存在于临时文件夹里
                if([Config isExistFile:tempPath])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                    [alert show];
                    [alert release];
                    continue;
                }
                fileInfo.isDownloading=YES;
                //若不存在文件和临时文件，则是新的下载
                
                
                
                
                ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
                request.delegate=self;
                [request setDownloadDestinationPath:[[Config getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
                [request setTemporaryFileDownloadPath:[[Config getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
                //            [request setDownloadProgressDelegate:self];
                //            //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
                [request setAllowResumeForFileDownloads:YES];//支持断点续传
                if(isBeginDown)
                {
                    fileInfo.isDownloading=YES;
                }
                else
                {
                    fileInfo.isDownloading=NO;
                }
                [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
                [request setTimeOutSeconds:30.0f];
                
                [networkQueue addOperation:request];
            }
            
            
        }
    
	if (isBeginDown) {
    //[self saveNSUserDefaults];
	[networkQueue go];
    
    }
    
    
    
   
  
    [self.downinglist setObject:networkQueue forKey:[NSString stringWithFormat:@"%d",news._id]];
}




-(void)removeFile:(News *)news isDownloading:(BOOL)isDownload
{
  NSString* key=  [NSString stringWithFormat:@"%d",news._id];
    NSFileManager *fileManager=[NSFileManager defaultManager];
     NSError *error;
    
    if(![self isReDownload:news])//正在下载的表格
    {
        ASINetworkQueue *queue=[self.downinglist   objectForKey:key];
        if(queue )
        {
            [queue cancelAllOperations];
            [queue reset];
            [self.downinglist removeObjectForKey:key];
        }
       
       
    }
    else//已经完成下载的表格
    {
  
    }
  
	
    
    if(![fileManager fileExistsAtPath:[Config getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[Config getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    for (int i=0; i< news.contentAry.count; i++) {
        
        Voice* voice =  [ news.contentAry objectAtIndex:i];
        if (voice) {
            FileModel *fileInfo=[[FileModel alloc]init];
            
            NSString * fileExtension = [voice.voiceUrl pathExtension];
            
            
            fileInfo.fileName=[NSString stringWithFormat:@"%@%d_%d.%@",kDownloadFileName,news._id,voice.id,fileExtension];
            fileInfo.fileExtension=fileExtension;
            fileInfo.fileURL=voice.voiceUrl;
            
            
            
            fileInfo.news = news;
            
            //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
            NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:fileInfo.fileName];
            NSString *tempPath=[[[Config getTempFolderPath]stringByAppendingPathComponent:fileInfo.fileName]stringByAppendingString:@".temp"];
            if([Config isExistFile:targetPath])//已经下载过一次该音乐
            {
                [fileManager removeItemAtPath:targetPath error:&error];
                
            }
            //存在于临时文件夹里
            if([Config isExistFile:tempPath])
            {
               [fileManager removeItemAtPath:tempPath error:&error];
            }
            
        }
        
        
    }
    

    
}




-(void)cancelRequest:(ASIHTTPRequest *)request
{
    
}

-(void)loadTempfiles
{
    
    self.downinglist=[[[NSMutableDictionary alloc] init] autorelease];
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSError *error;
//    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[Config getTempFolderPath] error:&error];
//    if(!error)
//    {
//        NSLog(@"%@",[error description]);
//    }
//    for(NSString *file in filelist)
//    {
//        if([file rangeOfString:@".rtf"].location<=100)//以.rtf结尾的文件是下载文件的配置文件，存在文件名称，文件总大小，文件下载URL
//        {
//            NSInteger index=[file rangeOfString:@"."].location;
//            NSString *trueName=[file substringToIndex:index];
//            
//            //临时文件的配置文件的内容
//            NSString *msg=[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[Config getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",trueName]]] encoding:NSUTF8StringEncoding];
//            
//            //取得第一个逗号前的文件名
//            index=[msg rangeOfString:@","].location;
//            NSString *name=[msg substringToIndex:index];
//            msg=[msg substringFromIndex:index+1];
//            
//            //取得第一个逗号和第二个逗间的文件总大小
//            index=[msg rangeOfString:@","].location;
//            NSString *totalSize=[msg substringToIndex:index];
//            msg=[msg substringFromIndex:index+1];
//            
//            //取得第二个逗号后的所有内容，即文件下载的URL
//            NSString *url=msg;
//            
//            //按照获取的文件名获取临时文件的大小，即已下载的大小
//            NSData *fileData=[fileManager contentsAtPath:[[Config getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",name]]];
//            NSInteger receivedDataLength=[fileData length];
//            
//            //实例化新的文件对象，添加到下载的全局列表，但不开始下载
//            FileModel *tempFile=[[FileModel alloc] init];
//            tempFile.fileName=name;
//            tempFile.fileSize=totalSize;
//            tempFile.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
//            tempFile.fileURL=url;
//            tempFile.isDownloading=NO;
//            [self beginRequest:tempFile isBeginDown:NO];
//            
//            [ self.downinglist setObject:tempFile forKey:file];
//            
//            [msg release];
//            [tempFile release];
//            
//            
//            
//        }
//    }
//    
    
}

-(void)loadFinishedfiles
{
    self.finishedlist=[[[NSMutableDictionary alloc] init] autorelease];
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSError *error;
//    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[Config getTargetFloderPath] error:&error];
//    if(!error)
//    {
//        NSLog(@"%@",[error description]);
//    }
//    for(NSString *fileName in filelist)
//    {
//        if([fileName rangeOfString:@"."].location<100)//出去Temp文件夹
//        {
//            FileModel *finishedFile=[[FileModel alloc] init];
//            finishedFile.fileName=fileName;
//            
//            //根据文件名获取文件的大小
//            NSInteger length=[[fileManager contentsAtPath:[[Config getTargetFloderPath] stringByAppendingPathComponent:fileName]] length];
//            finishedFile.fileSize=[Config getFileSizeString:[NSString stringWithFormat:@"%d",length]];
//            
//            [self.finishedlist setObject:finishedFile forKey:fileName];
//            [finishedFile release];
//        }
//    }
}

//#pragma ASIHttpRequest回调委托
//
////出错了，如果是等待超时，则继续下载
//-(void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error=[request error];
//    NSLog(@"ASIHttpRequest出错了!%@",error);
//    [request release];
//}
//
//-(void)requestStarted:(ASIHTTPRequest *)request
//{
//    NSLog(@"开始了!");
//}
//
//-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
//{
//    NSLog(@"收到回复了！");
//    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
//    fileInfo.fileSize=[Config getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
//}
//
//////*********
////**注意：如果要要ASIHttpRequest自动断点续传，则不需要写上该方法，整个过程ASIHttpRequest会自动识别URL进行保存数据的
////如果设置了该方法，ASIHttpRequest则不会响应断点续传功能，需要自己手动写入接收到的数据，开始不明白原理，搞了很久才明白，如果本人理解不正确的话，请高人及时指点啊^_^QQ:1023217825
////***********
////-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
////{
////    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
////    [fileInfo.fileReceivedData appendData:data];
////    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",[fileInfo.fileReceivedData length]];
////    [fileInfo.fileReceivedData writeToFile:request.temporaryFileDownloadPath atomically:NO];
////    NSString *configPath=[[Config getTempFolderPath] stringByAppendingPathComponent:[fileInfo.fileName stringByAppendingString:@".rtf"]];
////    NSString *tmpConfigMsg=[NSString stringWithFormat:@"%@,%@,%@,%@",fileInfo.fileName,fileInfo.fileSize,fileInfo.fileReceivedSize,fileInfo.fileURL];
////    NSError *error;
////    [tmpConfigMsg writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
////    if(!error)
////    {
////        NSLog(@"错误%@",[error description]);
////    }
////    [self.downloadDelegate updateCellProgress:fileInfo];
////    NSLog(@"正在接受搜数据%d",[fileInfo.fileReceivedData length]);
////}
//
////1.实现ASIProgressDelegate委托，在此实现UI的进度条更新,这个方法必须要在设置[request setDownloadProgressDelegate:self];之后才会运行
////2.这里注意第一次返回的bytes是已经下载的长度，以后便是每次请求数据的大小
////费了好大劲才发现的，各位新手请注意此处
//-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
//{
//    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
//    if(!fileInfo.isFistReceived)
//    {
//        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
//    }
//    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
//    {
//        [self.downloadDelegate updateCellProgress:request];
//    }
//    fileInfo.isFistReceived=NO;
//}
//
////将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    [self playDownloadSound];
//    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
//    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
//    NSString *name=[fileInfo.fileName substringToIndex:index];;
//    NSString *configPath=[[Config getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSError *error;
//    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
//    {
//        [fileManager removeItemAtPath:configPath error:&error];
//    }
//    if(!error)
//    {
//        NSLog(@"%@",[error description]);
//    }
//    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
//    {
//        [self.downloadDelegate finishedDownload:request];
//    }
//    [request release];
//}
//
//
//#pragma 下载更新界面的委托
//-(void)startDownload:(ASIHTTPRequest *)request;
//{
//    NSLog(@"-------开始下载!");
//}
//
//-(void)updateCellProgress:(ASIHTTPRequest *)request;
//{
//    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
//    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
//}
//
//-(void)finishedDownload:(ASIHTTPRequest *)request;
//{
//    //    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
//    //    [self.downingList removeObject:request];
//    //    [self.finishedList addObject:fileInfo];
//    //    [self.downloadingTable reloadData];
//    //    [self.finishedTable reloadData];
//}





-(ASINetworkQueue*)getQueue:(News *)news 
{
    if (self.downinglist) {
     
        
       ASINetworkQueue* queue =  [self.downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]];
        
            return queue;
        
        
    }
    return  nil;
    
    
    
}

- (void)downLoadComplete:(ASIHTTPRequest *)request
{
	NSLog(@"download complete");
    //FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
}

- (void)downLoadFailed:(ASIHTTPRequest *)request
{
	
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	NSLog(@"queue complete");
}
@end
