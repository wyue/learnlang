//
//  DownloadsManager.h
//  learnlang
//
//  Created by mooncake on 13-8-5.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"
#import "DownloadDelegate.h"
#import "ASINetworkQueue.h"


@interface DownloadsManager :  NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>


@property(nonatomic,retain)NSMutableDictionary *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableDictionary *downinglist;//正在下载的文件列表(ASIHttpRequest对象)
@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;

-(void)beginRequest:(News *)news isBeginDown:(BOOL)isBeginDown;
- (Boolean)isReDownload:(News*)news;


+(DownloadsManager *) Instance;

//-(void)loadTempfiles;
//-(void)loadFinishedfiles;

-(void)removeFile:(News *)news isDownloading:(BOOL)isDownload;

-(ASINetworkQueue*)getQueue:(News *)news ;
@end
