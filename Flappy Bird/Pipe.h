//
//  PipeLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Pipe : CCNode

@property (nonatomic) int width;
@property (nonatomic, readwrite) b2Body *body1;
@property (nonatomic, readwrite) b2Body *body2;

- (void)createBox2dObject:(b2World *)world;

@end
