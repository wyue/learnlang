//
//  Voice.m
//  learnlang
//
//  Created by mooncake on 13-7-31.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "Voice.h"

@implementation Voice
@synthesize id;
@synthesize text;
@synthesize trantext;
@synthesize voiceSize;
@synthesize voiceUrl;



- (id)initWithParameters:(int)newID
                andText:(NSString *)newText
                  andTrantext:(NSString *)newTrantext
               andVoiceUrl:(NSString *)nVoiceUrl
             andVoiceSize:(float)nVoiceSize
             
{
    Voice *n = [[Voice alloc] init];
    n.id = newID;
    n.text = newText;
    n.trantext = newTrantext;

    n.voiceUrl = nVoiceUrl;
    n.voiceSize = nVoiceSize;

    return n;
}



@end
