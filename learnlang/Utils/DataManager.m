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
#import "DownloadManager.h"

@implementation DataManager


//暂时没有启用
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
//使用中
+ (NSMutableDictionary *)readNewsDic:(NSString *)str andOld:(NSMutableDictionary *)olds
{
    
    
   
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* oldAry = [DataManager readNewsAryByDic:olds];
    
    
     //SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    
    NSError *error = nil;
   
    NSMutableDictionary *dataDic =  [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]   options:NSJSONReadingMutableLeaves error:&error]; //[jsonParser objectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] ];
    NSMutableArray* items = [dataDic objectForKey:@"items"];
    
    
    for (int i = 0; i<items.count; i++) {
        
        NSMutableDictionary *itemDic= [items objectAtIndex:i];
        
        NSMutableArray* source = [itemDic objectForKey:@"source"];
        NSMutableArray *mutablearray = [[NSMutableArray alloc]init];
        
        for (int j = 0; j<source.count; j++) {
            NSMutableDictionary *sourceDic= [source objectAtIndex:j];
            
          News *news =  [self readNewsByDic:sourceDic];
             
            
            
            if (![DataManager isRepeatNews:oldAry andNews:news]) {
                [mutablearray addObject:news];
            }
            [news release];
            
            
        }
        
        
        
        
        
         [dic setObject:mutablearray forKey:[itemDic objectForKey:@"createDate"]];
        
    }
    
    
    
    
 
    
    return dic;
    
}

//将news.json转换为news
+ (News *)readNewsByDic:(NSMutableDictionary *)sourceDic{
    News *news = [[News alloc]init];
    news._id=[[sourceDic objectForKey:@"id"] intValue];
    news.title=[sourceDic objectForKey:@"title"];
    news.subTitle=[sourceDic objectForKey:@"subtitle"];
    NSString  *imageUrl= [sourceDic objectForKey:@"imgUrl"];
    news.picUrl = imageUrl;
    if(imageUrl&&![imageUrl isEqualToString:@""]){
        
        NSString* ext =[imageUrl pathExtension];
        NSString *filename=[imageUrl substringToIndex:imageUrl.length-ext.length-1];
        news.imgUrl=[NSString stringWithFormat:@"%@%@%@",filename,@".",ext];
        news.imgBigUrl=[NSString stringWithFormat:@"%@%@%@",filename,@".",ext];
//        news.imgUrl=[NSString stringWithFormat:@"%@%@%@",filename,@"-sque.",ext];
//        news.imgBigUrl=[NSString stringWithFormat:@"%@%@%@",filename,@"-title.",ext];
        
        
    }else{
        //news.picUrl=@"";
        news.imgUrl=imageUrl;
        news.imgBigUrl=imageUrl;
        
    }
    
    
    news.voiceUrl=[sourceDic objectForKey:@"voiceUrl"];
    //测试数据
    //news.voiceUrl=@"http://learn.china.cn/article/mp3/16/p_69.mp3";
    
    
    
    
    news.pubDate=[sourceDic objectForKey:@"pubDate"];
    news.newsType=[[sourceDic objectForKey:@"type"] intValue];
    news.clickCount=[[sourceDic objectForKey:@"clickCount"] intValue];
    news.saveCount=[[sourceDic objectForKey:@"saveCount"] intValue];
    news.content=[sourceDic objectForKey:@"text"];//modify by wangyue 20130829 改变音频获得的方式 通过content记录lrc文件内容
//测试数据
            //NSString *lrcPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"lrc"];
           // NSError *error=nil;
            //NSString * textContent = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:&error];
   // news.content=textContent;
    news.subContent=[sourceDic objectForKey:@"trancontent"];
    
    //modify by wangyue 20130829 改变音频获得的方式
//    NSMutableArray * contentAry = [sourceDic objectForKey:@"content"];
//    NSMutableArray * voiceAry = [[NSMutableArray alloc]initWithCapacity:contentAry.count];
//    for (int k = 0; k<contentAry.count; k++) {
//        NSMutableDictionary *voiceDic=[contentAry objectAtIndex:k];
//        Voice* voice =   [[Voice alloc]initWithParameters:[[voiceDic objectForKey:@"id"] intValue] andText:[voiceDic objectForKey:@"text"] andTrantext:[voiceDic objectForKey:@"trantext"] andVoiceUrl:[voiceDic objectForKey:@"voiceUrl"] andVoiceSize:[[voiceDic objectForKey:@"voiceSize"] floatValue] ];
//        [voiceAry addObject:voice];
//        [voice release];
//    }
//    
//    news.contentAry=voiceAry;
    
    
    
    NSError *writeError = nil;
    NSData *newsData =  [NSJSONSerialization dataWithJSONObject:sourceDic options:NSJSONWritingPrettyPrinted error:&writeError];;
    NSString *newsJsonString = [[NSString alloc] initWithData:newsData encoding:NSUTF8StringEncoding];
    news.json=newsJsonString;
    return news;
}

