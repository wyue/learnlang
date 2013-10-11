//
//  NewsTableViewCell.m
//  learnlang
//
//  Created by mooncake on 13-7-23.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "News.h"

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
@synthesize titleLabel;

- (void)dealloc {
	[imageView release];
    [clickCountLabel release];
    [titleLabel release];
    [saveCountLabel release];
    [whiteRoundedCornerView release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    if (selected==YES) {
//         self.titleLabel.textColor=[UIColor grayColor];
//    }
   
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
    
       
   
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28.0f+kNewsTableImageWidth, 7.0f, 230, 30.0f)];//w:240
   titleLabel.font = [UIFont systemFontOfSize:SizeOfTitleText];
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
   
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines =0;
    [self.contentView addSubview:titleLabel];
    
     clickCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(28.0f+kNewsTableImageWidth, 50.0f, 50.0f, 10.0f)];
    clickCountLabel.font = [UIFont systemFontOfSize:11.0f];
    clickCountLabel.numberOfLines = 0;
    clickCountLabel.textColor = [UIColor colorWithHexString:@"AE8359"];
    
    [self.contentView addSubview:clickCountLabel];
    
   
    saveCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(77.0f+kNewsTableImageWidth, 50.0f, 53.0f, 10.0f)];
    saveCountLabel.font = [UIFont systemFontOfSize:11.0f];
    saveCountLabel.numberOfLines = 0;
    saveCountLabel.textColor = [UIColor colorWithHexString:@"AE8359"];
    //[self.contentView addSubview:saveCountLabel];//20131010去掉收藏的显示
    
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return self;
}
//- (void)willMoveToSuperview:(UIView *)newSuperview {
//	[super willMoveToSuperview:newSuperview];
//	
//	if(!newSuperview) {
//		[imageView cancelImageLoad];
//	}
//}
- (float) heightForLabel:(UILabel *)label
{
    [label setNumberOfLines:0];
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 20000)];
    [label sizeToFit];
    return label.frame.size.height;
}
- (void)setNews:(News *)news {
    _news = news;
    
    titleLabel.text = [NSString stringWithFormat:@"%@\n%@",_news.title,_news.subTitle];
    clickCountLabel.text = [NSString stringWithFormat:@"%d阅读",_news.clickCount];
    saveCountLabel.text = [NSString stringWithFormat:@"|  %d收藏",_news.saveCount];
    //[self.imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
     float w = 230;
   
    if (_news.imgUrl&&_news.imgUrl.length>0) {
        if (imageView==nil) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8+11, 10, kNewsTableImageWidth, kNewsTableImageHeight)];
            [self.contentView addSubview:imageView];
        }
        [imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
//        if (!imageView.imageURL  ) {
//            
//            
//            imageView.imageURL = [NSURL URLWithString:_news.imgUrl];
//        }
//        else{
//            
//            if(![[imageView.imageURL absoluteString] isEqualToString:_news.imgUrl]){
//                imageView.imageURL = [NSURL URLWithString:_news.imgUrl];
//            }
//            
//        }
      
    }else{
         w=288;//w:288
        titleLabel.frame = CGRectMake(18.0f, 7.0f, 288, 30.0f);
        
    }
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, [NewsTableViewCell heightForLabelWithString:titleLabel.text  andWidth:w]);
   
    
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
    float w = 230;
    if (!news.imgUrl) {
        w=288;
    }
    
   NSString* title= [NSString stringWithFormat:@"%@\n%@",news.title,news.subTitle];
    
    float sizeToFit = [self heightForLabelWithString:title  andWidth:w];
    
    
//    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(w, 20000) lineBreakMode:UILineBreakModeWordWrap];
    if (sizeToFit>30) {
        return kNewsTableViewCellHeight+sizeToFit-32;

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
    if (_news.imgUrl&&_news.imgUrl.length>0){
clickCountLabel.frame=CGRectMake(28.0f+kNewsTableImageWidth,self.frame.size.height-27, 50.0f, 10.0f);
    saveCountLabel.frame=CGRectMake(77+kNewsTableImageWidth,self.frame.size.height-27, 53.0f, 10.0f);
    }else{
        clickCountLabel.frame=CGRectMake(18.0f,self.frame.size.height-27, 50.0f, 10.0f);
        saveCountLabel.frame=CGRectMake(67,self.frame.size.height-27, 53.0f, 10.0f);
    }
}

@end
