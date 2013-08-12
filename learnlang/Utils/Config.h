//
//  Config.h
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Config : NSObject
#pragma api地址



//是否已经登录
@property BOOL isLogin;

@property (retain, nonatomic) UIViewController * viewBeforeLogin;
@property (copy, nonatomic) NSString * viewNameBeforeLogin;

//是否具备网络链接
@property BOOL isNetworkRunning;



//动弹缓存
@property (retain, nonatomic) UIImage * tweetCachePic;
@property (copy, nonatomic) NSString * tweet;
//问答缓存
@property (copy,nonatomic) NSString * questionTitle;
@property (copy,nonatomic) NSString * questionContent;
@property int questionIndex;
//留言缓存
@property (retain,nonatomic) NSMutableDictionary * msgs;
-(void)saveMsgCache:(NSString *)msg andUID:(int)uid;
-(NSString *)getMsgCache:(int)uid;
//评论缓存
@property (retain,nonatomic) NSMutableDictionary * comments;
-(void)saveCommentCache:(NSString *)comment andCommentID:(int)commentID;
-(NSString *)getCommentCache:(int)commentID;
//回复评论缓存
@property (retain,nonatomic) NSMutableDictionary * replies;
-(void)saveReplyCache:(NSString *)reply andCommentID:(int)commentID andReplyID:(int)replyID;
-(NSString *)getReplyCache:(int)commentID andReplyID:(int)replyID;

//保存登录用户名以及密码
-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
-(NSString *)getUserName;
-(NSString *)getPwd;
-(void)saveUID:(int)uid;
-(int)getUID;
-(void)savePostPubNoticeMe:(BOOL)isNotice;
-(BOOL)isPostPubNoticeMe;
-(void)saveCookie:(BOOL)_isLogin;
-(BOOL)isCookie;

-(void)saveIsPostToMyZone:(BOOL)isToMyZone;
-(BOOL)getIsPostToMyZone;

-(void)savePubPostCatalog:(int)catalog;
-(int)getPubPostCatalog;

-(NSString *)getIOSGuid;

+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;
//获得自定义nav
+(id)customControllerWithRootViewController:(UIViewController *)root;
+(id)customControllerWithRootViewControllerForMain:(UIViewController *)root;
//提醒功能
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;


+(NSString *)getFileSizeString:(NSString *)size;
+(float)getFileSizeNumber:(NSString *)size;

+(NSString *)getDocumentPath;
+(NSString *)getTargetFloderPath;
+(NSString *)getTempFolderPath;
+(BOOL)isExistFile:(NSString *)fileName;
+(float)getProgress:(float)totalSize currentSize:(float)currentSize;

//setting
+(void)defaultUserSetting;//默认用户设置
+(BOOL)getUserSettingFor3gDownload;
+(BOOL)getUserSettingForAudioPlayInBackground ;
+(BOOL)getUserSettingForReadText ;
+(int)getUserSettingForTextSize ;
@end
