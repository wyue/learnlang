//
//  MyNavigationController.m
//  HaiCar
//
//  Created by monsou on 13-3-5.
//  Copyright (c) 2013年 monsou. All rights reserved.
//

#import "MyNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor-Expanded.h"
#import "CustomNavigationBar.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

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
    
    
    
	// Do any additional setup after loading the view.
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar-bg_02"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.layer.masksToBounds = NO;
        //设置阴影的高度
        self.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
        //设置透明度
        self.navigationBar.layer.shadowOpacity = 0.6;
        self.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationBar.bounds].CGPath;
    }
    //self.navigationBar.tintColor=[UIColor colorWithHexString:@"EB9500"];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
