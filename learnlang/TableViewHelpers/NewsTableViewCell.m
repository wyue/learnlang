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

#define SizeOfTitleText 14.0f


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
    [whiteRoundedCornerView release];
    [super dealloc];
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
//    UIImageView *backgroundImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder.png"]]autorelease];
//    backgroundImgView.frame=CGRectMake(7, 0, self.frame.size.width-14,  self.frame.size.height-6);
//     [self.contentView addSubview:backgroundImgView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(8,7,self.frame.size.width-16,self.frame.size.height-7)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 2.0;
    // whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    // whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    whiteRoundedCornerView.layer.borderColor = [UIColor colorWithHexString:@"D0D0D0"].CGColor;
    whiteRoundedCornerView.layer.borderWidth = 1;
    [self.contentView addSubview:whiteRoundedCornerView];
    [self.contentView sendSubviewToBack:whiteRoundedCornerView];
    
       
   
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.0f, 5.0f, 240, 30.0f)];
   titleLabel.font = [UIFont systemFontOfSize:SizeOfTitleText];
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
   
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines =0;
    [self.contentView addSubview:titleLabel];
    
     clickCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.0f, 46.0f, 43.0f, 10.0f)];
    clickCountLabel.font = [UIFont systemFontOfSize:11.0f];
    clickCountLabel.numberOfLines = 0;
    clickCountLabel.textColor = [UIColor colorWithHexString:@"AE8359"];
    
    [self.contentView addSubview:clickCountLabel];
    
   
    saveCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(58.0f, 46.0f, 43.0f, 10.0f)];
    saveCountLabel.font = [UIFont systemFontOfSize:11.0f];
    saveCountLabel.numberOfLines = 0;
    saveCountLabel.textColor = [UIColor colorWithHexString:@"AE8359"];
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
- (float) heightForLabel:(UILabel *)label
{
    [label setNumberOfLines:0];
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 20000)];
    [label sizeToFit];
    return label.frame.size.height;
}
- (void)setNews:(News *)news {
    _news = news;
    
    titleLabel.text = _news.title;
    clickCountLabel.text = [NSString stringWithFormat:@"%d阅读",_news.clickCount];
    saveCountLabel.text = [NSString stringWithFormat:@"|  %d收藏",_news.saveCount];
    //[self.imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
     float w = 240;
   
    if (_news.imgUrl) {
        if (imageView==nil) {
            imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            imageView.frame = CGRectMake(self.frame.size.width-8-5-kNewsTableImageWidth, 4.5, kNewsTableImageWidth, kNewsTableImageHeight);
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
      
    }else{
         w=288;
        titleLabel.frame = CGRectMake(16.0f, 5.0f, 288, 30.0f);
    }
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, [NewsTableViewCell heightForLabelWithString:news.title  andWidth:w]);
   
    
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
    float w = 240;
    if (!news.imgBigUrl) {
        w=288;
    }
    
    float sizeToFit = [self heightForLabelWithString:news.title  andWidth:w];
    
    
//    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(w, 20000) lineBreakMode:UILineBreakModeWordWrap];
    if (sizeToFit>30) {
        return kNewsTableViewCellHeight+sizeToFit-30;

    }
//    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return kNewsTableViewCellHeight;
}

+ (CGFloat)heightForLabelWithString:(NSString *)content andWidth:(float)width{
   
    CGSize sizeToFit = [content sizeWithFont:[UIFont systemFontOfSize:SizeOfTitleText] constrainedToSize:CGSizeMake(width, 20000) lineBreakMode:UILineBreakModeWordWrap];
    if (sizeToFit.height>30) {
        return sizeToFit.height;
        
    }
    //    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return 30;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
   // self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    //CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
   // detailTextLabelFrame.size.height = [[self class] heightForCellWithNews:_news] - 45.0f;
    //self.detailTextLabel.frame = detailTextLabelFrame;
    
     
    //自适应
     
    whiteRoundedCornerView.frame=CGRectMake(8,0,self.frame.size.width-16,self.frame.size.height-7);
    

}

@end