//获得table section 即keys for dic
+ (NSMutableArray *)readNewsSectionsyByDic:(NSMutableDictionary *)newDic
{
    
    
    
    
    
    if (newDic) {
        NSArray *ary =  [newDic allKeys];
        if (ary) {
            NSMutableArray *mutablearray = [[NSMutableArray alloc]initWithArray:ary];
            
            
            //排序开始
          
            [mutablearray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                
                
                NSString *test1 = obj1;
                
                NSString *test2 = obj2;
                
                
                
                
                NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                
                //注意dateFormatter的格式一定要按字符串的样子来，如果不对，转换出来是nill。
                
                //时区格式，可以不用设置
                //NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                //[formatter setTimeZone:timeZone];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设置日期格式
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
            
            //排序结束
            
            return mutablearray ;
        }
        
    }
    return nil;
    
    
    
    
}
//将dic转换成array
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


//获得已收藏news 将dic转换成array
+ (NSMutableArray *)readNewsSavedAryByDic:(NSMutableDictionary *)newDic
{
    
    
    
    NSMutableArray *newsSaved = [[NSMutableArray alloc]init];
    
    if (newDic) {
        
        
     NSMutableDictionary *dic=   [newDic objectForKey:@"NewsSavedDic"];
        NSMutableArray *ary=   [newDic objectForKey:@"NewsSavedAry"];
        if (dic&&ary) {
            for (int i=0; i<[ary count]; i++) {
              NSString *key =  [ary objectAtIndex:i];
                if ([dic objectForKey:key]) {
                    NSError *error = nil;
                   NSMutableDictionary *dataDic =  [NSJSONSerialization JSONObjectWithData: [[dic objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]   options:NSJSONReadingMutableLeaves error:&error]; //[jsonParser objectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] ];
                 News *news=   [self readNewsByDic:dataDic];
                    
                    if (news) {
                        [newsSaved addObject:news];
                        [news release];
                    }
                    
                    
                }
                
            }
        }
        
        
               
    }
    return newsSaved;
    
    
    
    
}



//获得已收藏news 将dic转换成array
+ (NSString *)getNewsForJson:(News *)news
{
    
    
    
   
    
    if (news) {
//        NSError *writeError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:news options:NSJSONWritingPrettyPrinted error:&writeError];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        return news.json;
        
    }
    return nil;
    
    
    
    
}
+ (Boolean)insertOrRemoveNews:(int)type andID:(int)_id andString:(NSString *)str
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%d",_id ];
    
    Boolean isInsert =TRUE;
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",type];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",type];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    if (dic==nil) {
        ary = [[NSMutableArray alloc]init];
        dic = [[NSMutableDictionary alloc]init];
        isInsert=TRUE;
    }else{
        
        
        if ([dic objectForKey:idStr]) {//已经有值说明删除
            isInsert=FALSE;
        }else{
            isInsert=TRUE;
        }
        
        
        
    }
    NSMutableDictionary *dictMutable = [dic mutableCopy];
    
    NSMutableArray *arrayMutable = [ary mutableCopy];
    if (isInsert) {
        if (str) {
            [dictMutable setObject:str forKey:idStr];
            [arrayMutable addObject:idStr];
        }
        
    }else{
        [dictMutable removeObjectForKey:idStr];
        [arrayMutable removeObject:idStr];
        
        
    }
    
    
    
    
    
    
    
    
    [setting setObject:dictMutable forKey:dickey];
    [setting setObject:arrayMutable forKey:arykey];
    [setting synchronize];
    
    return isInsert;
}

