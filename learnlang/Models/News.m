//
//  News.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "News.h"

@implementation News

@synthesize _id;
@synthesize title;
@synthesize subTitle;//副标题、中文标题

@synthesize picUrl;//原图地址
@synthesize imgUrl;//tableview图地址
@synthesize imgBigUrl;//内容页大图地址
@synthesize url;//文章地址
@synthesize voiceUrl;//音频下载地址



@synthesize clickCount;//点击量
@synthesize saveCount;//点击量


@synthesize pubDate;//发布日期

@synthesize newsType;//分类

@synthesize content;//内容

@synthesize subContent;//翻译内容


@synthesize contentAry;//内容组

@synthesize voiceAry;//音频组

@synthesize json;



//- (id)initWithParameters:(int)newID
//                andTitle:(NSString *)newTitle
//                  andUrl:(NSString *)newUrl
//               andAuthor:(NSString *)nAuthor
//             andAuthorID:(int)nauthorID
//              andPubDate:(NSString *)nPubDate
//         andCommentCount:(int)nCommentCount
//{
//    News *n = [[News alloc] init];
//    n._id = newID;
//    n.title = newTitle;
//    n.url = newUrl;
// 
//    n.pubDate = nPubDate;
//   
//    return n;
//}

#pragma mark -

+ (void)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[AFCustomClient sharedClient] getPath:@"stream/0/posts/stream/global" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
           // News *post = [[News alloc] initWithAttributes:attributes];
           // [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
