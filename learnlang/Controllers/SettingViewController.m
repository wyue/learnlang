//
//  SettingViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "SettingViewController.h"
#import "EGOCache.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize  textSettingOutlet;
@synthesize  wifiSettingOutlet;
@synthesize  audioSettingOutlet;
@synthesize  readSettingOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"设置";
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    
    if ([setting objectForKey:kUserSettingForTextSize]) {
        if ([[setting objectForKey:kUserSettingForTextSize] isEqualToString:TextSizeForSmall]) {
            self.textSettingOutlet.selectedSegmentIndex=0;
            
        }else if ([[setting objectForKey:kUserSettingForTextSize] isEqualToString:TextSizeForLarge]) {
            self.textSettingOutlet.selectedSegmentIndex=2;
            
        }else {
            self.textSettingOutlet.selectedSegmentIndex=1;
            
        }
    }
    if ([setting objectForKey:kUserSettingFor3gDownload]) {
        
        if ([[setting objectForKey:kUserSettingFor3gDownload] isEqualToString:UserSettingFor3gDownloadON]) {
            
            [self.wifiSettingOutlet setOn:YES];
        }else {
             [self.wifiSettingOutlet setOn:NO];
            
        }
        
    }
    if ([setting objectForKey:kUserSettingForAudioPlayInBackground]) {
        
        if ([[setting objectForKey:kUserSettingForAudioPlayInBackground] isEqualToString:UserSettingForAudioPlayInBackgroundON]) {
            
            [self.audioSettingOutlet setOn:YES];
        }else {
            [self.audioSettingOutlet setOn:NO];
            
        }
        
    }
    if ([setting objectForKey:kUserSettingForReadText]) {
        
        if ([[setting objectForKey:kUserSettingForReadText] isEqualToString:UserSettingForReadTextON]) {
            [self.readSettingOutlet setOn:YES];
            
        }else {
            [self.readSettingOutlet setOn:NO];
            
        }
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dealloc{
    [super dealloc];
      [textSettingOutlet release];;
      [wifiSettingOutlet release];
      [audioSettingOutlet release];
      [readSettingOutlet release];
}

-(IBAction)textSettingAction:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger Index = segmentedControl.selectedSegmentIndex;
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
   // NSString* set =[setting objectForKey:kUserSettingForTextSize];
    NSString* size = TextSizeForMiddle;
    
    switch (Index) {
            
        case 0:
            
            size=TextSizeForSmall;
            
            break;
            
        case 1:
            
             size=TextSizeForMiddle;
            
            break;
            
        case 2:
            
              size=TextSizeForLarge;
            
            break;
            
     
            
          
            
        default:
            
            break;
        
            
    }
         [setting setObject:size forKey:kUserSettingForTextSize];
     [setting synchronize];
    
}


-(IBAction)wifiSettingAction:(id)sender{
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    
     NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    //NSString* set =[setting objectForKey:kUserSettingFor3gDownload];
    
    
    if (isButtonOn) {
       
         [setting setObject:UserSettingFor3gDownloadON forKey:kUserSettingFor3gDownload];
    }else {
    
         [setting setObject:UserSettingFor3gDownloadOff forKey:kUserSettingFor3gDownload];
    }
    
    
    
       
    
   
   
    [setting synchronize];
    
    
}
-(IBAction)audioSettingAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    //NSString* set =[setting objectForKey:kUserSettingForAudioPlayInBackground];
    
    
    if (isButtonOn) {
       
        [setting setObject:UserSettingForAudioPlayInBackgroundON forKey:kUserSettingForAudioPlayInBackground];
    }else {
        
         [setting setObject:UserSettingForAudioPlayInBackgroundOff forKey:kUserSettingForAudioPlayInBackground];
    }
    
    
    
    
    
    
    
    [setting synchronize];
}
-(IBAction)readSettingAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
   // NSString* set =[setting objectForKey:kUserSettingForReadText];
    
    
    if (isButtonOn) {
        
         [setting setObject:UserSettingForReadTextON forKey:kUserSettingForReadText];
    }else {
        
        [setting setObject:UserSettingForReadTextOff forKey:kUserSettingForReadText];
    }
    
    
    
    
    
   
    
    [setting synchronize];
}






-(IBAction)clearAllCache:(id)sender{
    
    [[EGOCache currentCache] clearCache];
    
    [Config ToastNotification:@"缓存已清除" andView:self.view andLoading:NO andIsBottom:NO];
}



@end
