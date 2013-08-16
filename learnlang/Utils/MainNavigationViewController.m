//
//  MainNavigationViewController.m
//  learnlang
//
//  Created by mooncake on 13-7-30.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "MainNavigationViewController.h"

#import "NewsViewController.h"

#import <QuartzCore/QuartzCore.h> //This is just for the daysView where I call "daysView.layer" not necessary normally.

#define kStringArray [NSArray arrayWithObjects:@"全 部", @"政 治", @"文 化", @"经 济", @"军 事", nil]
#define kImageArray [NSArray arrayWithObjects:[UIImage imageNamed:@"success"], [UIImage imageNamed:@"error"], [UIImage imageNamed:@"error"], [UIImage imageNamed:@"error"], [UIImage imageNamed:@"error"], [UIImage imageNamed:@"error"], nil]

@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           }
    return self;
}

- (void)toggleMenu:(id)sender
{
   // point = self.view.frame.origin;
  
    point = CGPointMake(self.navigationBar.bounds.size.width-25, CGRectGetMidY(self.navigationBar.bounds));
    
    //point =  CGPointMake(CGRectGetMidX(self.navigationBar.bounds), CGRectGetMidY(self.navigationBar.bounds));
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 143, 219)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor=[UIColor colorWithHexString:@"BEBEBE"];
    pv = [PopoverView showPopoverAtPoint:point
                                  inView:self.view
                         withContentView:tableView
                                delegate:self];
    [pv retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [kStringArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString* CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    cell.textLabel.text=[kStringArray objectAtIndex:indexPath.row];
       return cell;
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NewsViewController *newViewController= (NewsViewController *)[self.viewControllers objectAtIndex:0];
    if (newViewController) {
       
        [newViewController reloadType:indexPath.row];
    }
}

#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
    
    // Figure out which string was selected, store in "string"
   // NSString *string = [kStringArray objectAtIndex:index];
    
    // Show a success image, with the string from the array
    //[popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
    
    // alternatively, you can use
    // [popoverView showSuccess];
    // or
    // [popoverView showError];
    
    // Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [pv release], pv = nil;
}

#pragma mark - UIViewController Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    [pv release], pv = nil;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // get new center coords
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    // move label's center
  //  tapAnywhereLabel.center = center;
    
    if (pv) {
        // popover is visible, so we need to either reposition or dismiss it (dismising is probably best to avoid confusion)
        bool dismiss = YES;
        if (dismiss) {
            [pv dismiss:NO];
        }
        else {
            // move popover
            [pv animateRotationToNewPoint:center
                                   inView:self.view
                             withDuration:duration];
        }
    }
}

@end
