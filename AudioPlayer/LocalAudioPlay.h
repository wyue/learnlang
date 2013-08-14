//
//  LocalAudioPlay.h
//  learnlang
//
//  Created by mooncake on 13-8-7.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<AVFoundation/AVFoundation.h>
#import "PlayButton.h"
@class AudioButton;

@class AMProgressView;
@interface LocalAudioPlay : NSObject{
AVAudioPlayer *player;
AudioButton *button;
PlayButton*playbutton;
AMProgressView *progressView;
UILabel *audioLabel;
NSURL *url;
NSTimer *timer;
    UIView<AVAudioPlayerDelegate> *delegate;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) AudioButton *button;
@property (nonatomic, retain)PlayButton*playbutton;
@property (nonatomic, retain) AMProgressView *progressView;
@property (nonatomic, retain) UILabel *audioLabel;
@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) UIView<AVAudioPlayerDelegate> *delegate;

- (void)play;
- (void)stop;
- (BOOL)isProcessing;
- (void)pauseAudio;
@end
