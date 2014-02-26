//
//  Ready.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "ReadyScene.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "Bird.h"

@implementation ReadyScene

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[BackgroundLayer node] z:0];
    [self addChild:[GroundLayer node] z:1];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    Bird *bird = [Bird node];
    bird.position = ccp(winSize.width*0.3, winSize.height/2);
    [self addChild:bird];
    
    CCSprite *tutorial = [CCSprite spriteWithSpriteFrameName:@"tutorial.png"];
    tutorial.anchorPoint = ccp(0, 0.5);
    tutorial.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:tutorial];
    
    CCSprite *readyLabel = [CCSprite spriteWithSpriteFrameName:@"get_ready.png"];
    readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:readyLabel];
    
    return self;
}

@end
