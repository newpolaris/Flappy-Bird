//
//  ResultLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 3/2/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ResultLayer : CCLayer;

@property (nonatomic, weak) CCSprite *gameOverLabel;
@property (nonatomic, weak) CCNode *resultNode;
@property (nonatomic, weak) CCNode *OKandShare;

@end
