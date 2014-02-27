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
    [self setMoveSpeed:groundLayer.moveSpeed];
    
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
    
    return self;
}

// [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self removeChild:_tutorialLabel];
    [self removeChild:_readyLabel];
    
    return YES;
}

- (void)onEnter {
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
    
    // 배경 움직임과 충돌을 체크할 때 사용하는 메인 스케쥴
    [self scheduleUpdate];
    
    // 점수를 위한 스케쥴
    // [self schedule:@selector(updateScore:) interval:0.01f];
    
    // 시작 되면 배경 백그라운드 음악이 재생
    // [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3" loop:YES];
}

-(void)update:(ccTime)dt
{
}

@end
