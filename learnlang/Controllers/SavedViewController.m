//
//  SavedViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "SavedViewController.h"
#import "NewsDetailViewController.h"
#import "SavedCell.h"



@interface SavedViewController ()

@end

@implementation SavedViewController
@synthesize tableview;
@synthesize array,arrayForEdit;

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
    
    
   
    self.tableview.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit:)];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //初始化数据
    NSMutableDictionary *newDic = [DataManager getNewss:kSaveType];
    if (newDic) {
        self.array =  [DataManager readNewsSavedAryByDic:newDic];
        
        
        
        
    }
    if (self.array==nil) {
        self.array = [[NSMutableArray alloc]init];
    }
    
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [tableview release];
    [array release];
    [arrayForEdit release];
    [super dealloc];
}



- (void)tableViewEdit:(id)sender{
    [tableview setEditing:!self.tableview.editing animated:YES];
    
    if (self.tableview.isEditing) {
        
        
        if (arrayForEdit==nil) {
            arrayForEdit = [[NSMutableArray alloc]init];
        }
        
        [arrayForEdit removeAllObjects];
        
        self.navigationItem.rightBarButtonItem.title=@"删除";
    }else{
        self.navigationItem.rightBarButtonItem.title=@"编辑";
        
        
        if (arrayForEdit.count>0) {
            
            
            
            
            
            for (int i=0; i<arrayForEdit.count; i++) {
                News *news=  [arrayForEdit objectAtIndex:i];
                
                [DataManager removeNewsForSave:news];
                [array removeObject:news];
            }
            [tableview reloadData];
            
        }
        
        
    }
    
}
#pragma mark - Table View




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
        return [SavedCell heightForCellWithNews:[array objectAtIndex:indexPath.row]];
  
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SavedCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SavedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    News *news = [array objectAtIndex:indexPath.row];
    cell.news = news;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObjectContext *context = [self.array managedObjectContext];
//        [context deleteObject:[self.array objectAtIndexPath:indexPath]];
//        
//        NSError *error = nil;
//        if (![context save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    News *n = [array objectAtIndex:indexPath.row];
    if (n)
    {
        
        if (self.tableview.editing)
        {
            SavedCell *cell = (SavedCell*)[self.tableview cellForRowAtIndexPath:indexPath];
            
            [cell setChecked:!cell.getChecked];
            
            if (cell.getChecked) {
                [arrayForEdit addObject:n];
            }else{
                [arrayForEdit removeObject:n];
            }
            
            
            
        }else{
            
            
            NewsDetailViewController *newsDetailViewController = [[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil] autorelease];
            
            newsDetailViewController.news = n;
            [self.navigationController pushViewController:newsDetailViewController animated:YES];
        }
    }

}




@end
