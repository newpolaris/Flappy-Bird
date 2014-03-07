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
@class GroundLayer;
@class HudLayer;

@interface GameLayer: CCLayer
{
    CCArray *pipeArray; // 3개의 Pipe 쌍을 돌아가면서 사용.
}

@property (nonatomic, weak) Bird* bird;
@property (nonatomic, weak) HudLayer *hud;
@property (nonatomic, weak) GroundLayer *groundLayer;
@property (nonatomic) BOOL play;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) int screenSpeed;
@property (nonatomic) int delayPipeStart;
@property (nonatomic) float pipeGap;
@property (nonatomic) int score;
@property (nonatomic) float gone;
@property (nonatomic) CGSize winSize;
@property (nonatomic) int  pipeUpDownGap;

@property (nonatomic) float birdHeight;
@property (nonatomic) float velocity;
@property (nonatomic) float impactTime;

- (void)activateSchedule;

@end
