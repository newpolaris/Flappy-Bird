//
//  Ground.m
//  Flappy Bird
//
//  Created by newpolaris on 2/26/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GroundLayer.h"
#import "GlobalVariable.h"

@implementation GroundLayer

-(id)init {
    self = [super init];
    if (!self) return nil;
    
    _moveSpeed = -130;
    
    // 백그라운드 앞의 땅을 설정한다.
    _ground1 = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    _ground1.anchorPoint = CGPointZero;
    
    // 가로 화면에 맞춰서 늘린다.
    [_ground1 setScale:gScale];
    
    [self addChild:_ground1];
    
    _ground2 = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    _ground2.anchorPoint = CGPointZero;
    
    // 가로 화면에 맞춰서 늘린다.
    [_ground2 setScale:gScale];
    [_ground2 setPosition:ccp([_ground1 boundingBox].size.width-10, 0)];
    
    [self addChild:_ground2];
    
    _height = [_ground2 boundingBox].size.height;
    
    return self;
}

- (void)update:(ccTime)dt {
    // 화면 움직이는 속도, 현재 위치에 이동할 위치를 ccpAdd로 더하는 방식
    CGPoint groundScrollVel = ccp(_moveSpeed, 0);
    
    // 현재 이미지1의 위치 값을 불러온다.
    CGPoint currentPos = [_ground1 position];
    
    // 1번 이미지가 스크롤 되서 사라지고, 2번 이미지가 1번 이미지의 초기 위치에 오면 최초위치로 이동
    if (currentPos.x < -[_ground1 boundingBox].size.width+10) {
        [_ground1 setPosition:CGPointZero];
        currentPos = ccp([_ground2 boundingBox].size.width-10, 0);
        [_ground2 setPosition:currentPos];
    // 현재 위치에서 groundScrollVel를 더한다.
    } else {
        _ground1.position = ccpAdd(ccpMult(groundScrollVel, dt),
                                   _ground1.position);
        _ground2.position = ccpAdd(ccpMult(groundScrollVel, dt),
                                   _ground2.position);
    }
}
- (void)onEnter {
    [super onEnter];
    [self scheduleUpdate];
}

- (void)createBox2dObject:(b2World *)world
{
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_dynamicBody;
    groundBodyDef.position.Set(self.position.x/PTM_RATIO,
                               self.position.y/PTM_RATIO);
    
    groundBodyDef.userData = (__bridge void*)self;
    groundBodyDef.fixedRotation = true;
    
    _body = world->CreateBody(&groundBodyDef);
}

@end
