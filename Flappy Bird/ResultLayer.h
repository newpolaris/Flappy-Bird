//
//  ResultLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ResultLayer : CCLayer {
    CGSize winSize;
    float gScale;
    
    float durationLabel;
    float durationBoard;
    
    CCMenu *menu;
    CCSprite *gameOverLabel;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *bestScoreLabel;
}

@property (nonatomic) float groundHeight;

-(void)runAction;

@end
