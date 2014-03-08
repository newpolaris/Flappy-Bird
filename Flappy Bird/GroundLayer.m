//
//  Ground.m
//  Flappy Bird
//
//  Created by newpolaris on 2/26/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GroundLayer.h"
#import "MySingleton.h"

@implementation GroundLayer

-(id)init {
    self = [super init];
    if (!self) return nil;
    
    float scale = [MySingleton shared].scale;
    
    // 백그라운드 앞의 땅을 설정한다.
    ground1 = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    ground1.anchorPoint = ccp(0, 0.3);
    
    // 가로 화면에 맞춰서 늘린다.
    [ground1 setScale:scale];
    [self addChild:ground1];
    
    ground2 = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    ground2.anchorPoint = ccp(0, 0.3);
    
    // 가로 화면에 맞춰서 늘린다.
    [ground2 setScale:scale];
    [ground2 setPosition:ccp([ground1 boundingBox].size.width-10, 0)];
    
    [self addChild:ground2];
    
    _moveSpeed = -65*scale;
    _height = [ground2 boundingBox].size.height*0.7;
    
    return self;
}

- (void)update:(ccTime)dt {
    // 화면 움직이는 속도, 현재 위치에 이동할 위치를 ccpAdd로 더하는 방식
    CGPoint groundScrollVel = ccp(_moveSpeed, 0);
    
    // 현재 이미지1의 위치 값을 불러온다.
    CGPoint currentPos = [ground1 position];
    
    // 1번 이미지가 스크롤 되서 사라지고, 2번 이미지가 1번 이미지의 초기 위치에 오면 최초위치로 이동
    if (currentPos.x < -[ground1 boundingBox].size.width+10) {
        [ground1 setPosition:CGPointZero];
        currentPos = ccp([ground2 boundingBox].size.width-10, 0);
        [ground2 setPosition:currentPos];
    // 현재 위치에서 groundScrollVel를 더한다.
    } else {
        ground1.position = ccpAdd(ccpMult(groundScrollVel, dt),
                                   ground1.position);
        ground2.position = ccpAdd(ccpMult(groundScrollVel, dt),
                                   ground2.position);
    }
}
- (void)onEnter {
    [super onEnter];
    [self scheduleUpdate];
}

@end
