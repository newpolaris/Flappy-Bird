//
//  GlobalVariable.m
//  Flappy Bird
//
//  Created by newpolaris on 2/25/14.
//  Copyright (c) 2014 newpolaris. All rights reserved.
//

#import "GlobalVariable.h"
#import "cocos2d.h"

@implementation MySingleton

@synthesize scale;

static MySingleton* _shared = nil;

+(MySingleton*)shared
{
    @synchronized([MySingleton class])
    {
        if (!_shared)
            return [[self alloc] init];
        return _shared;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([MySingleton class])
    {
        _shared = [super alloc];
        return _shared;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FlappyBird.plist"];
        CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
    
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        scale = winSize.width/background.contentSize.width;
        
    }
    
    return self;
}

@end
