//
//  BaseViewController.m
//  learnlang
//
//  Created by mooncake on 13-9-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "BaseViewController.h"

#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    
    [self setupLeftMenuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLeftMenuButton{
    
    
    UIImage *lImg = [UIImage imageNamed:@"topbar-btn-nav.png"];
    UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lBtn.frame = CGRectMake(0, 0, 45, 44);
    [lBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [lBtn setImage:lImg forState:UIControlStateNormal];
    lBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *lBarBtn = [[UIBarButtonItem alloc] initWithCustomView:lBtn];
    [self.navigationItem setLeftBarButtonItem:lBarBtn animated:YES];
    
    
    [lBtn release];
    [lBarBtn release];
    //MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
