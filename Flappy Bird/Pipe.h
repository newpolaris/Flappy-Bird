//
//  PipeLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Pipe : CCNode

- (void)setPipeGap:(int)gap;

@property (nonatomic) int width;
@property (nonatomic, weak) CCSprite *pipeUp;
@property (nonatomic, weak) CCSprite *pipeDown;

@end
