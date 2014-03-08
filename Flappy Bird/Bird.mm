//
//  Bird.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Bird.h"
#import "CCAnimation.h"
#import "MySingleton.h"

@implementation Bird

- (id)init {
    self = [super initWithSpriteFrameName:@"bird_normal.png"];
    if (!self) return nil;
    
    NSArray *birdSpriteNames = @[@"bird_normal.png",
                               @"bird_up_0.png",
                               @"bird_up_1.png"];
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (id object in birdSpriteNames)
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                          spriteFrameByName:object]];
    
    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.10];
    
    [self runAction:[CCRepeatForever actionWithAction
                     :[CCAnimate actionWithAnimation:animation]]];
    
    [self setScale:[MySingleton shared].scale];
    return self;
}


@end