//删除保存的内容
+ (void)removeNewsForSave:(News*)news
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%d",news._id ];
    
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kSaveType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kSaveType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    
    
    if (dic&&[dic objectForKey:idStr]) {
        
        
        NSMutableDictionary *dictMutable = [dic mutableCopy];
        
        NSMutableArray *arrayMutable = [ary mutableCopy];
        
        [dictMutable removeObjectForKey:idStr];
        [arrayMutable removeObject:idStr];

        [setting setObject:dictMutable forKey:dickey];
        [setting setObject:arrayMutable forKey:arykey];
        [setting synchronize];
    }    
    
    
    
    
    
    
   
    
    
    
  
    
    
}



+ (Boolean)isSaved:(int)_id 
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%d",_id ];
    
    Boolean isSaved =FALSE;
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kSaveType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kSaveType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    if (dic==nil) {
       
        isSaved=FALSE;
    }else{
        
        
        if ([dic objectForKey:idStr]) {//已经有值说明删除
            isSaved=TRUE;
        }else{
            isSaved=FALSE;
        }
        
        
        
    }

    
  
    
    return isSaved;
}





//删除保存的内容
+ (void)removeNewsForDownload:(News*)news
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%d",news._id ];
    
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kDownloadType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kDownloadType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    
    if (dic&&[dic objectForKey:idStr]) {
        NSMutableDictionary *dictMutable = [dic mutableCopy];
        
        NSMutableArray *arrayMutable = [ary mutableCopy];
        
        [dictMutable removeObjectForKey:idStr];
        [arrayMutable removeObject:idStr];
        [setting setObject:dictMutable forKey:dickey];
        [setting setObject:arrayMutable forKey:arykey];
        [setting synchronize];
        
        [[DownloadManager Instance] removeFile:news ];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}




+ (Boolean)isDownload:(int)_id 
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%d",_id ];
    
    Boolean isDOWN =FALSE;
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kDownloadType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kDownloadType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    if (dic==nil) {
        
        isDOWN=FALSE;
    }else{
        
        
        if ([dic objectForKey:idStr]) {//已经有值
            isDOWN=TRUE;
        }else{
            isDOWN=FALSE;
        }
        
        
        
    }
    
    
    
    
    return isDOWN;
}


+ (NSMutableDictionary *)getNewss:(int)type
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",type];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",type];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    
    if (dic) {
        NSMutableDictionary *dictMutable  = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic,@"NewsSavedDic",ary,@"NewsSavedAry",nil];
        return dictMutable;
    }
    
    
    return nil;
}



//录音 增 删 查

+ (NSMutableDictionary *)getRecords
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kRecordType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kRecordType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    
    if (dic) {
        NSMutableDictionary *dictMutable  = [NSMutableDictionary dictionaryWithObjectsAndKeys:dic,@"NewsSavedDic",ary,@"NewsSavedAry",nil];
        return dictMutable;
    }
    
    
    return nil;
}

