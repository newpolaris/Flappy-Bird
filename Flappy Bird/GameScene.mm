//
//  GameScence.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "GetReady.h"
#import "HudLayer.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "ResultLayer.h"

enum eSceneOrder
{
    kBackgroundLayer = 0,
    kGroundLayer,
    kGameLayer,
    kHudLayer,
    kResultLayer,
    kGetReadyLayer,
};

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        
        // Background 레이어 추가하기
        [self addChild:[BackgroundLayer node] z:kBackgroundLayer];
        
        // HUD 레이어 추가하기
        HudLayer *hudLayer = [HudLayer node];
        [self addChild:hudLayer z:kHudLayer];
        
        // Result 레이어 추가하기
        ResultLayer *resultLayer = [ResultLayer node];
        [self addChild:resultLayer z:kResultLayer];
        
        // Game 레이어 추가하기
        GameLayer *gameLayer = [GameLayer node];
        [self addChild:gameLayer z:kGameLayer];
        
        // 게임 레이어의 HUD에 HUD레이어 전달
        gameLayer.hud = hudLayer;
        // 게임 레이어의 result 에 Result 레이어의 포인터 전달.
        gameLayer.result = resultLayer;
        
        GetReady *ready = [GetReady node];
        [self addChild:ready z:kGetReadyLayer];
        
        // GetReady 레이어에 GameLayer
        ready.gameLayer = gameLayer;
        
        resultLayer.groundHeight = gameLayer.ground.height;
    }
    return self;
}


@end
