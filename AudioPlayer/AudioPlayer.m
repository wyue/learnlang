//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"
#import "AMProgressView.h"
#import<AVFoundation/AVFoundation.h>

@implementation AudioPlayer

@synthesize streamer, button, url;
@synthesize progressView;
@synthesize audioLabel;


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
    [streamer release];
    [button release];
    [progressView release];
    [audioLabel release];
    [timer invalidate];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting]  ;
}

- (void)play
{
    if (self.url) {
        if (!streamer) {
            
            if ([Config getUserSettingForAudioPlayInBackground] ) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [session setActive:YES error:nil];
            }else{
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                [session setActive:NO error:nil];
            }
            
            
            self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
            
            
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
                                                         name:ASStatusChangedNotification
                                                       object:streamer];
            
                        
            
        }
        
        if ([streamer isPlaying]) {
            [streamer pause];
        } else {
            [streamer start];
        }
    }
   
    
}


- (void)pauseAudio
{

	if (streamer&&[streamer isPlaying])
	{
        
		[streamer pause];
//        [streamer stop];
//		[streamer release];
//		streamer = nil;
        
        // remove notification observer for streamer
//		[[NSNotificationCenter defaultCenter] removeObserver:self
//                                                        name:ASStatusChangedNotification
//                                                      object:streamer];
        //        [[NSNotificationCenter defaultCenter] removeObserver:self
        //                                                        name:StatusFinishNotificationForAudio
        //                                                      object:self];
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
	if (streamer)
	{
      
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];

		
		[streamer stop];
		[streamer release];
		streamer = nil;
//        [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                        name:StatusFinishNotificationForAudio
//                                                      object:self];
	}
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];
        [progressView setProgress:streamer.progress/streamer.duration];
        if (streamer.currentTime) {
            audioLabel.text=[NSString stringWithFormat:@"%@/%@",streamer.currentTime,streamer.audioTime];
        }
    
        
        
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
//	if ([streamer isWaiting])
//	{
//        button.image = [UIImage imageNamed:stopImage];
//        [button startSpin];
//    } else if ([streamer isIdle]) {
//        button.image = [UIImage imageNamed:playImage];
//        NSNotification *notification = [NSNotification notificationWithName:StatusFinishNotificationForAudio object:self];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        
//        
//		[self stop];		
//	} else if ([streamer isPaused]) {
//        button.image = [UIImage imageNamed:playImage];
//        [button stopSpin];
//        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
//    } else if ([streamer isPlaying] ) {
//        button.image = [UIImage imageNamed:stopImage];
//        [button stopSpin];        
//	} else {
//        
//    }
    
    
   	if ([streamer isWaiting])
	{
        button.image = [UIImage imageNamed:stopImage];
                //[button startSpin];
	}
	else if ([streamer isPlaying])
	{
		button.image = [UIImage imageNamed:stopImage];
               //[button stopSpin];
	}else if ([streamer isPaused])
	{
		button.image = [UIImage imageNamed:playImage];
       
	}
	else if ([streamer isIdle])
	{
		button.image = [UIImage imageNamed:playImage];
        NSNotification *notification = [NSNotification notificationWithName:StatusFinishNotificationForAudio object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
		[self stop];
	}
    
    
    [button setNeedsLayout];    
    [button setNeedsDisplay];
}


@end
