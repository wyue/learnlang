//
//  DataManager.m
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "DataManager.h"

#import "News.h"
#import "Voice.h"
#import "SBJson.h"

@implementation DataManager



+ (NSMutableArray *)readNewsArray:(NSString *)str andOld:(NSMutableArray *)olds
{
    
    
    
    
    
    
    
    
    NSMutableArray *mutablearray = [[NSMutableArray alloc]init];
    
    int j=0;
    for (int i = 0; i<newsPageSize; i++) {
        News *news = [[News alloc]init];
        news._id=j++;
        news.title=@"测试标题";
        news.subTitle=@"测试中文标题";
        news.imgBigUrl=@"http://www.51mtw.com/UploadFiles/2012-10/admin/2012101122515921867.jpg";
        news.imgUrl=@"http://wenwen.soso.com/p/20110702/20110702143413-781757404.jpg";
        news.voiceUrl=@"http://lianzidi.com/COFFdD0xMzc0NTQyMDI3Jmk9MjEwLjcyLjIxLjIyNiZ1PVNvbmdzL3YxL2ZhaW50UUMvNGYvNTkyYTIwNTk4NzA3NTAwODY0NjY0Yzc5OTE2ZjU1NGYubXAzJm09NDVjMmNmNWZjZjRkYTU1MWExMjYyYjk5ODZlMzQ0NjAmdj1saXN0ZW4mbj288rWltcTKwiZzPcDutPrErSZwPXM=.mp3";
        news.pubDate=@"2013-07-22 15:22";
        news.newsType=1;
        news.clickCount=1;
        news.content=@"dddddd";
        news.subContent=@"顶顶顶顶";
        
        
        
        if (![DataManager isRepeatNews:olds andNews:news]) {
           [mutablearray addObject:news];
        }
        [news release];
        
    }
    
    return mutablearray;
    
}

+ (NSMutableDictionary *)readNewsDic:(NSString *)str andOld:(NSMutableDictionary *)olds
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* oldAry = [DataManager readNewsAryByDic:olds];
    NSMutableArray *mutablearray = [[NSMutableArray alloc]init];
    
     SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
   NSMutableDictionary *dataDic =  [jsonParser objectWithString:str];
    NSMutableArray* items = [dataDic objectForKey:@"items"];
    
    
    for (int i = 0; i<items.count; i++) {
        
        NSMutableDictionary *itemDic= [items objectAtIndex:i];
        
        NSMutableArray* source = [itemDic objectForKey:@"source"];
        
        
        for (int j = 0; j<source.count; j++) {
            NSMutableDictionary *sourceDic= [source objectAtIndex:j];
            
            News *news = [[News alloc]init];
            news._id=[[sourceDic objectForKey:@"id"] intValue];
            news.title=[sourceDic objectForKey:@"title"];
            news.subTitle=[sourceDic objectForKey:@"subtitle"];
NSString  *imageUrl= [sourceDic objectForKey:@"imgUrl"];
             news.picUrl = imageUrl;
            if(imageUrl&&![imageUrl isEqualToString:@""]){
                NSString* ext =[imageUrl pathExtension];
                NSString *filename=[imageUrl substringToIndex:imageUrl.length-ext.length-1];
               
                news.imgUrl=[NSString stringWithFormat:@"%@%@%@",filename,@"-sque.",ext];
                news.imgBigUrl=[NSString stringWithFormat:@"%@%@%@",filename,@"-title.",ext];
                
                
            }else{
                news.imgUrl=imageUrl;
                news.imgBigUrl=imageUrl;
                
            }
          
            
            news.voiceUrl=[sourceDic objectForKey:@"voiceUrl"];
            news.pubDate=[sourceDic objectForKey:@"pubDate"];
            news.newsType=[[sourceDic objectForKey:@"type"] intValue];
            news.clickCount=[[sourceDic objectForKey:@"clickCount"] intValue];
             news.saveCount=[[sourceDic objectForKey:@"saveCount"] intValue];
            //news.content=[sourceDic objectForKey:@"content"];
            news.subContent=[sourceDic objectForKey:@"trancontent"];
            
            
            NSMutableArray * contentAry = [sourceDic objectForKey:@"content"];
            NSMutableArray * voiceAry = [[NSMutableArray alloc]initWithCapacity:contentAry.count];
             for (int k = 0; k<source.count; k++) {
                 NSMutableDictionary *voiceDic=[contentAry objectAtIndex:k];
               Voice* voice =   [[Voice alloc]initWithParameters:[[voiceDic objectForKey:@"id"] intValue] andText:[voiceDic objectForKey:@"text"] andTrantext:[voiceDic objectForKey:@"trantext"] andVoiceUrl:[voiceDic objectForKey:@"voiceUrl"] andVoiceSize:[[voiceDic objectForKey:@"voiceSize"] floatValue] ];
                 [voiceAry addObject:voice];
                 [voice release];
             }
            
            news.contentAry=voiceAry;
     
            
            
            
            if (![DataManager isRepeatNews:oldAry andNews:news]) {
                [mutablearray addObject:news];
            }
            [news release];
            
            
        }
        
        
        
        
        
         [dic setObject:mutablearray forKey:[itemDic objectForKey:@"createDate"]];
        
    }
    
    
    
    
   
    
