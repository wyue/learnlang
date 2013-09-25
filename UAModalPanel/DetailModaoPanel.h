//
//  DetailModaoPanel.h
//  learnlang
//
//  Created by mooncake on 13-9-22.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import "UATitledModalPanel.h"

@interface DetailModaoPanel : UATitledModalPanel<UITableViewDataSource> {
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
    IBOutlet UISegmentedControl	*textSettingOutlet;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl	*textSettingOutlet;
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)textSettingAction:(id)sender;


@end
