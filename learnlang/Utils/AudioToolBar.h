//
//  NewsToolbar.h
//  learnlang
//
//  Created by mooncake on 13-7-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用
//停止使用

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "News.h"
#import "Voice.h"

#import "AMProgressView.h"
#import "LocalAudioPlay.h"
#import "PopoverView.h"

#import "VoiceUILabel.h"

@class SLComposeViewController;

@interface AudioToolBar : UIToolbar<AVAudioPlayerDelegate,PopoverViewDelegate>{
    
    News* news;
    UIViewController *parentViewController;
    AudioButton * audioButton;
    AudioPlayer *_audioPlayer;
    UIButton* recordButton;
    UIButton* shareButton;
    UILabel *audioLabel;
    
    
    AMProgressView *progressView;
    
    //录音
    NSURL *recordedFile;
    LocalAudioPlay *localplayer;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    
    BOOL isChinese;
    
    BOOL isAllPlay;//是否顺序播放
    
    BOOL isAudioPlaying;//是否在使用网络播放器
    int playIndex;
    
    
    SLComposeViewController *slComposerSheet;
    NSString *sharingText;
    UIImage *sharingImage;
}
@property(nonatomic,retain)  News* news;
@property(nonatomic,retain)  UIViewController *parentViewController;
@property(nonatomic,retain)  AudioPlayer *_audioPlayer;

@property(nonatomic,retain) AudioButton * audioButton;

@property(nonatomic,retain)UIButton* recordButton;
@property(nonatomic,retain)UIButton* shareButton;
@property(nonatomic,retain)UILabel *audioLabel;


@property(nonatomic,retain) AMProgressView *progressView;

@property (nonatomic) BOOL isRecording;

@property (nonatomic) BOOL isChinese;

@property (nonatomic) BOOL isAllPlay;

@property (nonatomic) int playIndex;

@property (nonatomic) BOOL isAudioPlaying;
@property(nonatomic,retain)  LocalAudioPlay *localplayer;
//社会化分享
@property (nonatomic,retain) NSString *sharingText;
@property (nonatomic,retain) UIImage *sharingImage;
@property (nonatomic,retain) SLComposeViewController *slComposerSheet;

- (void)audioPlay:(NSURL *)voiceurl andIndex:(int)indexl andIsLocalFile:(BOOL)isLocal  andIsNew:(BOOL)newPlay;
- (void)audioStop;

@end
