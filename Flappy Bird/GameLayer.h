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

@interface GameLayer: CCLayer
{
    CCArray *pipeArray; // 3개의 Pipe 쌍을 돌아가면서 사용.
}

@property (nonatomic, weak) Bird* bird;
@property (nonatomic, weak) CCSprite* readyLabel;
@property (nonatomic, weak) CCSprite* tutorialLabel;
@property (nonatomic, weak) GroundLayer *groundLayer;
@property (nonatomic) BOOL play;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) int screenSpeed;
@property (nonatomic) int delayPipeStart;
@property (nonatomic) int pipeGap;
@property (nonatomic) int score;
@property (nonatomic) int gone;

@property (nonatomic) int birdHeight;
@property (nonatomic) float velocity;
@property (nonatomic) float impactTime;

-(void)collisionWithObject;

@end
