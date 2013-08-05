//
//  DownloadManager.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"
#import "DownloadDelegate.h"


@interface DownloadManager : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>


@property(nonatomic,retain)NSMutableDictionary *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableDictionary *downinglist;//正在下载的文件列表(ASIHttpRequest对象)
@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;
+(DownloadManager *) Instance;

-(void)loadTempfiles;
-(void)loadFinishedfiles;
@end
