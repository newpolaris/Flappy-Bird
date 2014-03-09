//
//  ScoreBoard.h
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Kirakira;
@interface ScoreBoard : CCSprite {
    float currentScore;
    float numberAnimationDuring;
    
    CCSprite *newLabel;
    Kirakira *kirakira;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *bestScoreLabel;
    NSArray *medals;
}

@property (nonatomic) int score;
@property (nonatomic) int bestScore;

- (void)bestScoreRenew:(int)score;
- (void)startAnimation;

@end
