//
//  Bird.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Bird.h"
#import "CCAnimation.h"
#import "GlobalVariable.h"

@implementation Bird

- (id)init {
    self = [super initWithSpriteFrameName:@"bird_normal.png"];
    if (!self) return nil;
    
    NSArray *birdSpriteNames = [NSArray arrayWithObjects:
                               @"bird_normal.png",
                               @"bird_up_0.png",
                               @"bird_up_1.png",
                               nil];
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (id object in birdSpriteNames)
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                          spriteFrameByName:object]];
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:0.09];
    
    [self runAction:[CCRepeatForever actionWithAction
                     :[CCAnimate actionWithAnimation:animation]]];
    
    [self setScale:gScale];
    return self;
}

- (void)createBox2dObject:(b2World *)world
{
    b2BodyDef birdBodyDef;
    birdBodyDef.type = b2_dynamicBody;
    birdBodyDef.position.Set(self.position.x/PTM_RATIO,
                             self.position.y/PTM_RATIO);
    
    birdBodyDef.userData = (__bridge void*)self;
    birdBodyDef.fixedRotation = true;
    
    _body = world->CreateBody(&birdBodyDef);
}

@end
