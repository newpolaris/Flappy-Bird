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
    
    _pipeUp   = [CCSprite spriteWithSpriteFrameName:@"pipe_up.png"];
    _pipeDown = [CCSprite spriteWithSpriteFrameName:@"pipe_down.png"];
    _pipeUp.scale = gScale;
    _pipeDown.scale = gScale;
    
    _pipeUp.anchorPoint = ccp(0.5, 1);
    _pipeDown.anchorPoint = ccp(0.5, 0);
    
    int gap = height / 8;
    
    _pipeUp.position   = ccp(0, -gap);
    _pipeDown.position = ccp(0, +gap);
    
    [self addChild:_pipeDown];
    [self addChild:_pipeUp];
    
    [self setWidth:_pipeUp.contentSize.width*gScale];
    
    return self;
}

@end
