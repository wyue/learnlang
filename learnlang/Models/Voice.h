//
//  Voice.h
//  learnlang
//
//  Created by mooncake on 13-7-31.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Voice : NSObject
@property int id;//id
@property (nonatomic,copy) NSString * text;//
@property (nonatomic,copy) NSString * trantext;//

@property float voiceSize;//
@property (nonatomic,copy) NSString * voiceUrl;//

- (id)initWithParameters:(int)newID
                 andText:(NSString *)newText
             andTrantext:(NSString *)newTrantext
             andVoiceUrl:(NSString *)nVoiceUrl
            andVoiceSize:(float)nVoiceSize;
@end
