//
//  ViewController.h
//  SocialFrameworkExample
//
//  Created by Lei Jing on 9/10/12.
//  Copyright (c) 2012 com.leijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLComposeViewController;

@interface ViewController : UIViewController
{
    SLComposeViewController *slComposerSheet;
}

@property (nonatomic,retain) NSString *sharingText;
@property (nonatomic,retain) UIImage *sharingImage;

@property ( nonatomic,retain) IBOutlet UIButton *facebookButton;
@property ( nonatomic,retain) IBOutlet UIButton *twitterButton;
@property ( nonatomic,retain) IBOutlet UIButton *weiboButton;
@property ( nonatomic,retain) IBOutlet UIButton *activityButton;

- (IBAction)shareToFacebook:(id)sender;
- (IBAction)shareToTwitter:(id)sender;
- (IBAction)shareToWeibo:(id)sender;
- (IBAction)shareByActivity:(id)sender;

@end
