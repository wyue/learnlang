//
//  NewsTableViewCell.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "News.h"
#import "EGOImageView.h"
#import "UIImageView+AFNetworking.h"

//tableview 固定参数


#define kNewsTableImageHeight 52.5
#define kNewsTableImageWidth 52.5


@implementation NewsTableViewCell{
@private
__strong News *_news;
}

@synthesize news = _news;

- (void)dealloc {
	[imageView release];
    [clickCountLabel release];
    [titleLabel release];
    [saveCountLabel release];
    [super dealloc];
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    UIImageView *backgroundImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder.png"]]autorelease];
    backgroundImgView.frame=CGRectMake(7, 0, self.frame.size.width-14,  self.frame.size.height-6);
     [self.contentView addSubview:backgroundImgView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 8.0f, 233, 30.0f)];
   titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:titleLabel];
    
     clickCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.0f, 45.0f, 40.0f, 9.0f)];
    clickCountLabel.font = [UIFont systemFontOfSize:11.0f];
    clickCountLabel.numberOfLines = 0;
    
    [self.contentView addSubview:clickCountLabel];
    
   
    saveCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(63.0f, 45.0f, 40.0f, 9.0f)];
    saveCountLabel.font = [UIFont systemFontOfSize:11.0f];
    saveCountLabel.numberOfLines = 0;
    
    [self.contentView addSubview:saveCountLabel];
    
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[imageView cancelImageLoad];
	}
}

- (void)setNews:(News *)news {
    _news = news;
    
    titleLabel.text = _news.title;
    clickCountLabel.text = [NSString stringWithFormat:@"%d",_news.clickCount];
    saveCountLabel.text = [NSString stringWithFormat:@"%d",_news.saveCount];
    //[self.imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
   
    if (_news.imgUrl) {
        if (imageView==nil) {
            imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            imageView.frame = CGRectMake(self.frame.size.width-60, 10.0f, kNewsTableImageWidth, kNewsTableImageHeight);
            [self.contentView addSubview:imageView];
        }
        
        
        if (!imageView.imageURL  ) {
            
            
            imageView.imageURL = [NSURL URLWithString:_news.imgUrl];
        }
        else{
            
            if(_news.imgUrl&&![[imageView.imageURL absoluteString] isEqualToString:_news.imgUrl]){
                imageView.imageURL = [NSURL URLWithString:_news.imgUrl];
            }
            
        }
      
    }
    
   
    
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
//    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
//    
//    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return kNewsTableViewCellHeight;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
   // self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    //CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
   // detailTextLabelFrame.size.height = [[self class] heightForCellWithNews:_news] - 45.0f;
    //self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
