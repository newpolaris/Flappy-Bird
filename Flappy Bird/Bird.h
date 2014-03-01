//
//  Bird.h
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Bird : CCSprite
{
}

@property (nonatomic, readwrite) b2Body *body;

- (void)createBox2dObject:(b2World*)world;

@end
