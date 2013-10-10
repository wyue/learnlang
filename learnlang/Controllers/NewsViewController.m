//
//  NewsViewController.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsViewController.h"
#import "DataManager.h"
#import "NewsTableViewCell.h"
#import "News.h"

#import "CheckNetwork.h"

#import "NewsWebViewController.h"




@interface NewsViewController ()

@end

@implementation NewsViewController



@synthesize sectionNames;
@synthesize newsDic;

@synthesize tableNews;
@synthesize catalog;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    

//
//        UIImage *rImg = [UIImage imageNamed:@"choosebtn_03.png"];
//        UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rBtn.frame = CGRectMake(0, 0, 40, 30);
//        [rBtn addTarget:self.navigationController action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
//        [rBtn setImage:rImg forState:UIControlStateNormal];
//        rBtn.backgroundColor = [UIColor clearColor];
//        UIBarButtonItem *rBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
//        self.navigationItem.rightBarButtonItem = rBarBtn;
//    [rBtn release];
//        [rBarBtn release];

    

    
    self.navigationItem.title=AppTitle;
    //self.navigationItem.titleView.layer.shadowColor = [UIColor yellowColor];
    //self.navigationItem.titleView.layer.shadowOffset = CGSizeMake(2, 2);
    
    
    
    allCount = 0;
    
    
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableNews addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    newsAry = [[NSMutableArray alloc] initWithCapacity:newsPageSize];
    newsDic=[[NSMutableDictionary alloc]init];
   
    sectionNames = [[NSMutableArray alloc] initWithArray:[ NSArray arrayWithObjects:@"", nil]  ];
    
    [self reload:YES];
    self.tableNews.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    self.tableNews.separatorStyle=UITableViewCellSeparatorStyleNone;
    //self.tableNews.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,5,20)] autorelease];
    
}

-(void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
   // self.tableNews.contentInset = UIEdgeInsetsMake(44, 0, 0, 0) ;
   // self.tableNews.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0) ;
    [super viewDidAppear:animated];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableNews];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableNews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [self setTableNews:nil];
    _refreshHeaderView = nil;
    [newsAry removeAllObjects];
    newsAry = nil;
    
    
    
    
    
    [super viewDidUnload];
}

