//
//  DownloadCell.m
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "DownloadCell.h"
#define kNewsTableViewCellHeight 100

@implementation DownloadCell{
@private
    __strong News *_news;
}

@synthesize news = _news;

- (void)dealloc {
	[progressView release];
    [clickCountLabel release];
    [titleLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        titleLabel = [[UILabel alloc]init];
        
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.frame = CGRectMake(10.0f, 0.0f, 100.0f, 25.0f);
        [self.contentView addSubview:titleLabel];
        
        clickCountLabel = [[UILabel alloc]init];
        clickCountLabel.font = [UIFont systemFontOfSize:12.0f];
        clickCountLabel.numberOfLines = 0;
        clickCountLabel.frame = CGRectMake(10.0f, 25.0f, 100.0f, 25.0f);
        [self.contentView addSubview:clickCountLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNews:(News *)news {
    _news = news;
    
    titleLabel.text = _news.title;
    clickCountLabel.text = [NSString stringWithFormat:@"%d",_news.clickCount];
    //[self.imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
  
        
        
        if(_news.voiceUrl &&![_news.voiceUrl  isEqualToString:@""]){
           
            
            
            
        }
        
    
    
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
    //    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    //
    //    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return kNewsTableViewCellHeight;
}

@end
