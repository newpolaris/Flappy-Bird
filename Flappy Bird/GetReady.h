//
//  GetReady.h
//  Flappy Bird
//
//  Created by newpolaris on 3/5/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface GetReady : CCLayer;

@property (nonatomic, weak) GameLayer *gameLayer;
@property (nonatomic, weak) CCSprite *readyLabel;
@property (nonatomic, weak) CCSprite *tutorialLabel;

@end
