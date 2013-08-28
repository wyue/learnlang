//
//  DataManager.h
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class News;
@class Voice;

@interface DataManager : NSObject



//+ (NSMutableArray *)readNewsArray:(NSString *)str andOld:(NSMutableArray *)olds;
+ (NSMutableDictionary *)readNewsDic:(NSString *)str andOld:(NSMutableDictionary *)olds;
+ (NSMutableArray *)readNewsAryByDic:(NSMutableDictionary *)newDic;
+ (NSMutableArray *)readNewsSectionsyByDic:(NSMutableDictionary *)newDic;

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
+ (NSString *)getCache:(int)type andID:(int)_id;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;
+ (BOOL)isRepeatNews:(NSMutableArray *)all andNews:(News *)n;
+ (BOOL)isRepeatNewsByDictionary:(NSMutableDictionary *)all andNews:(News *)n;

+ (News *)readNewsByDic:(NSMutableDictionary *)sourceDic;
+ (NSMutableArray *)readNewsSavedAryByDic:(NSMutableDictionary *)newDic;
+ (NSString *)getNewsForJson:(News *)news;
+ (NSMutableDictionary *)getNewss:(int)type;
+ (Boolean)insertOrRemoveNews:(int)type andID:(int)_id andString:(NSString *)str;
//+ (void)removeNews:(int)type andNews:(News*)news;
+ (void)removeNewsForSave:(News*)news;//删除保存内容
+ (void)removeNewsForDownload:(News*)news;//删除下载内容
+ (Boolean)isSaved:(int)_id;
+ (Boolean)isDownload:(int)_id;
+(NSURL*)isDownloadFile:(Voice *)voice andNew:(News *)news;//停止使用
+(NSURL*)isDownloadFile:(News *)news;

//保存录音
+ (void)insertRecord:(News *)news andFilePath:(NSURL *)url;
+ (NSMutableDictionary *)getRecords;
+ (void)removeRecord:(News *)news andFilePath:(NSURL *)url;
+ (NSMutableArray *)readRecordsAryByDic:(NSMutableDictionary *)newDic;


+(void) postGuidToServer;
+(void)postSaveToServer:(News*)News andCancel:(BOOL)isCancel;
+(void)postClickToServer:(News*)News;
+(void)postDownloadToServer:(News*)News;

@end
