//
//  Pipe.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Pipe.h"
#import "GlobalVariable.h"

@implementation Pipe

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    int height = [[CCDirector sharedDirector] winSize].height;
    
    CCSprite *pipeUp   = [CCSprite spriteWithSpriteFrameName:@"pipe_up.png"];
    CCSprite *pipeDown = [CCSprite spriteWithSpriteFrameName:@"pipe_down.png"];
    
    pipeUp.anchorPoint = ccp(0.5, 1);
    pipeDown.anchorPoint = ccp(0.5, 0);
    
    int gap = height / gScale / 8;
    
    pipeUp.position   = ccp(0, -gap);
    pipeDown.position = ccp(0, +gap);
    
    [self addChild:pipeDown];
    [self addChild:pipeUp];
    
    [self setWidth:pipeUp.contentSize.width*gScale];
    
    [self setScale:gScale];
    
    return self;
}

- (void)createBox2dObject:(b2World *)world
{
    b2BodyDef pipe1BodyDef;
    pipe1BodyDef.type = b2_dynamicBody;
    pipe1BodyDef.position.Set(self.position.x/PTM_RATIO,
                              self.position.y/PTM_RATIO);
    
    pipe1BodyDef.userData = (__bridge void*)self;
    pipe1BodyDef.fixedRotation = true;
    
    _bodyDown = world->CreateBody(&pipe1BodyDef);
    
    b2BodyDef pipe2BodyDef;
    pipe2BodyDef.type = b2_dynamicBody;
    pipe2BodyDef.position.Set(self.position.x/PTM_RATIO,
                              self.position.y/PTM_RATIO);
    
    pipe2BodyDef.userData = (__bridge void*)self;
    pipe2BodyDef.fixedRotation = true;
    
    _bodyUp = world->CreateBody(&pipe2BodyDef);
}
@end
