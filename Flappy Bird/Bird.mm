//
//  Bird.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Bird.h"
#import "CCAnimation.h"

@implementation Bird

- (id)init {
    self = [CCSprite node];
    if (!self) return nil;
    
    CCSpriteFrame *bird0 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird_normal.png"];
    CCSpriteFrame *bird1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird_up_0.png"];
    CCSpriteFrame *bird2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird_up_1.png"];

    NSArray *frames = [NSArray arrayWithObjects:bird0, bird1, bird2, nil];
    
    _animation = [CCAnimation animationWithSpriteFrames:frames delay:0.2];
    _action = [CCaction ]
    return self;
}
@end