//重新载入类型
- (void)reloadType:(int)ncatalog
{
    self.catalog = ncatalog;
    [self clear];
    [self.tableNews reloadData];
    [self reload:NO];
}
- (void)clear
{
    allCount = 0;
    [sectionNames removeAllObjects];
    [newsAry removeAllObjects];
    [newsDic removeAllObjects];
    isLoadOver = NO;
}
- (void)reload:(BOOL)noRefresh
{
   
    
    //如果有网络连接
    if ([Config Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            
            allCount = 0;
        }
        int pageIndex = allCount/newsPageSize;
        NSString *url;
        url = [NSString stringWithFormat:@"%@list_%d_%d_%d.html", api_news_list, self.catalog, pageIndex, newsPageSize];

       
        
        

        
        [[AFCustomClient sharedClient]getPath:url parameters:Nil
         
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                      
                                      // NSLog(@"%@",operation.responseString);
                                       isLoading = NO;
//                                       if (!noRefresh) {
//                                           [self clear];
//                                       }
                                       
                                       @try {
                                           NSMutableDictionary *newNewsDic = self.catalog <= 1 ?
                                           [DataManager readNewsDic:operation.responseString andOld:newsDic]:
                                           [DataManager readNewsDic:operation.responseString andOld:newsDic];
                                          
                                           NSMutableArray *newNews=[DataManager readNewsAryByDic:newNewsDic];

                                           int count = [newNews count];//获得数据量
                                           allCount += count;
                                           if (count < newsPageSize)
                                           {
                                               isLoadOver = YES;
                                           }
                                           if(count>0){//返回数据为0则无需执行下面内容
                                               [newsAry addObjectsFromArray:newNews];//目前未起作用，只用来记录当前获取的数量
                                               [newsDic addEntriesFromDictionary:newNewsDic];//添加更多页的数据 需要修改
                                               sectionNames = [DataManager readNewsSectionsyByDic:newsDic];
                                           }
                                       
                                           [self.tableNews reloadData];
                                           [self doneLoadingTableViewData];
                                           
                                           //如果是第一页 则缓存下来
                                           if (newsAry.count <= newsPageSize) {
                                               [DataManager saveCache:5 andID:self.catalog andString:operation.responseString];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([Config Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       [self.tableNews reloadData];
                                       if ([Config Instance].isNetworkRunning) {
                                           [Config ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
        isLoading = YES;//显示正在加载
        //[self.tableNews reloadData];
    }
    //如果没有网络连接
    else
    {
        NSString *value = [DataManager getCache:5 andID:self.catalog];
        if (value)
        {
            
            NSMutableDictionary *newNewsDic = [DataManager readNewsDic:value andOld:newsDic];
            NSMutableArray *newNews=[DataManager readNewsAryByDic:newNewsDic];
            if (newNews == nil) {
                [self.tableNews reloadData];
            }
            else if(newNews.count <= 0){
                [self.tableNews reloadData];
                isLoadOver = YES;
            }
            else if(newNews.count < newsPageSize){
                isLoadOver = YES;
            }
            [newsAry addObjectsFromArray:newNews];
            [newsDic addEntriesFromDictionary:newNewsDic];
            sectionNames = [DataManager readNewsSectionsyByDic:newsDic];
            [self.tableNews reloadData];
            
            [self doneLoadingTableViewData];
        }
       
//        NSString *value = [DataManager getCache:5 andID:self.catalog];
//        if (value) {
//            NSMutableDictionary *newNewsDic = [DataManager readNewsDic:value andOld:newsDic];
//            [self.tableNews reloadData];
//            isLoadOver = YES;
//            [newsDic addEntriesFromDictionary:newNewsDic];
//            
//            sectionNames = [DataManager readNewsSectionsyByDic:newsDic];
//            
//             isLoading = NO;
//            [self.tableNews reloadData];
//            [self doneLoadingTableViewData];
//        }
    }
}

#pragma TableView的处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [sectionNames count];
    
}
//- (NSString *)tableView:(UITableView *)tableView
//
//titleForHeaderInSection:(NSInteger)section {
//    
//    NSString *sectionName = [sectionNames objectAtIndex:section];
//    
//    return sectionName;
//    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 34)] autorelease];
    NSString *sectionName = [sectionNames objectAtIndex:section];
    
    UIImageView* view = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datebar_02.png"]]autorelease];
    view.frame=CGRectMake(0, 0, self.tableNews.frame.size.width, 24);
     [sectionView addSubview:view];
    UIView* segview = [[[UIView alloc]initWithFrame:CGRectMake(0, 24, self.tableNews.frame.size.width, 10)]autorelease];
    segview.backgroundColor=[UIColor clearColor];
    
    [sectionView addSubview:segview];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 320, 24)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    headerLabel.textColor = [UIColor colorWithHexString:@"838383"];
    
    headerLabel.text = sectionName;
    
    [sectionView addSubview:headerLabel];
    
    [headerLabel release];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [sectionNames objectAtIndex:section];
     NSMutableArray *ary = [newsDic objectForKey:sectionName];
    
    if ([Config Instance].isNetworkRunning) {
        if (isLoadOver) {
            return ary.count == 0 ? 1 : ary.count;
        }
        else{
            
            if(sectionNames.count==0||section==sectionNames.count-1){
                return ary.count + 1;
            }
             
            
        }
            
           
    }
    
        return ary.count;
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSUInteger section = [indexPath section];
    NSString *sectionName = [sectionNames objectAtIndex:section];
    NSMutableArray *ary = [newsDic objectForKey:sectionName];
    
    if (indexPath.row<ary.count) {
        return [NewsTableViewCell heightForCellWithNews:[ary objectAtIndex:indexPath.row]];
    }else{
        return 61;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [Tool getCellBackgroundColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     //static NSString *NewsTableViewCellIdentifier =@"NewsTableViewCellIdentifier";
    NSString *NewsTableViewCellIdentifier = [NSString stringWithFormat:@"NewsTableViewCellIdentifier%d%d", [indexPath section], [indexPath row]];
    NSUInteger section = [indexPath section];
    NSString *sectionName = [sectionNames objectAtIndex:section];
    NSMutableArray *ary = [newsDic objectForKey:sectionName];
    if ([ary count] > 0) {
        if ([indexPath row] < [ary count])
        {
            NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsTableViewCellIdentifier];
            
            if (!cell) {
//                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
//                for (NSObject *o in objects) {
//                    if ([o isKindOfClass:[NewsTableViewCell class]]) {
//                        cell = (NewsTableViewCell *)o;
//                        break;
//                    }
//                }
                cell = [[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsTableViewCellIdentifier]autorelease];
                //cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil]lastObject];
            }
           // cell.lblTitle.font = [UIFont boldSystemFontOfSize:15.0];
            
            
            cell.news = [ary objectAtIndex:indexPath.row];

            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部新闻" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部新闻" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //文字变灰，证明读过
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor=[UIColor grayColor];
    
 
    
    NSUInteger section = [indexPath section];
    NSString *sectionName = [sectionNames objectAtIndex:section];
    NSMutableArray *ary = [newsDic objectForKey:sectionName];
    int row = [indexPath row];
    if (row >= [ary count]) {
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else {
        
        
        //if (self.catalog == 1) {
            News *n = [ary objectAtIndex:row];
            if (n)
            {
                
                NewsWebViewController *newsDetailViewController = [[[NewsWebViewController alloc] initWithNibName:@"NewsWebViewController" bundle:nil] autorelease];
                
                newsDetailViewController.news = n;
                [self.navigationController pushViewController:newsDetailViewController animated:YES];
                           }
       // }
        
    }
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableNews];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
   
    [self refresh];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    
  
    
    
    [Config Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    if ([Config Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
    //无网络连接则读取缓存
    else {
        NSString *value = [DataManager getCache:5 andID:self.catalog];
        if (value) 
        {
            
             NSMutableDictionary *newNewsDic = [DataManager readNewsDic:value andOld:newsDic];
            NSMutableArray *newNews=[DataManager readNewsAryByDic:newNewsDic];
            if (newNews == nil) {
                [self.tableNews reloadData];
            }
            else if(newNews.count <= 0){
                [self.tableNews reloadData];
                isLoadOver = YES;
            }
            else if(newNews.count < newsPageSize){
                isLoadOver = YES;
            }
            
            if(newNews&&newNews.count > 0){
                [newsAry addObjectsFromArray:newNews];
                [newsDic addEntriesFromDictionary:newNewsDic];
            }
          
            sectionNames = [DataManager readNewsSectionsyByDic:newsDic];
            [self.tableNews reloadData];
            [Config ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
            
            //[self doneLoadingTableViewData];
           [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
        }
        
    }


}


@end
