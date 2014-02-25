//
//  Title.m
//  Flappy Bird
//
//  Created by newpolaris on 2/24/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Title.h"
#import "Bird.h"
#import "GlobalVariable.h"

@implementation Title

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    // window size get!
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite* titleName = [CCSprite spriteWithSpriteFrameName:@"title.png"];
    // 왼쪽에 Gap만 더하게 만들기 위해
    titleName.anchorPoint = ccp(0, 0.5);
    [titleName setScale:gScale];
    
    CCSprite* bird = [Bird node];
    bird.anchorPoint = ccp(0, 0.5);
    bird.scale = gScale;
    
    float xGap = (winSize.width
                  - [bird boundingBox].size.width
                  - [titleName boundingBox].size.width) / 3;
    
    titleName.position = ccp(xGap, 0);
    bird.position = ccp(xGap+[titleName boundingBox].size.width+xGap, 0);
    
    [self addChild:bird];
    [self addChild:titleName];
    
    CCAction *moveUpward = [CCMoveBy actionWithDuration:0.7 position:ccp(0, gScale*5)];
    CCAction *moveDownward = [CCMoveBy actionWithDuration:0.7 position:ccp(0, -gScale*5)];
    CCAction *sequenceAction = [CCSequence actions: moveUpward, moveDownward, nil];

    [self runAction:[CCRepeatForever actionWithAction:sequenceAction]];
                     
    
    return self;
}

@end
