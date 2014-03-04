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

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        // HUD 레이어 추가하기
        // _hudLayer = [HUDLayer node];
        // [self addChild:_hudLayer z:1];
        // Game 레이어 추가하기
        _gameLayer = [GameLayer node];
        [self addChild:_gameLayer z:0];
        
        // 게임 레이어의 HUD에 HUD레이어 전달
        // self.gameLayer.hud = _hudLayer;
        
        [self addChild:[GetReady node]];
    }
    return self;
}

@end