+ (void)insertRecord:(News *)news andFilePath:(NSURL *)url
{
    
    NSString *targetPath=[url path];
    if([Config isExistFile:targetPath])//已经下载过一次该音乐
    {
        NSString *idStr = [NSString stringWithFormat:@"%@",targetPath ];
        
        
        
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kRecordType];
        NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kRecordType];
        NSDictionary *dic = [setting objectForKey:dickey];
        NSArray *ary = [setting objectForKey:arykey];
        if (dic==nil) {
            ary = [[NSMutableArray alloc]init];
            dic = [[NSMutableDictionary alloc]init];
            
        }
        NSMutableDictionary *dictMutable = [dic mutableCopy];
        
        NSMutableArray *arrayMutable = [ary mutableCopy];
        
        if (url) {
            [dictMutable setObject:news.json forKey:idStr];
            [arrayMutable addObject:idStr];
        }
        
        
        
        [setting setObject:dictMutable forKey:dickey];
        [setting setObject:arrayMutable forKey:arykey];
        [setting synchronize];
    }
   
    
    
}

//删除保存的内容
+ (void)removeRecord:(News *)news andFilePath:(NSURL *)url
{
    
    
    NSString *idStr = [NSString stringWithFormat:@"%@",[url path] ];
    
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"save-news-dic-%d",kRecordType];
    NSString *arykey = [NSString stringWithFormat:@"save-news-ary-%d",kRecordType];
    NSDictionary *dic = [setting objectForKey:dickey];
    NSArray *ary = [setting objectForKey:arykey];
    
    
    if (dic&&[dic objectForKey:idStr]) {
        
        
        NSMutableDictionary *dictMutable = [dic mutableCopy];
        
        NSMutableArray *arrayMutable = [ary mutableCopy];
        
        [dictMutable removeObjectForKey:idStr];
        [arrayMutable removeObject:idStr];
        
        [setting setObject:dictMutable forKey:dickey];
        [setting setObject:arrayMutable forKey:arykey];
        [setting synchronize];
        
        
        
        
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        NSString *targetPath=[url path];
        if([Config isExistFile:targetPath])//已经下载过一次该音乐
        {
            [fileManager removeItemAtPath:targetPath error:&error];
            
            
        }
    }
    
    

    
    
}

//获得已收藏news 将dic转换成array
+ (NSMutableArray *)readRecordsAryByDic:(NSMutableDictionary *)newDic
{
    
    
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if (newDic) {
        
        
        NSMutableDictionary *dic=   [newDic objectForKey:@"NewsSavedDic"];
        NSMutableArray *ary=   [newDic objectForKey:@"NewsSavedAry"];
        if (dic&&ary) {
            for (int i=0; i<[ary count]; i++) {
                NSString *key =  [ary objectAtIndex:i];
                if ([dic objectForKey:key]) {
                    FileModel *fileModel = [[FileModel alloc]init];
                    fileModel.fileName=[NSString stringWithFormat:@"%@%d",kRecorkName,i];
                    fileModel.fileURL=key;
                    NSError *error = nil;
                    NSMutableDictionary *dataDic =  [NSJSONSerialization JSONObjectWithData: [[dic objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]   options:NSJSONReadingMutableLeaves error:&error]; //[jsonParser objectWithData: [str dataUsingEncoding:NSUTF8StringEncoding] ];
                    News *news=   [self readNewsByDic:dataDic];
                    
                    if (news) {
                        fileModel.news=news;
                        [array addObject:fileModel];
                        [fileModel release];
                        
                    }
                    
                    
                   
                }
                
            }
        }
        
        
        
    }
    return array;
    
    
    
    
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

//与旧数据对比是否已存在
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




//20130827 modify wangyue 暂时停用，因为音频播放的方式改变
+(NSURL*)isDownloadFile:(Voice *)voice andNew:(News *)news
{
    
    //NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    
    if (voice) {
        FileModel *fileInfo=[[FileModel alloc]init];
        
        NSString * fileExtension = [voice.voiceUrl pathExtension];
        
        
        fileInfo.fileName=[NSString stringWithFormat:@"%@%d_%d.%@",kDownloadFileName,news._id,voice.id,fileExtension];
        fileInfo.fileExtension=fileExtension;
        fileInfo.fileURL=voice.voiceUrl;
        
        
        
        
        
        //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
        NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:fileInfo.fileName];
        if([Config isExistFile:targetPath])//已经下载过一次该音乐
        {
            return [NSURL fileURLWithPath:targetPath];
            
        }
        
        
    }
    
    return nil;
    
    
    
    
}

//20130827 add wangyue 启用，因为音频播放的方式改变
+(NSURL*)isDownloadFile:(News *)news
{
    
    //NSFileManager *fileManager=[NSFileManager defaultManager];
    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
//    
//    NSURL *url = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
//    return url;
    
    if (news) {
        FileModel *fileInfo=[[FileModel alloc]init];
        
        NSString * fileExtension = [news.voiceUrl pathExtension];
        
        
        fileInfo.fileName=[NSString stringWithFormat:@"%@%d_%d.%@",kDownloadFileName,news._id,news._id,fileExtension];
        fileInfo.fileExtension=fileExtension;
        fileInfo.fileURL=news.voiceUrl;
        
        
        
        
        
        //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
        NSString *targetPath=[[Config getTargetFloderPath]stringByAppendingPathComponent:fileInfo.fileName];
        if([Config isExistFile:targetPath])//已经下载过一次该音乐
        {
            return [NSURL fileURLWithPath:targetPath];
            
        }
        
        
    }
    
    return nil;
    
    
    
    
}




//post server
+(void) postGuidToServer{
    
    NSString * url = [NSString stringWithFormat:@"%@?code=%@&type=2",api_post_guid,[Config Instance].getIOSGuid];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:[Config Instance].getIOSGuid forKey:@"guid"];
    
    [requestForm startAsynchronous];
    
    //输入返回的信息
   // NSLog(@"response\n%@",[requestForm responseString]);
    [requestForm release];
}




