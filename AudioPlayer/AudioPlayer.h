//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioButton;
@class AudioStreamer;
@class AMProgressView;

@interface AudioPlayer : NSObject {
    AudioStreamer *streamer;
    AudioButton *button;
    AMProgressView *progressView;
    UILabel *audioLabel;
    NSURL *url;
    NSTimer *timer;
}

@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) AudioButton *button;
@property (nonatomic, retain) AMProgressView *progressView;
@property (nonatomic, retain) UILabel *audioLabel;
@property (nonatomic, retain) NSURL *url;

- (void)play;
- (void)stop;
- (BOOL)isProcessing;
- (void)pauseAudio;

@end
