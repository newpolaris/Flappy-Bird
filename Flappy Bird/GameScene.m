//
//  Ready.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GameScene.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "Bird.h"

@implementation GameScene

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
    _bird.position = ccp(winSize.width*0.3, winSize.height/2);
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

@end
