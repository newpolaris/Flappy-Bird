//
//  Ground.m
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Ground.h"
#import "MySingleton.h"


@implementation Ground

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    float scale = [MySingleton shared].scale;
    
    ground1 = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    ground1.anchorPoint = ccp(0, 0.3);
    ground1.scale = scale;
    
    [self addChild:ground1];
    
    return self;
}

@end
