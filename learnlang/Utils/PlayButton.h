//
//  PlayButton.h
//  learnlang
//
//  Created by mooncake on 13-8-8.
//  Copyright (c) 2013年 ciic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface PlayButton : UIButton
{
    FileModel *fileModel;
}
@property(nonatomic,retain)FileModel *fileModel;

@end
