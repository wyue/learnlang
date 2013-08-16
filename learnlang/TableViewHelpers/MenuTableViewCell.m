//
//  MenuTableViewCell.m
//  learnlang
//
//  Created by mooncake on 13-7-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize imageButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, MainMenuWidth, 81);
//       imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
//        imageView.frame=self.frame;
//        [self.contentView addSubview:imageView];
        
       
        
        imageButton =[UIButton buttonWithType:UIButtonTypeCustom];
        
         [imageButton setFrame:self.frame];
        [self.contentView addSubview:imageButton];
        
    }
    return self;
}
- (void)setFlickrPhoto:(NSString*)flickrPhoto {
	imageView.imageURL = [NSURL URLWithString:flickrPhoto];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
	[imageView release];
    [imageButton retain];

    [super dealloc];
}

@end
