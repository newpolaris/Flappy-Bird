//
//  Ground.h
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Ground : CCLayer {
    CCSprite *ground1;
}
@property (nonatomic, weak) CCSprite *ground2;

@property (atomic, readonly) int moveSpeed;
@property (atomic, readonly) int height;

@end
