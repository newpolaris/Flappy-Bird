//
//  Background.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "BackgroundLayer.h"
#import "MySingleton.h"

@implementation BackgroundLayer

-(id)init
{
    self = [super init];
    if (!self) return(nil);
    
    // 전체 백그라운드를 설정한다.
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
    background.anchorPoint = ccp(0.1, 0);
    
    // 가로 화면에 맞춰서 늘린다.
    // 지진 효과를 위한 약간의 여유분. 20%
    background.scale = [MySingleton shared].scale*1.2;
    
    [self addChild:background];
    
    return self;
}

@end
