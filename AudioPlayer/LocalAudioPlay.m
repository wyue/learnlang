//
//  LocalAudioPlay.m
//  learnlang
//
//  Created by mooncake on 13-8-7.
//  Copyright (c) 2013年 ciic. All rights reserved.
//





#import "LocalAudioPlay.h"

#import "AudioButton.h"

#import "AMProgressView.h"

@implementation LocalAudioPlay

@synthesize player, button, url,playbutton;
@synthesize progressView;
@synthesize audioLabel;
@synthesize delegate;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [player release],player = nil;
    [button release];
    [playbutton release];
    [progressView release];
    [audioLabel release];
    [timer invalidate];
    [delegate release];
}


- (BOOL)isProcessing
{
    return [player isPlaying]  ;
}

- (void)play
{
    if (self.url) {
        if (!player) {
            
            
            
            
            if ([Config getUserSettingForAudioPlayInBackground] ) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [session setActive:YES error:nil];
            }else{
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [session setActive:NO error:nil];
            }
            
            
            
            self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
            
            
            if (delegate) {
                self.player.delegate=delegate;
            }
            
            // set up display updater
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(updateProgress)]];
            [invocation setSelector:@selector(updateProgress)];
            [invocation setTarget:self];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 invocation:invocation
                                                    repeats:YES];
            
            // register the streamer on notification
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playbackStateChanged:)
                                                         name:LOCALASStatusChangedNotification
                                                       object:player];
        }
        
        
        if ([player isPlaying]) {
            [player pause];
             button.image = [UIImage imageNamed:playImage];
        } else {
            [player play];
             button.image = [UIImage imageNamed:stopImage];
        }
    }
    
    
}


- (void)stop
{
    [button setProgress:0];
    [button stopSpin];
    
    button.image = [UIImage imageNamed:playImage];
    button = nil; // 避免播放器的闪烁问题
    [button release];
    
    [progressView setProgress:0];
    
    // release streamer
	if (player)
	{
		[player stop];
        player.currentTime = 0;
		[player release];
		player = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:LOCALASStatusChangedNotification
                                                      object:player];
	}
}

- (void)updateProgress
{
    if (player.currentTime <= player.duration ) {
        [button setProgress:player.currentTime/player.duration];
        [progressView setProgress:player.currentTime/player.duration];
        audioLabel.text=[NSString stringWithFormat:@"%3d/%3d秒",
                         (int)(player.currentTime),(int)(player.duration)];
        
        
    } else {
        [button setProgress:0.0f];
        [progressView setProgress:0.0f];
        audioLabel.text=@"";
        
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([player isPlaying])
	{
        button.image = [UIImage imageNamed:stopImage];
        [button startSpin];
    } else  {
        button.image = [UIImage imageNamed:playImage];
		[self stop];
	} 
    
    [button setNeedsLayout];
    [button setNeedsDisplay];
}

@end
