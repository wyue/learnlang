//
//  RecordsViewController.m
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "RecordsViewController.h"
#import "RecordCell.h"
#import "NewsDetailViewController.h"
#import "PlayButton.h"
#import "AudioToolBar.h"

@interface RecordsViewController ()

@end

@implementation RecordsViewController


@synthesize tableview;
@synthesize array;
@synthesize arrayForEdit;
@synthesize localplayer;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit:)];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,5,5)] autorelease];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self reLoad];
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
    [localplayer release];
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
    
    if (toolBar) {
        [toolBar setHidden:YES];
        
    }
    NSMutableDictionary *newDic = [DataManager getRecords];
    if (newDic) {
        self.array =  [DataManager readRecordsAryByDic:newDic];
        
        
        
        
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
        
        self.navigationItem.rightBarButtonItem.title=@"删除";
    }else{
        self.navigationItem.rightBarButtonItem.title=@"编辑";
        
        
        if (arrayForEdit.count>0) {
            
            
            
            
            
            for (int i=0; i<arrayForEdit.count; i++) {
                FileModel *fileModel=  [arrayForEdit objectAtIndex:i];
                
                [DataManager removeRecord:fileModel.news andFilePath:[NSURL fileURLWithPath:fileModel.fileURL]];
                [array removeObject:fileModel];
            }
            [self reLoad];
            
        }
        
        
    }
    
}



- (void)pushNewsAction:(id)sender
{
    
    //PlayButton* audioButton =   sender;
   
    
    
     FileModel *n = [array objectAtIndex:self.currentIndex.row];
    if (n) {
        NewsDetailViewController *newsDetailViewController = [[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil] autorelease];
        newsDetailViewController.news = n.news;
        [self.navigationController pushViewController:newsDetailViewController animated:YES];
    }
    
}




- (void)play:(id)sender
{
    
  
    if (!toolBar) {
        CGRect rect_view =[self.view bounds];
        toolBar = [[AudioToolBar alloc]initWithFrame:CGRectMake(rect_view.origin.x, rect_view.size.height-kNewsToolBarHeight, rect_view.size.width, kNewsToolBarHeight)];
        toolBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        
        toolBar.parentViewController=self;
        [self.view addSubview:toolBar];
    }else{
        [toolBar setHidden:NO];
    }
    
    FileModel *n = [array objectAtIndex:self.currentIndex.row];
    if (n) {
       
        
        
        toolBar.news=n.news;
        
        
        [self.toolBar setIsAllPlay:NO];
      
     NSURL *url=   [NSURL fileURLWithPath:n.fileURL];
        if (url) {
            //本地
            [self.toolBar audioPlay:url andIndex:0 andIsLocalFile:YES  andIsNew:YES];
            
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
                 

                 
                 
                
//                 if (isExt == NO)
//                 {
//                      isExt = !isExt;
//                      self.currentIndex=indexPath;
//                     NSString *book = @"ext";
//                     [array insertObject:book atIndex:indexPath.row+1];
//                     NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:self.currentIndex.section];
//                     [tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToInsert] withRowAnimation:UITableViewRowAnimationBottom];
//
//                     
//                     //[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//                 }
//                 else
//                 {
//                      isExt = !isExt;
//                     //d当前有扩展的情况
//                     if ([self.currentIndex isEqual: indexPath]) {
//                         self.currentIndex = nil;
//                         [array removeObjectAtIndex:indexPath.row+1];
//                         NSIndexPath* indexPathToDel = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:self.currentIndex.section];
//                         [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToDel] withRowAnimation:UITableViewRowAnimationBottom];
//                         
//                     }else{
//                         
//                         [array removeObjectAtIndex:self.currentIndex.row+1];
//                         
//                         NSIndexPath* indexPathToDel = [NSIndexPath indexPathForRow:self.currentIndex.row+1 inSection:self.currentIndex.section];
//                         [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToDel] withRowAnimation:UITableViewRowAnimationBottom];
//                         
//                         self.currentIndex=indexPath;
//                         NSString *book = @"ext";
//                         [array insertObject:book atIndex:indexPath.row+1];
//                         
//                         
//                         NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
//                         [tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToInsert] withRowAnimation:UITableViewRowAnimationBottom];
//                         
//
//                     }
//                     
//                     
//                     
//                 }
//
                
                 
                 
            
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
    
    return [RecordCell heightForCellWithNews:[array objectAtIndex:indexPath.row]];
    
    
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
            [ playButton setImage:[UIImage imageNamed:@"myaudio_06.png"] forState:UIControlStateNormal];
            
            playButton.frame=CGRectMake(8, 0, 102, 39.5);
            [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [playButton setBackgroundColor:[UIColor redColor]];
            //playButton.fileModel=fileModel;
            
            postButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [ postButton setImage:[UIImage imageNamed:@"myaudio_08.png"] forState:UIControlStateNormal];
            postButton.frame=CGRectMake(102+8, 0, 101, 39.5);
            [postButton setBackgroundColor:[UIColor redColor]];
            [postButton addTarget:self action:@selector(pushNewsAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [ delButton setImage:[UIImage imageNamed:@"myaudio_10.png"] forState:UIControlStateNormal];
            delButton.frame=CGRectMake(101+102+8, 0, 102, 39.5);
            [delButton setBackgroundColor:[UIColor redColor]];
            [delButton addTarget:self action:@selector(tableViewEdit:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.contentView addSubview:playButton];
            [cell.contentView addSubview:postButton];
            [cell.contentView addSubview:delButton];
            [playButton release];
            [postButton release];
            [delButton release];
        }
        
        
     
           // newsButton.fileModel=fileModel;
         
            
            
            
        return cell;
        
        
    }
    
    
    RecordCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    [cell.extButton addTarget:self action:@selector(extButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    FileModel *fileModel = [array objectAtIndex:indexPath.row];
    cell.fileModel = fileModel;
   
//    PlayButton* newsButton = [[PlayButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
//    [newsButton setBackgroundColor:[UIColor redColor]];
//    [newsButton addTarget:self action:@selector(pushNewsAction:) forControlEvents:UIControlEventTouchUpInside];
//    newsButton.fileModel=fileModel;
//    
//    PlayButton* playButton = [[PlayButton alloc]initWithFrame:CGRectMake(60, 20, 30, 30)];
//    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
//     [playButton setBackgroundColor:[UIColor redColor]];
//     playButton.fileModel=fileModel;
//    [cell.contentView addSubview:newsButton];
//    
//    
//    [cell.contentView addSubview:playButton];
  
    

  
    
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
    
    //    NewsDetailViewController *detailViewController = [[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil] autorelease];
    //    detailViewController.news = [array objectAtIndex:indexPath.row];
    
    // [self.navigationController pushViewController:detailViewController animated:YES];
    if (isExt==YES&&(self.currentIndex.row+1)==indexPath.row) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    FileModel *n = [array objectAtIndex:indexPath.row];
    if (n)
    {
        
        if (self.tableview.editing)
        {
            RecordCell *cell = (RecordCell*)[self.tableview cellForRowAtIndexPath:indexPath];
            
            [cell setChecked:!cell.getChecked];
            
            if (cell.getChecked) {
                [arrayForEdit addObject:n];
            }else{
                [arrayForEdit removeObject:n];
            }
            
            
            
        }else{
            
            
//            NewsDetailViewController *newsDetailViewController = [[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil] autorelease];
//            
//            newsDetailViewController.news = n;
//            [self.navigationController pushViewController:newsDetailViewController animated:YES];
        }
    }
    
}



@end
