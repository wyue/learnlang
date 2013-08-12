//
//  PlayButton.m
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "PlayButton.h"

@implementation PlayButton
@synthesize fileModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [fileModel release];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
