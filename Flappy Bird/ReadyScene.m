//
//  Ready.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "ReadyScene.h"
#import "GroundLayer.h"

@implementation ReadyScene

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[GroundLayer node] z:1];
    
    return self;
}

@end
