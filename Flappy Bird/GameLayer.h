//
//  Ready.h
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Bird;

@interface GameLayer: CCLayer

@property (nonatomic, weak) Bird* bird;
@property (nonatomic, weak) CCSprite* readyLabel;
@property (nonatomic, weak) CCSprite* tutorialLabel;
@property (nonatomic) int screenSpeed;

@property (nonatomic) int birdHeight;
@property (nonatomic) float velocity;
@property (nonatomic) float impactTime;

@end
