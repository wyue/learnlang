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

@interface RecordsViewController ()

@end

@implementation RecordsViewController


@synthesize tableview;
@synthesize array;
@synthesize arrayForEdit;
@synthesize localplayer;

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
    NSMutableDictionary *newDic = [DataManager getRecords];
    if (newDic) {
        self.array =  [DataManager readRecordsAryByDic:newDic];
        
        
        
        
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
    [localplayer release];
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
                FileModel *fileModel=  [arrayForEdit objectAtIndex:i];
                
                [DataManager removeRecord:fileModel.news andFilePath:[NSURL fileURLWithPath:fileModel.fileURL]];
                [array removeObject:fileModel];
            }
            [tableview reloadData];
            
        }
        
        
    }
    
}



- (void)pushNewsAction:(id)sender
{
    
    PlayButton* audioButton =   sender;
    NewsDetailViewController *newsDetailViewController = [[[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil] autorelease];
    
    newsDetailViewController.news = audioButton.fileModel.news;
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}




- (void)play:(id)sender
{
    
  PlayButton* audioButton =   sender;
//    if (self.avPlay.playing) {
//        [self.avPlay stop];
//        return;
//    }
//    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_fileModel.fileURL] error:nil];
//    self.avPlay = player;
//    [player release];
//    [self.avPlay play];
    
    if (localplayer == nil) {
        localplayer = [[LocalAudioPlay alloc] init];
      
        
    }
    
    if ([localplayer.playbutton isEqual:audioButton]) {
        
        [localplayer play];
    } else {
        
        [localplayer stop];
        
        localplayer.playbutton = audioButton;
      
        localplayer.url = [NSURL fileURLWithPath:audioButton.fileModel.fileURL];
        [localplayer play];
        
    }
}


#pragma mark - Table View



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return [RecordCell heightForCellWithNews:[array objectAtIndex:indexPath.row]];
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RecordCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    FileModel *fileModel = [array objectAtIndex:indexPath.row];
    cell.fileModel = fileModel;
    
    PlayButton* newsButton = [[PlayButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    [newsButton setBackgroundColor:[UIColor redColor]];
    [newsButton addTarget:self action:@selector(pushNewsAction:) forControlEvents:UIControlEventTouchUpInside];
    newsButton.fileModel=fileModel;
    
    PlayButton* playButton = [[PlayButton alloc]initWithFrame:CGRectMake(60, 20, 30, 30)];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
     [playButton setBackgroundColor:[UIColor redColor]];
     playButton.fileModel=fileModel;
    [cell.contentView addSubview:newsButton];
    
    
    [cell.contentView addSubview:playButton];
  
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
