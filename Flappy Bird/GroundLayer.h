//
//  Ground.h
//  Flappy Bird
//
//  Created by newpolaris on 2/26/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GroundLayer : CCLayer

// 땅 움직임을 표현할 때 사용할 2개의 sprite
@property (nonatomic, weak) CCSprite *ground1;
@property (nonatomic, weak) CCSprite *ground2;
@property (nonatomic) int moveSpeed;
@property (nonatomic) int height;

@end
