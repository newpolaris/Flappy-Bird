//
//  IntroScene.h
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright newpolaris 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Title.h"

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface IntroScene : CCScene

// -----------------------------------------------------------------------

+ (IntroScene *)scene;
- (id)init;

@property (nonatomic, weak) Title *title;
@property (nonatomic, weak) CCSprite *start;
@property (nonatomic, weak) CCSprite *score;
@property (nonatomic, weak) CCSprite *copyright;
@property (nonatomic, weak) CCSprite *background;
@property (nonatomic, weak) CCSprite *ground;

// -----------------------------------------------------------------------
@end