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
    
    static const int gap = 160;
    CCSprite *pipeUp   = [CCSprite spriteWithSpriteFrameName:@"pipe_up.png"];
    CCSprite *pipeDown = [CCSprite spriteWithSpriteFrameName:@"pipe_down.png"];
    
    pipeUp.position   = ccp(0, -gap*gScale);
    pipeDown.position = ccp(0, +gap*gScale);
    
    [self addChild:pipeDown];
    [self addChild:pipeUp];
    
    [self setWidth:pipeUp.contentSize.width*gScale];
    
    [self setScale:gScale];
    
    return self;
}

@end
