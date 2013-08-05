//
//  News.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property int _id;//id
@property (nonatomic,copy) NSString * title;//标题
@property (nonatomic,copy) NSString * subTitle;//副标题、中文标题
@property (nonatomic,copy) NSString * picUrl;//原图地址
@property (nonatomic,copy) NSString * imgUrl;//tableview图地址

@property (nonatomic,copy) NSString * imgBigUrl;//内容页大图地址
@property (nonatomic,copy) NSString * url;//文章地址
@property (nonatomic,copy) NSString * voiceUrl;//音频下载地址

@property int clickCount;//点击量
@property int saveCount;//点击量

@property (nonatomic,copy) NSString * pubDate;//发布日期

@property int newsType;//分类

@property (nonatomic,copy) NSString * content;//内容

@property (nonatomic,copy) NSString * subContent;//翻译内容


@property (nonatomic,copy) NSMutableArray * contentAry;//内容组

@property (nonatomic,copy) NSMutableArray * voiceAry;//音频组


@property (nonatomic,copy) NSString * json;//

//- (id)initWithParameters:(int)newID
//                andTitle:(NSString *)newTitle
//                  andSubTitle:(NSString *)newUrl
//               andAuthor:(NSString *)nAuthor
//             andAuthorID:(int)authorID
//              andPubDate:(NSString *)nPubDate
//         andCommentCount:(int)nCommentCount;
+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block ;
@end