+(void)postSaveToServer:(News*)News andCancel:(BOOL)isCancel{
    NSString * url = [NSString stringWithFormat:@"http://learn.china.cn//api/counting.do?type=%d&articleId=%d",2,News._id];
    
    if (isCancel) {
        return;
    }
    
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:[Config Instance].getIOSGuid forKey:@"guid"];
    
    [requestForm startAsynchronous];
    
    //输入返回的信息
    // NSLog(@"response\n%@",[requestForm responseString]);
    [requestForm release];
  
    
    
}
+(void)postClickToServer:(News*)News{
    NSString * url = [NSString stringWithFormat:@"http://learn.china.cn//api/counting.do?type=%d&articleId=%d",1,News._id];
    
  
    
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:[Config Instance].getIOSGuid forKey:@"guid"];
    
    [requestForm startAsynchronous];
    
    //输入返回的信息
    // NSLog(@"response\n%@",[requestForm responseString]);
    [requestForm release];
    

}

+(void)postDownloadToServer:(News*)News{
    NSString * url = [NSString stringWithFormat:@"http://learn.china.cn//api/counting.do?type=%d&articleId=%d",3,News._id];
    
    
    
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:[Config Instance].getIOSGuid forKey:@"guid"];
    
    [requestForm startAsynchronous];
    
    //输入返回的信息
    // NSLog(@"response\n%@",[requestForm responseString]);
    [requestForm release];
}


+(void)saveUpload:(NSString *)idStr{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
   NSString *dickey = [NSString stringWithFormat:@"record-upload"];
    NSDictionary *dic = [setting objectForKey:dickey];
    [dic setValue:@"YES" forKey:idStr];
    
    [setting setObject:dic forKey:dickey];
    [setting synchronize];
}

+(BOOL)isUpload:(NSString *)idStr{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *dickey = [NSString stringWithFormat:@"record-upload"];
    NSDictionary *dic = [setting objectForKey:dickey];
    
    if ([dic objectForKey:idStr]) {
        return YES;
    }
    return NO;
}


@end
