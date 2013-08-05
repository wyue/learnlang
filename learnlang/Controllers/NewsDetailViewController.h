//
//  NewsDetailViewController.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "NewsToolbar.h"
#import "AMProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import "PopoverView.h"
@class News;

@interface NewsDetailViewController : UIViewController<AVAudioPlayerDelegate,PopoverViewDelegate>{
@private News *news;
    
@private IBOutlet NewsToolbar *toolBar;
@private IBOutlet UIScrollView *scrollView;
    
    
    
@private IBOutlet UILabel *titleLabel;
@private IBOutlet UIImageView *imageView;
@private IBOutlet UIButton *leftButton;
@private IBOutlet UIButton *rightButton;
@private IBOutlet UILabel * subContentLabel;
    
    
    AudioButton * audioButton;
    AudioPlayer *_audioPlayer;
    UIButton* recordButton;
    UIButton* shareButton;
    UILabel *audioLabel;
    
    AMProgressView *progressView;
    
    //录音
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    
    BOOL isChinese;
    
}

@property(nonatomic,retain)News *news;

@property(nonatomic,retain)NewsToolbar *toolBar;
@property(nonatomic,retain)UIScrollView *scrollView;


@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UIButton *leftButton;
@property(nonatomic,retain) UIButton *rightButton;
@property(nonatomic,retain) UILabel * subContentLabel;
@property(nonatomic,retain)  AudioPlayer *_audioPlayer;
@property(nonatomic,retain) AudioButton * audioButton;

@property(nonatomic,retain)UIButton* recordButton;
@property(nonatomic,retain)UIButton* shareButton;
@property(nonatomic,retain)UILabel *audioLabel;

@property(nonatomic,retain) AMProgressView *progressView;

@property (nonatomic) BOOL isRecording;

@property (nonatomic) BOOL isChinese;

- (IBAction)tabButtonAction:(id)sender;

@end
