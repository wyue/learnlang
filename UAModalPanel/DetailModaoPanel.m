//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "DetailModaoPanel.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation DetailModaoPanel

@synthesize viewLoadedFromXib;

@synthesize textSettingOutlet;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
		
		////////////////////////////////////
		// RANDOMLY CUSTOMIZE IT
		////////////////////////////////////
		// Show the defaults mostly, but once in awhile show a completely random funky one
		// Margin between edge of container frame and panel. Default = {20.0, 20.0, 20.0, 20.0}
        self.margin = UIEdgeInsetsMake(120.0, 20.0, 150.0, 20.0);//上，左，下，右
        
        // Padding between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor clearColor];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 1.5f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 4.0f;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor whiteColor];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = NO;
        
   
//        // Height of the title view. Default = 40.0f
        self.titleBarHeight = 0.0f;
//        
//        // The background color gradient of the title
//        // colors[8] = {0, 1, 1, 1, 1, 1, 0, 1};
//        [self.titleBar setColorComponents:colors];
//        
//        // The header label, a UILabel with the same frame as the titleBar
//        self.headerLabel.font = [UIFont boldSystemFontOfSize:16];
//        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = Linear
//        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleCenterHighlight];
//        
//        // The line mode of the gradient view (top, bottom, both, none)
//        [[self titleBar] setLineMode:UAGradientLineModeNone];
//        
//        // The noise layer opacity
//        [[self titleBar] setNoiseOpacity:0.3];
        
		//////////////////////////////////////
		// SETUP RANDOM CONTENT
		//////////////////////////////////////
//		UIWebView *wv = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
//		[wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://urbanapps.com/product_list"]]];
		
//		UITableView *tv = [[[UITableView alloc] initWithFrame:CGRectZero] autorelease];
//		[tv setDataSource:self];
		
//		UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//		[iv setImage:[UIImage imageNamed:@"UrbanApps.png"]];
//		[iv setContentMode:UIViewContentModeScaleAspectFit];
		
		[[NSBundle mainBundle] loadNibNamed:@"DetailModalSizeView" owner:self options:nil];
        
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        
        
        if ([setting objectForKey:kUserSettingForTextSize]) {
            if ([[setting objectForKey:kUserSettingForTextSize] isEqualToString:TextSizeForSmall]) {
                self.textSettingOutlet.selectedSegmentIndex=0;
                
            }else if ([[setting objectForKey:kUserSettingForTextSize] isEqualToString:TextSizeForLarge]) {
                self.textSettingOutlet.selectedSegmentIndex=2;
                
            }else {
                self.textSettingOutlet.selectedSegmentIndex=1;
                
            }
        }
        
        
        
		
        v=viewLoadedFromXib;
		
		[self.contentView addSubview:v];
		
	}
	return self;
}

- (void)dealloc {
    [v release];
	[viewLoadedFromXib release];
    [textSettingOutlet release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[v setFrame:self.contentView.bounds];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	
	[cell.textLabel setText:[NSString stringWithFormat:@"Row %d", indexPath.row]];
	
	return cell;
}

#pragma mark - Actions
- (IBAction)buttonPressed:(id)sender {
	// The button was pressed. Lets do something with it.
	
	// Maybe the delegate wants something to do with it...
	if ([delegate respondsToSelector:@selector(superAwesomeButtonPressed:)]) {
		[delegate performSelector:@selector(superAwesomeButtonPressed:) withObject:sender];
        
        // Or perhaps someone is listening for notifications
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SuperAwesomeButtonPressed" object:sender];
	}
    
	NSLog(@"Super Awesome Button pressed!");
}

-(IBAction)textSettingAction:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger Index = segmentedControl.selectedSegmentIndex;
    
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    
    // NSString* set =[setting objectForKey:kUserSettingForTextSize];
    NSString* size = TextSizeForMiddle;
    
    switch (Index) {
            
        case 0:
            
            size=TextSizeForSmall;
            
            break;
            
        case 1:
            
            size=TextSizeForMiddle;
            
            break;
            
        case 2:
            
            size=TextSizeForLarge;
            
            break;
            
            
            
            
            
        default:
            
            break;
            
            
    }
    [setting setObject:size forKey:kUserSettingForTextSize];
    [setting synchronize];
    
}

@end
