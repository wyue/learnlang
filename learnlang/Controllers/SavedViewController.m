//
//  SavedViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "SavedViewController.h"
#import "NewsWebViewController.h"
#import "SavedCell.h"



@interface SavedViewController ()

@end

@implementation SavedViewController
@synthesize tableview;
@synthesize array,arrayForEdit;
@synthesize isExt;
@synthesize currentIndex;

@synthesize playButton;
@synthesize postButton;
@synthesize delButton;
@synthesize delAllButton;
@synthesize toolBar;
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
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit:)];
     self.tableview.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,5,5)] autorelease];
    self.navigationItem.title=@"我的收藏";
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reLoad];
}
-(void)viewDidDisappear:(BOOL)animatedd{
    
    // CGRect rect_view =[self.view bounds];
    // toolBar.frame=CGRectMake(rect_view.origin.x, rect_view.size.height-kToolBarHeight, rect_view.size.width, kToolBarHeight);
    [toolBar pause:nil];
    
    [super viewDidDisappear:YES];
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
    
    [currentIndex release];
    [playButton release];
    [postButton release];
    [delButton release];
    [delAllButton release];
    [toolBar release];
    [super dealloc];
}

-(void) reLoad{
    //初始化数据
    isExt=NO;
    self.currentIndex=nil;
    [self.delAllButton removeFromSuperview];
    self.delAllButton = nil;
    [self.delAllButton release];
    
    if (toolBar) {
        [toolBar setHidden:YES];
        
    }
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


- (void)tableViewEdit:(id)sender{
    [tableview setEditing:!self.tableview.editing animated:YES];
    
    if (self.tableview.isEditing) {
        
        
        if (arrayForEdit==nil) {
            arrayForEdit = [[NSMutableArray alloc]init];
        }
        
        [arrayForEdit removeAllObjects];
        
        //self.navigationItem.rightBarButtonItem.title=@"删除";
        CGRect rect_view =[self.view bounds];
        if (self.delAllButton==nil) {
            self.delAllButton = [UIButton buttonWithType: UIButtonTypeCustom ];
            
            self.delAllButton.frame=CGRectMake(7.5, rect_view.size.height-41.5, 305, 41.5);
            [self.delAllButton setImage:[UIImage imageNamed:@"mydownload_09.png"] forState:UIControlStateNormal];
            [self.delAllButton addTarget:self action:@selector(tableViewEdit:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:self.delAllButton];
        }else{
            [self.delAllButton setHidden:NO];
            self.delAllButton.frame=CGRectMake(7.5, rect_view.size.height-41.5, 305, 41.5);
        }
        
    }else{
        //self.navigationItem.rightBarButtonItem.title=@"编辑";
        [self.delAllButton removeFromSuperview];
        self.delAllButton = nil;
        [self.delAllButton release];
        
        if (arrayForEdit.count>0) {
            
            
            
            
            
            for (int i=0; i<arrayForEdit.count; i++) {
                News *news=  [arrayForEdit objectAtIndex:i];
                
                [DataManager removeNewsForSave:news];
                [array removeObject:news];
            }
            [self reLoad];
            
        }
        
        
    }
    
}






- (void)play:(id)sender
{
    
    
    if (!toolBar) {
        CGRect rect_view =[self.view bounds];
        toolBar = [[CustomAudioToolbar alloc]initWithFrame:CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight)];
        toolBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        
        toolBar.parentViewController=self;
        [self.view addSubview:toolBar];
    }else{
        [toolBar setHidden:NO];
    }
    
    News  *n = [array objectAtIndex:self.currentIndex.row];
    if (n) {
        
        
        
        toolBar.news=n;
        
        
        
        if ([self.toolBar isPlaying]) {
            [self.toolBar pause:nil];
        }else{
            
            NSURL *url=   [NSURL URLWithString:n.voiceUrl];
            if (url) {
                //网络
                [self.toolBar setupAVPlayerForURL:url];
                [ [NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                [self.toolBar play:nil];
                
            }
        }
        
     
        
        
        
        
    }
    
    
    
}




- (void)extButtonAction:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableview];
    
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        //原展开按钮点击
        if ([indexPath isEqual:self.currentIndex]) {
            self.isExt = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO  indexPathToInsert:indexPath];
            self.currentIndex = nil;
            
        }else
        {//第一次点击
            if (!self.currentIndex) {
                self.currentIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO   indexPathToInsert:indexPath];
                
            }else
            {
                //点击其他cell
                
                
                [self didSelectCellRowFirstDo:NO nextDo:YES   indexPathToInsert:indexPath];
            }
        }
        
        
        
        
        
        
        
        
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert   indexPathToInsert:(NSIndexPath*) indexPath
{
    self.isExt = firstDoInsert;
    
    // RecordCell *cell = (RecordCell *)[self.tableview cellForRowAtIndexPath:self.currentIndex];
    
    
    [self.tableview beginUpdates];
    
    
    
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	
    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:self.currentIndex.row+1 inSection:self.currentIndex.section];
    [rowToInsert addObject:indexPathToInsert];
	
	
	if (firstDoInsert)
    {
        NSString *book = @"ext";
        [array insertObject:book atIndex:self.currentIndex.row+1];
        [self.tableview insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        
        if (toolBar) {
            [toolBar setHidden:YES];
            
        }
        
        [array removeObjectAtIndex:self.currentIndex.row+1];
        
        [self.tableview deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.tableview endUpdates];
    if (nextDoInsert) {
        
        if (indexPath.row-1>self.currentIndex.row) {//因为已经删除了一行，indexPath已经改变
            indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        }
        
        
        self.isExt = YES;
        self.currentIndex = indexPath;
        [self didSelectCellRowFirstDo:YES nextDo:NO     indexPathToInsert:self.currentIndex];
    }
    if (self.isExt) [self.tableview scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table View




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isExt==YES&&(self.currentIndex.row+1)==indexPath.row) {
        return 40;
    }
        return [SavedCell heightForCellWithNews:[array objectAtIndex:indexPath.row]];
  
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    static NSString *CellIdentifierExt = @"CellExt";
    
    
    if (isExt==YES&&(self.currentIndex.row+1)==indexPath.row) {
        
        
        UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifierExt];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierExt] autorelease];
            
            // [cell.extButton addTarget:self action:@selector(extButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];
            playButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [ playButton setImage:[UIImage imageNamed:@"mydownload-_04.png"] forState:UIControlStateNormal];
            
            playButton.frame=CGRectMake(8, 0, 153, 39.5);
            [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [playButton setBackgroundColor:[UIColor redColor]];
            //playButton.fileModel=fileModel;
            
            
            
            delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [ delButton setImage:[UIImage imageNamed:@"mydownload-_06.png"] forState:UIControlStateNormal];
            delButton.frame=CGRectMake(153+8, 0, 152.5, 39.5);
            [delButton setBackgroundColor:[UIColor redColor]];
            [delButton addTarget:self action:@selector(tableViewEdit:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.contentView addSubview:playButton];
            
            [cell.contentView addSubview:delButton];
            [playButton release];
            
            [delButton release];
        }
        
        
        
        // newsButton.fileModel=fileModel;
        
        
        
        
        return cell;
        
        
    }
    
    SavedCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SavedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.extButton addTarget:self action:@selector(extButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
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
            
            
            NewsWebViewController *newsDetailViewController = [[[NewsWebViewController alloc] initWithNibName:@"NewsWebViewController" bundle:nil] autorelease];
            
            newsDetailViewController.news = n;
            [self.navigationController pushViewController:newsDetailViewController animated:YES];
        }
    }

}




@end
