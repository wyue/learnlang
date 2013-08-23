//
//  SavedCell.h
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AMProgressView.h"
#import "News.h"

@interface SavedCell : UITableViewCell{
@private
    
    UILabel * titleLabel;
    UILabel* clickCountLabel;
    AMProgressView *progressView;
    //PDColoredProgressView *_downloadProgress;
    
    UIImageView *backImageView;
    
    UIButton* extButton;
    //批量删除
	UIImageView*	m_checkImageView;
	BOOL			m_checked;
}
//@property (retain, nonatomic) IBOutlet PDColoredProgressView *downloadProgress;
@property (nonatomic, strong) News *news;
+ (CGFloat)heightForCellWithNews:(News *)news;

- (void) setChecked:(BOOL)checked;//批量删除
- (BOOL) getChecked;//批量删除

@property (nonatomic,retain)UIButton* extButton;

@end
