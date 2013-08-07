//
//  VoiceUILabel.m
//  learnlang
//
//  Created by mooncake on 13-7-25.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "VoiceUILabel.h"

@implementation VoiceUILabel
@synthesize voiceName;
@synthesize voiceUrl;
@synthesize indexl;
@synthesize voice;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [voiceName   release];
    [voiceUrl release];
    [voice release];
    [super dealloc];
}

@end
