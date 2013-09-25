//
//  NewsTableViewCell.h
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class EGOImageView;
@class News;

@interface NewsTableViewCell : UITableViewCell{
@private
IBOutlet UIImageView* imageView;
 IBOutlet   UILabel * titleLabel;
 IBOutlet   UILabel* clickCountLabel;
    IBOutlet   UILabel* saveCountLabel;
    UIView *whiteRoundedCornerView;
    
}
@property (nonatomic, retain)   UILabel * titleLabel;

@property (nonatomic, strong) News *news;
+ (CGFloat)heightForCellWithNews:(News *)news;
+ (CGFloat)heightForLabelWithString:(NSString *)content andWidth:(float)width;
@end
