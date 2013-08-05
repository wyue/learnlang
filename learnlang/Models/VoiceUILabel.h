//
//  VoiceUILabel.h
//  learnlang
//
//  Created by mooncake on 13-7-25.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceUILabel : UILabel
{
@private NSString* voiceName;
@private NSString* voiceUrl;
@private int index;
}
@property(nonatomic,retain) NSString* voiceName;
@property(nonatomic,retain) NSString* voiceUrl;


@end
