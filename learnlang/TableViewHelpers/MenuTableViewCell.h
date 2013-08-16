//
//  MenuTableViewCell.h
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MenuTableViewCell : UITableViewCell{
@private
    EGOImageView* imageView;
    
    UIButton *imageButton;
}
@property(nonatomic,retain) UIButton *imageButton;
@end
