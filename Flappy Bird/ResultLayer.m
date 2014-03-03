//
//  ResultLayer.m
//  Flappy Bird
//
//  Created by newpolaris on 3/2/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "ResultLayer.h"
#import "TitleLayer.h"
#import "GlobalVariable.h"

@implementation ResultLayer

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    _gameOverLabel = [CCSprite spriteWithSpriteFrameName:@"game over.png"];
    [self addChild:_gameOverLabel];
    
    CCSprite *menuOk = [CCSprite spriteWithSpriteFrameName:@"ok.png"];
    CCSprite *menuOkSelected = [CCSprite spriteWithSpriteFrameName:@"ok.png"];
    menuOkSelected.color = ccc3(128, 128, 128);

    CCMenuItem *menuItemOk = [CCMenuItemImage itemWithNormalSprite:menuOk
                                                    selectedSprite:menuOkSelected
                                                             block:^(id sender) {
                                                                 [[CCDirector sharedDirector] replaceScene:[TitleLayer node]];
                                                             }];
    
    menuItemOk.scale = gScale;
    
    CCSprite *menuShare= [CCSprite spriteWithSpriteFrameName:@"score.png"];
    CCSprite *menuShareSelected = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    menuShareSelected.color = ccc3(128, 128, 128);

    CCMenuItem *menuItemShare = [CCMenuItemImage itemWithNormalSprite:menuShare
                                                       selectedSprite:menuShareSelected
                                                                block:^(id sender) {
                                                                    [[CCDirector sharedDirector] replaceScene:[TitleLayer node]];
                                                                }];
    menuItemShare.scale = gScale;
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemOk, menuItemShare, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float padding = (winSize.width - [menuItemOk boundingBox].size.width*2)/3;
    
    // 수평으로 배치.
    [menu alignItemsHorizontallyWithPadding:padding/2];
    [menu setPosition:ccp(winSize.width/2, winSize.height*0.5)];
    
    // 만들어진 메뉴를 배경 sprite 위에 표시합니다.
    [self addChild:menu z:2];

    return self;
}

- (void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:-1
                                                       swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

@end
