//
//  MainNavigationViewController.h
//  learnlang
//
//  Created by mooncake on 13-7-30.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"

@interface MainNavigationViewController : UINavigationController<PopoverViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    PopoverView *pv;
    
   
    CGPoint point;
}
- (void)toggleMenu;
@end
