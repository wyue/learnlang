//
//  AboutViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "AboutViewController.h"
#import "UIImage+Resize.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.navigationItem.title=@"关于";
    // Do any additional setup after loading the view from its nib.
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 512)];
    
    imageview.image=[UIImage imageNamed:@"help_bg.png"];
    [scrollView addSubview:imageview];
    scrollView.contentSize=CGSizeMake(320, 512);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
