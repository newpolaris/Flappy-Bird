//
//  GameScence.h
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;
@class HUDLayer;

@interface GameScene : CCScene

@property (nonatomic, weak) GameLayer *gameLayer;
@property (nonatomic, weak) HUDLayer *hudLayer;

@end
