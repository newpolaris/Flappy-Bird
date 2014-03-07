//
//  HudLayer.m
//  Flappy Bird
//
//  Created by newpolaris on 3/6/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "HudLayer.h"
#import "GlobalVariable.h"

@implementation HudLayer

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initResumeButtom];
    [self initScore];
    
    return self;
}

- (void)initResumeButtom
{
    CCSprite *resume = [CCSprite spriteWithSpriteFrameName:@"resume.png"];
    CCSprite *resumeSelected = [CCSprite spriteWithSpriteFrameName:@"resume.png"];
    
    resumeSelected.color = ccc3(128, 128, 128);

    _resumeMenu = [CCMenuItemImage
                   itemWithNormalSprite:resume
                   selectedSprite:resumeSelected
                   block:^(id sender) {
                       _resumeMenu.visible = false;
                       _pauseMenu.visible = true;
                       [[CCDirector sharedDirector] resume];
                   }];
    _resumeMenu.scale = gScale;
    
    CCSprite *pause  = [CCSprite spriteWithSpriteFrameName:@"pause.png"];
    CCSprite *pauseSelected  = [CCSprite spriteWithSpriteFrameName:@"pause.png"];
    
    pauseSelected.color = ccc3(128, 128, 128);
    
    _pauseMenu = [CCMenuItemImage
                  itemWithNormalSprite:pause
                  selectedSprite:pauseSelected
                  block:^(id sender) {
                       _resumeMenu.visible = true;
                       _pauseMenu.visible = false;
                      [[CCDirector sharedDirector] pause];
                  }];
    _pauseMenu.scale = gScale;
    
    CCMenu *menu = [CCMenu menuWithItems: _resumeMenu, _pauseMenu, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int xPosition = [_resumeMenu boundingBox].size.width;
    
    menu.anchorPoint = ccp(0, 0.5);
    menu.position = ccp(xPosition, winSize.height*0.85);
    
    // 시작은 resume을 끄고 pause를 활성화 시킨다.
    _resumeMenu.visible = false;
    
    [self addChild:menu];
}

- (void)initScore
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
    scoreLabel.anchorPoint = ccp(0.5, 0.5);
    scoreLabel.position = ccp(winSize.width*0.5, winSize.height*0.85);
    scoreLabel.scale = gScale;
    
    [self addChild:scoreLabel];
}

- (void)scoreRenew:(int)score
{
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    scoreLabel.string = scoreString;
}

@end
