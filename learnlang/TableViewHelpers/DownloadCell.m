//
//  DownloadCell.m
//  learnlang
//
//  Created by mooncake on 13-8-2.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadsManager.h"
#import "ASINetworkQueue.h"


@implementation DownloadCell{
@private
    __strong News *_news;
}

@synthesize news = _news;

- (void)dealloc {
	[progressView release];
    [clickCountLabel release];
    [titleLabel release];
    [_downloadProgress release];
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
        
        
        _downloadProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _downloadProgress.frame= CGRectMake(0, 0, 320.0f, 5.0f);
        [self.contentView addSubview:_downloadProgress];
        
        
       
        

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
  
        
  NSMutableDictionary* downinglist=  [DownloadsManager Instance].downinglist;
//    if (downinglist&&[downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]]) {
//      ASINetworkQueue	*networkQueue =   [downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]];
//        [networkQueue setUploadProgressDelegate:_downloadProgress];
//    }
    
    if([[DownloadsManager Instance] isReDownload:news]){
        
        
        //[[DownloadsManager Instance] removeFile:news isDownloading:FALSE];
       
        
        [[DownloadsManager Instance] beginRequest:news isBeginDown:YES];
        
    }else{
          
        if (downinglist==nil||(downinglist&&![downinglist objectForKey:[NSString stringWithFormat:@"%d",news._id]])){
              titleLabel.text =[NSString stringWithFormat:@"%@       %@",titleLabel.text,@"已下载完毕" ];
    }
    }
    
    
   ASINetworkQueue* queue =    [[DownloadsManager Instance]getQueue:self.news];
    if (queue) {
        queue.downloadProgressDelegate=self.downloadProgress;
        queue.showAccurateProgress=YES;
    }
    
   
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithNews:(News *)news {
    //    CGSize sizeToFit = [news.title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    //
    //    return fmaxf(70.0f, sizeToFit.height + 45.0f);
    return kNewsTableViewCellHeight;
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
	if (self.editing == editting)
	{
		return;
	}
	
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
			m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
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
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
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
		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
		self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	m_checked = checked;
}


- (BOOL) getChecked
{
	
	return m_checked ;
}


@end