//    int j=0;
//    for (int i = 0; i<newsPageSize; i++) {
//        News *news = [[News alloc]init];
//        news._id=j++;
//        news.title=@"测试标题";
//        news.subTitle=@"测试中文标题";
//        news.imgBigUrl=@"http://www.51mtw.com/UploadFiles/2012-10/admin/2012101122515921867.jpg";
//        news.imgUrl=@"http://wenwen.soso.com/p/20110702/20110702143413-781757404.jpg";
//        news.voiceUrl=@"http://lianzidi.com/COFFdD0xMzc0NTQyMDI3Jmk9MjEwLjcyLjIxLjIyNiZ1PVNvbmdzL3YxL2ZhaW50UUMvNGYvNTkyYTIwNTk4NzA3NTAwODY0NjY0Yzc5OTE2ZjU1NGYubXAzJm09NDVjMmNmNWZjZjRkYTU1MWExMjYyYjk5ODZlMzQ0NjAmdj1saXN0ZW4mbj288rWltcTKwiZzPcDutPrErSZwPXM=.mp3";
//        news.pubDate=@"2013-07-22 15:22";
//        news.newsType=1;
//        news.clickCount=1;
//        news.content=@"dddddd";
//        news.subContent=@"顶顶顶顶";
//        
//        
//     news.contentAry=  [ NSMutableArray arrayWithObjects:@"aaaaaaaaaaaaaaaaa",@"sdfsfsfssdfssfs",@"ccccccccccccccccwwwwwwwwwwwwwwwwwwwwwwwwwwwwwccccccccccccccccccccccc",@"ccccccccccccccccwwwwwwwwwwwwwwwwwwwwwwwwwwwwwccccccccccccccccccccccc",@"ccccccccccccccccwwwwwwwwwwwwwwwwwwwwwwwwwwwwwccccccccccccccccccccccc",@"ccccccccccccccccwwwwwwwwwwwwwwwwwwwwwwwwwwwwwccccccccccccccccccccccc", nil];
//        
//        
//        
//        if (![DataManager isRepeatNews:oldAry andNews:news]) {
//            [mutablearray addObject:news];
//        }
//        [news release];
    
//    }
//    [dic setObject:mutablearray forKey:@"2013-07-13 星期四"];
//    [dic setObject:mutablearray forKey:@"2013-07-12 星期四"];
    
    return dic;
    
}


+ (NSMutableArray *)readNewsSectionsyByDic:(NSMutableDictionary *)newDic
{
    
    
    
    
    
    if (newDic) {
        NSArray *ary =  [newDic allKeys];
        if (ary) {
            NSMutableArray *mutablearray = [[NSMutableArray alloc]initWithArray:ary];
            
            
            
            [mutablearray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                
                
                NSString *test1 = obj1;
                
                NSString *test2 = obj2;
                
                
                
                
                NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                
                //注意dateFormatter的格式一定要按字符串的样子来，如果不对，转换出来是nill。
                
                //时区格式，可以不用设置
                //NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                //[formatter setTimeZone:timeZone];
                
                [dateFormatter setDateFormat:@"YYYY/MM/dd"]; //设置日期格式
                NSDate *date1 = [dateFormatter dateFromString:test1]; //当前日期
                
             
                
                NSDate *date2 = [dateFormatter dateFromString:test2];  //开始日期，将NSString转为NSDate
                
             
                
                

                
                if (date1&&date2) {
                    double a = date1.timeIntervalSince1970;
                    
                    double b = date2.timeIntervalSince1970;
                    
                    if (a < b) {
                        
                        return NSOrderedDescending;
                        
                    } else if (a > b) {
                        
                        return NSOrderedAscending;
                        
                    } else {
                        
                        return NSOrderedSame;
                        
                    }
                }
                return NSOrderedSame;
             
                
            }];
            
            
            
            return mutablearray ;
        }
        
    }
    return nil;
    
    
    
    
}

+ (NSMutableArray *)readNewsAryByDic:(NSMutableDictionary *)newDic
{
    
    

    
   
    if (newDic) {
           NSArray *ary =  [newDic allValues];
        if (ary) {
            NSMutableArray *all = [[NSMutableArray alloc]init];
            for (NSMutableArray *newAry in ary) {
                [all addObjectsFromArray:newAry];
            }
            
            
            
            return all ;
        }
       
    }
    return nil;
    
    
    
    
}


+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}
+ (BOOL)isRepeatNews:(NSMutableArray *)all andNews:(News *)n
{
    if (all == nil) {
        return NO;
    }
    for (News * _n in all) {
        if (_n._id == n._id) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)isRepeatNewsByDictionary:(NSMutableDictionary *)dic andNews:(News *)n
{
    if (dic == nil) {
        return NO;
    }
    NSMutableArray* all = [DataManager readNewsAryByDic:dic];
    
    for (News * _n in all) {
        if (_n._id == n._id) {
            return YES;
        }
    }
    return NO;
}

@end
