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
#import "ScoreBoard.h"
#import "GameLayer.h"
#import "AppDelegate.h"

@implementation ResultLayer

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    durationLabel = 0.5;
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
                                  [[AppController sharedAppDelegate] hideAds];
                                  [[CCDirector sharedDirector] replaceScene:[TitleLayer node]];
                              }];
    
    menuItemOk.scale = gScale;
    
    CCSprite *menuShare= [CCSprite spriteWithSpriteFrameName:@"share.png"];
    CCSprite *menuShareSelected = [CCSprite spriteWithSpriteFrameName:@"share.png"];
    menuShareSelected.color = ccc3(128, 128, 128);

    CCMenuItem *menuItemShare = [CCMenuItemImage
                                 itemWithNormalSprite:menuShare
                                 selectedSprite:menuShareSelected
                                 block:^(id sender) {
                                     [[AppController sharedAppDelegate] hideAds];
                                     [self.gameLayer tweet];
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
    scoreBoard = [ScoreBoard node];
    
    scoreBoard.position = ccp(winSize.width*0.5, winSize.height*0.48);
    scoreBoard.scale = gScale;
    scoreBoard.visible = false;
    [self addChild:scoreBoard];
}

// 만들어진 메뉴를 배경 sprite 위에 표시합니다.
- (void)runAction
{
    self.visible = true;
    
    // 떨어지는 시간까지 딜레이
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.7f];
    
    CCCallBlock *fadeInGameOver = [CCCallBlock actionWithBlock:^{
        // 이떄 부터 touch로 스킵 가능하게!
        [self touchBegin];
        
        gameOverLabel.visible = true;
        CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:durationLabel];
        [gameOverLabel runAction:fadeIn];
    }];
    
    CCDelayTime *waitGameOver = [CCDelayTime actionWithDuration:durationLabel];
    
    CCCallBlock *showBoard = [CCCallBlock actionWithBlock:^{
        
        CGPoint startPos = ccp(0, +winSize.height);
        CGPoint position = scoreBoard.position;
        position.y -= winSize.height;
        scoreBoard.position = position;
        
        scoreBoard.visible = true;
        CCMoveBy *moveResult = [CCMoveBy actionWithDuration:durationBoard
                                                   position:startPos];
        
        [scoreBoard runAction:moveResult];
    }];
    
    CCDelayTime *waitBoard = [CCDelayTime actionWithDuration:durationBoard];
    
    CCCallBlock *runNumberAnimation = [CCCallBlock actionWithBlock:^{
        [scoreBoard startAnimation];
    }];
    
    CCDelayTime *waitNumberAnimation = [CCDelayTime actionWithDuration:0.5];
        
    CCCallBlock *showMenu = [CCCallBlock actionWithBlock:^{
        // Ground 생선 시점으로 인해 이걸 뒤로 미룸.
        menu.position = ccp(winSize.width/2, _groundHeight * 1.3);
        menu.visible = true;
    }];
    
    CCCallBlock *iAdShow = [CCCallBlock actionWithBlock:^{
        [[AppController sharedAppDelegate] showAds];
    }];
    
    CCSequence *seq = [CCSequence actions:
                       delay,
                       fadeInGameOver,
                       waitGameOver,
                       showBoard,
                       waitBoard,
                       runNumberAnimation,
                       waitNumberAnimation,
                       showMenu,
                       iAdShow,
                       nil];
    
    // 액션 실행
    [self runAction:seq];
}

-(void)setScore:(int)score best:(int)pastBestScore
{
    scoreBoard.score = score;
    scoreBoard.bestScore = pastBestScore;
    [scoreBoard bestScoreRenew:pastBestScore];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self stopAllActions];
    self.visible = true;
    gameOverLabel.visible = true;
    scoreBoard.visible = true;
    [scoreBoard showLastResult];
    menu.position = ccp(winSize.width/2, _groundHeight * 1.3);
    menu.visible = true;
    [[AppController sharedAppDelegate] showAds];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    return YES;
}

- (void)touchBegin
{
    // Set priority smaller than menu item.
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:-5
                                                       swallowsTouches:NO];
}

@end
