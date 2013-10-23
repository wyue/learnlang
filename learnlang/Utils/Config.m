//
//  Config.m
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "Config.h"
#import "AESCrypt.h"
#import "MainNavigationViewController.h"
#import "NavigationController.h"
#import "MyNavigationController.h"
#import "BDKNotifyHUD.h"
#import "sys/utsname.h" 

@implementation Config

@synthesize isLogin;
@synthesize viewBeforeLogin;
@synthesize viewNameBeforeLogin;
@synthesize isNetworkRunning;

+(void)saveAppVersion{
    NSString* strVersion = [[UIDevice currentDevice] systemVersion];
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
    if (strVersion) {
        [setting setObject:strVersion forKey:kAppVersion];
    }
    [setting synchronize];
}
+(NSString *)getAppVersion{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if ([setting objectForKey:kAppVersion]==nil) {
        return @"";
    }
    return [setting objectForKey:kAppVersion];
}

-(void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings setObject:userName forKey:@"UserName"];
    
    pwd = [AESCrypt encrypt:pwd password:@"pwd"];
    
    [settings setObject:pwd forKey:@"Password"];
    [settings synchronize];
}
-(NSString *)getUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UserName"];
}
-(NSString *)getPwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * temp = [settings objectForKey:@"Password"];
    return [AESCrypt decrypt:temp password:@"pwd"];
}
-(void)saveUID:(int)uid
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"UID"];
    [setting setObject:[NSString stringWithFormat:@"%d", uid] forKey:@"UID"];
    [setting synchronize];
}
-(int)getUID
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:@"UID"];
    if (value && [value isEqualToString:@""] == NO)
    {
        return [value intValue];
    }
    else
    {
        return 0;
    }
}
-(void)saveCookie:(BOOL)_isLogin
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"cookie"];
    [setting setObject:isLogin ? @"1" : @"0" forKey:@"cookie"];
    [setting synchronize];
}
-(BOOL)isCookie
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"cookie"];
    if (value && [value isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)savePostPubNoticeMe:(BOOL)isNotice
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"isNotice"];
    [settings setObject:isNotice ? @"1" : @"0" forKey:@"isNotice"];
    [settings synchronize];
}
-(BOOL)isPostPubNoticeMe
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"isNotice"];
    return value && [value isEqualToString:@"1"];
}

-(void)saveIsPostToMyZone:(BOOL)isToMyZone
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"isToMyZone"];
    [settings setObject:isToMyZone ? @"1" : @"0" forKey:@"isToMyZone"];
    [settings synchronize];
}
-(BOOL)getIsPostToMyZone
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *value = [settings objectForKey:@"isToMyZone"];
    if (value) {
        if ([value isEqualToString:@"1"]) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

-(void)savePubPostCatalog:(int)catalog
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"PubPostCatalog"];
    [settings setObject:[NSString stringWithFormat:@"%d",catalog] forKey:@"PubPostCatalog"];
    [settings synchronize];
}

-(int)getPubPostCatalog
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"PubPostCatalog"];
    if (value) {
        return [value intValue];
    }
    else
        return 0;
}

-(NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }
    else
    {
//        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
//        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
//        CFRelease(uuid);
        
        //Vindor标示符 (IDFV-identifierForVendor)
        NSString *uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        
        [settings setObject:uuidString forKey:@"guid"];
        [settings synchronize];
        return uuidString;
    }
}



//+ (void)removeNews:(int)type andID:(int)_id
//{
//    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
//    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",type];
//    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",type];
//    NSDictionary *dic = [setting objectForKey:dickey];
//     NSArray *ary = [setting objectForKey:arykey];
//    if (dic) {
//        NSMutableDictionary *dictMutable = [dic mutableCopy];
//        
//          NSMutableArray *arrayMutable = [ary mutableCopy];
//        
//        [dictMutable removeObjectForKey:[NSString stringWithFormat:@"%d",_id]];
//        [arrayMutable removeObject:[NSString stringWithFormat:@"%d",_id]];
//        dic = dictMutable;
//        ary=arrayMutable ;
//        
//    }
//    
//    
//    [setting setObject:dic forKey:dickey];
//    [setting setObject:ary forKey:arykey];
//    [setting synchronize];
//}



static Config * instance = nil;
+(Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}


+(id)customControllerWithRootViewController:(UIViewController *)root {
    //UINavigationController *nav = [[[NSBundle mainBundle] loadNibNamed:@"NavigationController" owner:self options:nil] objectAtIndex:0];
    //NavigationController *nav = [[NavigationController alloc]initWithNibName:@"NavigationController" bundle:nil];
    

    
    //[nav setViewControllers:[NSArray arrayWithObject:root]];
    
      MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:root];
    return nav;
}
+(id)customControllerWithRootViewControllerForMain:(UIViewController *)root {
   // MainNavigationViewController *nav = [[[NSBundle mainBundle] loadNibNamed:@"MainNavigationViewController" owner:self options:nil] objectAtIndex:0];
//    MainNavigationViewController *nav = [[MainNavigationViewController alloc]initWithNibName:@"MainNavigationViewController" bundle:nil];
//    
//    [nav setViewControllers:[NSArray arrayWithObject:root]];
    
    
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:root];
    return nav;
}





+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
//    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
//    [notificationView show:YES];
//    [notificationView hideAnimatedAfter:2.6];
    
    
    
    
    // Create the HUD object
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"]
                                                    text:text];
    hud.center = CGPointMake(view.center.x, view.center.y - 20);
    
    // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
    [view addSubview:hud];
    [hud presentWithDuration:1.0f speed:0.5f inView:view completion:^{
        [hud removeFromSuperview];
    }];
}

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}




+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%fK",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%fB",[size floatValue]];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}




//默认用户设置
+(void)defaultUserSetting {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
    if ([setting objectForKey:kUserSettingForTextSize]==nil) {
        [setting setObject:TextSizeForMiddle forKey:kUserSettingForTextSize];
    }
    if ([setting objectForKey:kUserSettingFor3gDownload]==nil) {
        [setting setObject:UserSettingFor3gDownloadON forKey:kUserSettingFor3gDownload];
    }
    if ([setting objectForKey:kUserSettingForAudioPlayInBackground]==nil) {
        [setting setObject:UserSettingForAudioPlayInBackgroundOff forKey:kUserSettingForAudioPlayInBackground];
    }
    if ([setting objectForKey:kUserSettingForReadText]==nil) {
        [setting setObject:UserSettingForReadTextOff forKey:kUserSettingForReadText];
    }
    
    [setting synchronize];
}


+(BOOL)getUserSettingFor3gDownload {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
   
    if ([[setting objectForKey:kUserSettingFor3gDownload] isEqualToString:UserSettingFor3gDownloadON]) {
       
        return YES;
    }
    return NO;
    
}
+(BOOL)getUserSettingForAudioPlayInBackground {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
    
    if ([[setting objectForKey:kUserSettingForAudioPlayInBackground] isEqualToString:UserSettingForAudioPlayInBackgroundON]) {
        
        return YES;
    }
    return NO;
    
}
+(BOOL)getUserSettingForReadText {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
    
    if ([[setting objectForKey:kUserSettingForReadText] isEqualToString:UserSettingForReadTextON]) {
        
        return YES;
    }
    return NO;
    
}
+(int)getUserSettingForTextSize {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
   int size = [[TextSizeDictionary objectForKey:[setting objectForKey:kUserSettingForTextSize]] intValue];
    return size;
    
}






+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

@end
