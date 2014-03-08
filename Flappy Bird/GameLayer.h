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
@class ResultLayer;

enum BirdState {
    kAlive = 0,
    kGroundHit,
    kKIA
};

typedef enum BirdState BirdState;

@interface GameLayer: CCLayer
{
    CCArray *pipeArray; // 3개의 Pipe 쌍을 돌아가면서 사용.
    CGSize winSize;
    float gScale;
    float groundHeight;
    BirdState state;
}

@property (nonatomic, weak) HudLayer *hud;  // Hud layer의 포인터.
@property (nonatomic, weak) GroundLayer *ground; // Ground layer의 포인터.
@property (nonatomic, weak) ResultLayer *result; // Result layer의 포인터.

@property (nonatomic, weak) Bird* bird;

@property (nonatomic) int delayPipeStart;   // 최초 파이프가 화면 왼쪽으로 사라지기 까지의 거리
@property (nonatomic) float pipeGap; // 가로 파이프 간의 거리
@property (nonatomic) int score;     // 점수
@property (nonatomic) float gone;    // 진행 거리.
@property (nonatomic) int  pipeUpDownGap; // 파이프 간의 간격
@property (nonatomic) float birdHeight; // 새 높이
@property (nonatomic) float velocity;   // 올라가거나 떨어지는 속도

- (void)activateSchedule;

@end
