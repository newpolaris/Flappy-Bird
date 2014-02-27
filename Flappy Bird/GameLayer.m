//
//  Ready.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GameLayer.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "Bird.h"

@implementation GameLayer

enum {
    kBackground = 0,
    kPipe,
    kGround,
};

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[BackgroundLayer node] z:kBackground];
    
    GroundLayer *groundLayer = [GroundLayer node];
    [self addChild:groundLayer z:kGround];
    [self setScreenSpeed:groundLayer.moveSpeed];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self setBird:[Bird node]];
    [self setBirdHeight:winSize.height/2];
    _bird.position = ccp(winSize.width*0.3, _birdHeight);
    
    [self addChild:_bird];
    
    [self setTutorialLabel:[CCSprite spriteWithSpriteFrameName:@"tutorial.png"]];
    _tutorialLabel.anchorPoint = ccp(0, 0.5);
    _tutorialLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_tutorialLabel];
    
    [self setReadyLabel:[CCSprite spriteWithSpriteFrameName:@"get_ready.png"]];
    _readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:_readyLabel];
    
    _impactTime = 0;
    
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    static const float flyUp = 20;
    
    [self removeChild:_tutorialLabel];
    [self removeChild:_readyLabel];
    
    _impactTime = 4;
    // 더하는 것 보다 이게 튀는 효과로 바꿔주는 역활을 수행함.
    _velocity = flyUp;
    
    return YES;
}

- (void)onEnter {
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
    
    // 배경 움직임과 충돌을 체크할 때 사용하는 메인 스케쥴?
    [self scheduleUpdate];
    
    // 점수를 위한 스케쥴
    [self schedule:@selector(updateBirdPosition:) interval:0.01f];
    
    // 점수를 위한 스케쥴
    // [self schedule:@selector(updateScore:) interval:0.01f];
    
    // 시작 되면 배경 백그라운드 음악이 재생
    // [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3" loop:YES];
}

-(void)update:(ccTime)dt
{
}

-(void)updateBirdPosition:(ccTime)dt
{
    static const float gravity = -98*12;
    
    if (_impactTime > 0)
    {
        // 속도 가속도 보다 이게 통통 튀는 느낌을 주는 듯.
        _birdHeight += dt*300;
        _impactTime -= dt;
    }
    
    _birdHeight += _velocity * dt;
    _velocity += gravity * dt;
    
    _bird.position = ccp(_bird.position.x, _birdHeight);
}

@end
