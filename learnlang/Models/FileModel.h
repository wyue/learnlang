//
//  FileModel.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface FileModel : NSObject

@property(nonatomic,retain)News *news;

@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *fileExtension;
@property(nonatomic,retain)NSString *fileSize;
@property(nonatomic)BOOL isFistReceived;//是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property(nonatomic,retain)NSString *fileReceivedSize;
@property(nonatomic,retain)NSMutableData *fileReceivedData;//接受的数据
@property(nonatomic,retain)NSString *fileURL;
@property(nonatomic)BOOL isDownloading;//是否正在下载
@property(nonatomic)BOOL isP2P;//是否是p2p下载
@end
