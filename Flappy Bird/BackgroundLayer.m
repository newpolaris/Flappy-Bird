//
//  Background.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "BackgroundLayer.h"
#import "GlobalVariable.h"


@implementation BackgroundLayer

-(id)init
{
    self = [super init];
    if (!self) return(nil);
    
    // 전체 백그라운드를 설정한다.
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
    background.anchorPoint = CGPointZero;
    
    // window size get
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float scale = winSize.width/background.contentSize.width;
    
    // 으아아 전역 변수를 쓰고 말았어 으아아
    gScale = scale;
    
    // 가로 화면에 맞춰서 늘린다.
    background.scale = gScale;
    
    [self addChild:background];
    
    return self;
}

@end
