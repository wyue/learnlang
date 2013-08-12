//
//  SettingViewController.h
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    
    UISegmentedControl *textSettingOutlet;
    UISwitch* wifiSettingOutlet;
     UISwitch* audioSettingOutlet;
     UISwitch* readSettingOutlet;
    
}

@property(nonatomic,retain) IBOutlet UISegmentedControl *textSettingOutlet;
@property(nonatomic,retain) IBOutlet UISwitch* wifiSettingOutlet;
@property(nonatomic,retain) IBOutlet UISwitch* audioSettingOutlet;
@property(nonatomic,retain) IBOutlet UISwitch* readSettingOutlet;


-(IBAction)textSettingAction:(id)sender;
-(IBAction)wifiSettingAction:(id)sender;
-(IBAction)audioSettingAction:(id)sender;
-(IBAction)readSettingAction:(id)sender;
@end
