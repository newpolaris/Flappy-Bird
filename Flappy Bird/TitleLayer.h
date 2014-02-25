//
//  TitleLayer.h
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright newpolaris 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// 전방 선언.
@class Title;

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface TitleLayer : CCLayer

// -----------------------------------------------------------------------

+ (TitleLayer *)scene;
- (id)init;

@property (nonatomic, weak) Title *title;
@property (nonatomic, weak) CCSprite *start;
@property (nonatomic, weak) CCSprite *score;
@property (nonatomic, weak) CCSprite *copyright;
@property (nonatomic, weak) CCSprite *background;
@property (nonatomic, weak) CCSprite *ground;

// -----------------------------------------------------------------------
@end