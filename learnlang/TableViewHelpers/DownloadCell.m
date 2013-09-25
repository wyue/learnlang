//
//  DownloadCell.m
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadManager.h"
#import "ASINetworkQueue.h"
#define SizeOfTitleText 14.0f
#define WidthOfTitle 250.0f

@implementation DownloadCell{
@private
    __strong News *_news;
}

@synthesize news = _news;
@synthesize extButton;
- (void)dealloc {
	[progressView release];
    [clickCountLabel release];
    [titleLabel release];
    [_downloadProgress release];
    
    [backImageView release];
    [extButton release];
    //批量删除
    [m_checkImageView release];
	m_checkImageView = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,7,self.frame.size.width-16,self.frame.size.height-7)];
        backImageView.image=[UIImage imageNamed:@"index-listbg_03.png"];
        [self.contentView addSubview:backImageView];
        
        titleLabel = [[UILabel alloc]init];
         titleLabel.font = [UIFont systemFontOfSize:SizeOfTitleText];
        //titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = [UIColor colorWithHexString:@"1E1E1E"];
        titleLabel.frame = CGRectMake(19.0f, 19.0f, WidthOfTitle, 25.0f);
        
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines =0;
        [self.contentView addSubview:titleLabel];
        
        clickCountLabel = [[UILabel alloc]init];
        clickCountLabel.font = [UIFont systemFontOfSize:11.0f];
        clickCountLabel.textColor=[UIColor colorWithHexString:@"A7A7A7"];
        clickCountLabel.numberOfLines = 1;
        clickCountLabel.frame = CGRectMake(19,38, 100.0f, 10.0f);
        [self.contentView addSubview:clickCountLabel];
        
        
        _downloadProgress = [[PDColoredProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _downloadProgress.frame= CGRectMake(8, 5, self.frame.size.width-16, 2.0f);
        [_downloadProgress setTintColor:[UIColor colorWithHexString:@"E30000"]];
        [self.contentView addSubview:_downloadProgress];
        
        extButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        extButton.layer.borderWidth=1;
        extButton.layer.borderColor=[UIColor colorWithHexString:@"D0D0D0"].CGColor;
        
        [extButton setImage:[[UIImage imageNamed:@"myaudio_20.png"] resizedImageToSize:CGSizeMake(11.5, 5.5)] forState:UIControlStateNormal];
        extButton.frame=CGRectMake(backImageView.frame.origin.x+ backImageView.frame.size.width-40,backImageView.frame.origin.y, 40, backImageView.frame.size.height);
        [self.contentView addSubview:extButton];

        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
       
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
    //clickCountLabel.text = [NSString stringWithFormat:@"%d",_news.clickCount];
     clickCountLabel.text = [NSString stringWithFormat:@"%@",@"正在下载"];
    //[self.imageView setImageWithURL:[NSURL URLWithString:_news.imgUrl] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
  
        
  NSMutableDictionary* downinglist=  [DownloadManager Instance].downinglist;
//    if (downinglist&&[downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]]) {
//      ASINetworkQueue	*networkQueue =   [downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]];
//        [networkQueue setUploadProgressDelegate:_downloadProgress];
//    }
    if (downinglist&&[downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]]) {
        ASIHTTPRequest	*request =   [downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]];
        [request setDownloadProgressDelegate:_downloadProgress];
    }

    
    if([[DownloadManager Instance] isDownloaded:news]){
        
        
        //[[DownloadsManager Instance] removeFile:news isDownloading:FALSE];
     
        if (downinglist==nil||(downinglist&&![downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]])){
            clickCountLabel.text =[NSString stringWithFormat:@"%@",@"已下载完毕" ];
        
    }else{
        
        if (downinglist&&![downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]]) {
            [[DownloadManager Instance] beginRequest:news isBeginDown:YES];
        }
        
    }
    }
    
    
 
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, [DownloadCell heightForLabelWithString:titleLabel.text  andWidth:WidthOfTitle]);
   
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
    float w = WidthOfTitle;
   
    
    float sizeToFit = [self heightForLabelWithString:news.title  andWidth:w];
    
    
    //    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(w, 20000) lineBreakMode:UILineBreakModeWordWrap];
    if (sizeToFit>25) {
        return kDownloadTableViewCellHeight+sizeToFit-25;
        
    }
    //    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return kDownloadTableViewCellHeight;
}


+ (CGFloat)heightForLabelWithString:(NSString *)content andWidth:(float)width{
    
    CGSize sizeToFit = [content sizeWithFont:[UIFont systemFontOfSize:SizeOfTitleText] constrainedToSize:CGSizeMake(width, 20000) lineBreakMode:UILineBreakModeWordWrap];
    if (sizeToFit.height>25) {
        return sizeToFit.height;
        
    }
    //    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return 25;
}

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
//	if (self.editing == editting)
//	{
//		return;
//	}
	
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[[UIView alloc] init] autorelease];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"mydownload_06.png"] resizedImageToSize:CGSizeMake(19.5, 19.5)]];
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [[UIImage imageNamed:@"mydownload_03.png"] resizedImageToSize:CGSizeMake(19.5, 19.5)];//Selected.png
		//self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	else
	{
		m_checkImageView.image = [[UIImage imageNamed:@"mydownload_06.png"] resizedImageToSize:CGSizeMake(19.5, 19.5)];//Unselected.png
		self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	m_checked = checked;
}


- (BOOL) getChecked
{
	
	return m_checked ;
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
    
    backImageView.frame=CGRectMake(8,7,self.frame.size.width-16,self.frame.size.height-7);
    
    clickCountLabel.frame=CGRectMake(19,self.frame.size.height-22, 100.0f, 10.0f);
    extButton.frame=CGRectMake(backImageView.frame.origin.x+ backImageView.frame.size.width-40,backImageView.frame.origin.y, 40, backImageView.frame.size.height);
}








@end
