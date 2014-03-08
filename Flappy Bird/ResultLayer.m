//
//  ResultLayer.m
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "ResultLayer.h"
#import "MySingleton.h"
#import "TitleLayer.h"

@implementation ResultLayer

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    durationLabel = 0.8;
    durationBoard = 0.7;
    
    winSize = [[CCDirector sharedDirector] winSize];
    gScale = [MySingleton shared].scale;
    
    [self initGameOverLabel];
    [self initBoard];
    [self initMenu];
    
    self.visible = false;
    
    return self;
}

-(void)initGameOverLabel
{
    gameOverLabel = [CCSprite spriteWithSpriteFrameName:@"game over.png"];
    gameOverLabel.position = ccp(winSize.width/2, winSize.height * 0.7);
    gameOverLabel.scale = gScale;
    gameOverLabel.anchorPoint = ccp(0.5, 0.5);
    gameOverLabel.visible = false;
    [self addChild:gameOverLabel];
}

// Ok & Share
-(void)initMenu
{
    CCSprite *menuOk = [CCSprite spriteWithSpriteFrameName:@"ok.png"];
    CCSprite *menuOkSelected = [CCSprite spriteWithSpriteFrameName:@"ok.png"];
    menuOkSelected.color = ccc3(128, 128, 128);

    CCMenuItem *menuItemOk = [CCMenuItemImage
                              itemWithNormalSprite:menuOk
                              selectedSprite:menuOkSelected
                              block:^(id sender) {
                                  [[CCDirector sharedDirector] replaceScene:[TitleLayer node]];
                              }];
    
    menuItemOk.scale = gScale;
    
    CCSprite *menuShare= [CCSprite spriteWithSpriteFrameName:@"score.png"];
    CCSprite *menuShareSelected = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    menuShareSelected.color = ccc3(128, 128, 128);

    CCMenuItem *menuItemShare = [CCMenuItemImage
                                 itemWithNormalSprite:menuShare
                                 selectedSprite:menuShareSelected
                                 block:^(id sender) {
                                     [[CCDirector sharedDirector] replaceScene:[TitleLayer node]];
                                 }];
    
    menuItemShare.scale = gScale;
    
    menu = [CCMenu menuWithItems: menuItemOk, menuItemShare, nil];
    
    float padding = (winSize.width - [menuItemOk boundingBox].size.width*2)/3;
    
    // 수평으로 배치.
    [menu alignItemsHorizontallyWithPadding:padding/2];
    [menu setPosition:ccp(winSize.width/2, winSize.height*0.5)];
    
    menu.anchorPoint = ccp(0.5, 0);
    menu.visible = false;
    [self addChild:menu];
}

- (void)initBoard
{
    CCSprite *scoreBoard = [CCSprite spriteWithSpriteFrameName:@"score_board.png"];
    
    // 백금, 금, 은, 동.
    NSArray *medals = @[[CCSprite spriteWithSpriteFrameName:@"medal_silver.png"],
                        [CCSprite spriteWithSpriteFrameName:@"medal_gold.png"],
                        [CCSprite spriteWithSpriteFrameName:@"medal_cupronikel.png"],
                        [CCSprite spriteWithSpriteFrameName:@"medal_Bronze.png"]];
    
    NSEnumerator *enumerator = [medals objectEnumerator];
    for (id element in enumerator) {
        CCSprite *sprite = (CCSprite*)element;
        sprite.visible = false;
        [scoreBoard addChild:sprite];
    }
    
    CCSprite *new = [CCSprite spriteWithSpriteFrameName:@"new.png"];
    new.visible = false;
    [scoreBoard addChild:new];
    
    CCSprite *kirakira = [CCSprite spriteWithSpriteFrameName:@"kirakira.png"];
    [scoreBoard addChild:kirakira];
    
    //
    scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"fontSmall.fnt"];
    scoreLabel.anchorPoint = ccp(0.5, 0.5);
    scoreLabel.position = ccp(winSize.width*0.5, winSize.height*0.5);
    scoreLabel.scale = gScale;
    
    [scoreBoard addChild:scoreLabel];
    
    //
    bestScoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"fontSmall.fnt"];
    bestScoreLabel.anchorPoint = ccp(0.5, 0.5);
    bestScoreLabel.position = ccp(winSize.width*0.5, winSize.height*0.5);
    bestScoreLabel.scale = gScale;
    
    [self addChild:scoreBoard];
}

- (void)scoreRenew:(int)score
{
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    scoreLabel.string = scoreString;
}

// 만들어진 메뉴를 배경 sprite 위에 표시합니다.
- (void)runAction
{
    self.visible = true;
    
    // 떨어지는 시간까지 딜레이
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0f];
    
    CCCallBlock *fadeInGameOver = [CCCallBlock actionWithBlock:^{
        gameOverLabel.visible = true;
        CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:durationLabel];
        [gameOverLabel runAction:fadeIn];
    }];
    
    CCDelayTime *waitGameOver = [CCDelayTime actionWithDuration:durationLabel];
    
    CCCallBlock *showBoard = [CCCallBlock actionWithBlock:^{
        /*
        CGPoint startPos = board.position;
        startPos.y += -winSize.height;
        CCMoveBy *moveResult = [CCMoveBy actionWithDuration:durationBoard
                                                   position:startPos];
        [borad runAction:showBord];
         */
    }];
    
    CCDelayTime *waitBoard = [CCDelayTime actionWithDuration:durationBoard];
    
    CCCallBlock *showMenu = [CCCallBlock actionWithBlock:^{
        // Ground 생선 시점으로 인해 이걸 뒤로 미룸.
        menu.position = ccp(winSize.width/2, _groundHeight * 1.3);
        menu.visible = true;
    }];
    
    CCSequence *seq = [CCSequence actions:
                       delay,
                       fadeInGameOver,
                       waitGameOver,
                       showBoard,
                       waitBoard,
                       showMenu,
                       nil];
    
    // 액션 실행
    [self runAction:seq];
}

@end
