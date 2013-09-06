//
//  CustomToolbar.h
//  learnlang
//
//  Created by mooncake on 13-8-26.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "News.h"


#import "AMProgressView.h"

#import "PopoverView.h"



#import "AVFoundation/AVFoundation.h"
#import <StoreKit/StoreKit.h>
@class SLComposeViewController;

@interface CustomToolbar : UIToolbar<PopoverViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    News* news;
    UIViewController *parentViewController;
    //功能组件
    UIButton* playButton;
    UIButton* recordButton;
    UIButton* shareButton;
    UILabel *audioLabel;
    
    //音频播放
   // AVPlayer * _player;
    NSTimer * _timerPlay;
    NSMutableArray *_arrayItemList;
    NSURL* mURL;
    float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
 
    
    
    UITableView *extMenuTable;
    
    AMProgressView *progressView;
    
    //录音
    NSURL *recordedFile;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    //分享
    SLComposeViewController *slComposerSheet;
    NSString *sharingText;
    UIImage *sharingImage;
MBProgressHUD *HUD;
}

@property(nonatomic,retain)  News* news;
@property(nonatomic,retain)  UIViewController *parentViewController;
@property(nonatomic,retain)UIButton* playButton;
@property(nonatomic,retain)UIButton* recordButton;
@property(nonatomic,retain)UIButton* shareButton;
@property(nonatomic,retain)UILabel *audioLabel;

//音频播放
@property(nonatomic, retain) NSMutableArray *arrayItemList;
-(void)playToTime:(NSUInteger)index;
-(void) setupAVPlayerForURL: (NSURL*) url;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
-(Float64) currentPlayTime;
-(int) currentPlayIndex:(NSString*) currentPlaySecond;


@property (nonatomic, copy) NSURL* URL;
@property (readwrite, retain, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (retain) AVPlayerItem* mPlayerItem;

//进度
@property(nonatomic,retain) AMProgressView *progressView;
//录音
@property (nonatomic) BOOL isRecording;
//社会化分享
@property (nonatomic,retain) NSString *sharingText;
@property (nonatomic,retain) UIImage *sharingImage;
@property (nonatomic,retain) SLComposeViewController *slComposerSheet;

@property (nonatomic,retain) UITableView *extMenuTable;

-(id)initWithArrayItem:(NSMutableArray *)arrayItemValue;

@end
