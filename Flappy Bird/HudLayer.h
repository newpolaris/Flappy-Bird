//
//  HudLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 3/6/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HudLayer : CCLayer
{
    CCLabelBMFont *scoreLabel;
}

@property (nonatomic, weak) CCMenuItem *resumeMenu;
@property (nonatomic, weak) CCMenuItem *pauseMenu;

- (void)scoreRenew:(int)score;

@end
