//
//  MenuViewController.m
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "NewsViewController.h"
#import "SavedViewController.h"
#import "DownloadViewController.h"
#import "RecordsViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize dic;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dic = [[NSMutableDictionary alloc]init];
    
    //默认1为首页
    
      [dic setObject:self.mm_drawerController.centerViewController forKey:@"0"];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"444444"];
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"444444"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)dealloc{
    
    [dic release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MenuTableCellIdentifier = @"MenuTableCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuTableCellIdentifier];
    if (cell == nil) {
        cell = [[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuTableCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;  
    // Configure the cell...
    switch (indexPath.row) {
     
        case 0:
        {
           [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_02.png"] forState:UIControlStateNormal ];
            
            //cell.textLabel.text=@"首页";
        }
           
            break;
        case 1:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_04.png"]forState:UIControlStateNormal];
             //cell.textLabel.text=@"我的下载";
        }
            break;
        case 2:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_05.png"]forState:UIControlStateNormal];
             //cell.textLabel.text=@"我的录音";
        }
            break;
        case 3:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_06.png"]forState:UIControlStateNormal];
            //cell.textLabel.text=@"我的收藏";
        }
            break;
        case 4:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_07.png"]forState:UIControlStateNormal];
            //cell.textLabel.text=@"设置";
        }
            break;
        case 5:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_08.png"]forState:UIControlStateNormal];
            //cell.textLabel.text=@"帮助";
        }
            break;
        default:
        {
            [cell.imageButton setImage:[UIImage imageNamed:@"nav-btn-bg_09.png"]forState:UIControlStateNormal];
        }
            break;
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
    
    
    
    
    if ([dic objectForKey:key]==nil){
       
        switch (indexPath.row) {
           
            case 0:
                
            {
                NewsViewController *masterViewController = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil] autorelease];
                masterViewController.catalog=1;
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:masterViewController];
                [dic setObject:navigationController forKey:key];
                
            }
                //self.mm_drawerController.centerViewController=;
                break;
            case 1:
            {
                DownloadViewController *downloadViewController = [[[DownloadViewController alloc] initWithNibName:@"DownloadViewController" bundle:nil] autorelease];
                
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:downloadViewController];
                [dic setObject:navigationController forKey:key];
                
            }
                break;
            case 2:
            {
                RecordsViewController *viewController = [[[RecordsViewController alloc] initWithNibName:@"RecordsViewController" bundle:nil] autorelease];
                
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:viewController];
                [dic setObject:navigationController forKey:key];
               
                
            }
                break;
            case 3:
            {
                
                SavedViewController *savedViewController = [[[SavedViewController alloc] initWithNibName:@"SavedViewController" bundle:nil] autorelease];
                
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:savedViewController];
                [dic setObject:navigationController forKey:key];
            }
                
                break;
            case 4:
            {
                SettingViewController *viewController = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
                
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:viewController];
                [dic setObject:navigationController forKey:key];
            }
                
                break;
            case 5:
            {
                AboutViewController *viewController = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
                
                UINavigationController *navigationController = [Config  customControllerWithRootViewController:viewController];
                [dic setObject:navigationController forKey:key];
            }
                
                break;
            default:
                break;
        }
        
    }
    if ([[dic objectForKey:key] isKindOfClass:[UIViewController class]]) {
        
        [self.mm_drawerController
         setCenterViewController:[dic objectForKey:key]
         withCloseAnimation:YES
         completion:nil];

    }
    
    //[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
