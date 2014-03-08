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

enum eSceneOrder
{
    kBackgroundLayer = 0,
    kGroundLayer,
    kGameLayer,
    kGetReadyLayer,
    kHudLayer
};

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        // HUD 레이어 추가하기
        HudLayer *hudLayer = [HudLayer node];
        [self addChild:hudLayer z:kHudLayer];
        
        // Ground 레이어 추가하기
        GroundLayer *groundLayer = [GroundLayer node];
        [self addChild:groundLayer z:kGroundLayer];
        
        [self addChild:[BackgroundLayer node] z:kBackgroundLayer];
        
        // Game 레이어 추가하기
        GameLayer *gameLayer = [GameLayer node];
        [self addChild:gameLayer z:kGameLayer];
        
        // 게임 레이어의 HUD에 HUD레이어 전달
        gameLayer.hud = hudLayer;
        
        // 게임 레이어의 HUD에 Ground레이어 전다.
        gameLayer.ground = groundLayer;
        
        GetReady *ready = [GetReady node];
        [self addChild:ready z:kGetReadyLayer];
        
        // GetReady 레이어에 GameLayer
        ready.gameLayer = gameLayer;
    }
    return self;
}


@end
