//
//  ResultLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ScoreBoard;

@interface ResultLayer : CCLayer {
    CGSize winSize;
    float gScale;
    
    float durationLabel;
    float durationBoard;
    
    CCMenu *menu;
    CCSprite *gameOverLabel;
    ScoreBoard *scoreBoard;
}

@property (nonatomic) float groundHeight;

-(void)runAction;
-(void)setScore:(int)score best:(int)bestScore;

@end
