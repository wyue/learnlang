//
//  DownloadCell.h
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMProgressView.h"
#import "News.h"

@interface DownloadCell : UITableViewCell{
@private
  
    UILabel * titleLabel;
    UILabel* clickCountLabel;
    AMProgressView *progressView;
}

@property (nonatomic, strong) News *news;
+ (CGFloat)heightForCellWithNews:(News *)news;

@end
