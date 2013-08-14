//
//  NewsTableViewCell.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@class News;

@interface NewsTableViewCell : UITableViewCell{
@private
IBOutlet EGOImageView* imageView;
 IBOutlet   UILabel * titleLabel;
 IBOutlet   UILabel* clickCountLabel;
    IBOutlet   UILabel* saveCountLabel;
}

@property (nonatomic, strong) News *news;
+ (CGFloat)heightForCellWithNews:(News *)news;

@end
