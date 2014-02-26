//
//  TitleLayer.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright newpolaris 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "Bird.h"
#import "Title.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "GlobalVariable.h"
#import "GameScene.h"

#import "TitleLayer.h"

// -----------------------------------------------------------------------
#pragma mark - TitleLayer
// -----------------------------------------------------------------------

@implementation TitleLayer

enum {
    kBackground = 0,
    kGround = 1,
};

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (CCScene*)scene
{
	CCScene *scene = [CCScene node];
	TitleLayer *layer = [TitleLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // 스프라이트 프레임 캐쉬에 스프라이트를 저장한다.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FlappyBird.plist"];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 전체 백그라운드를 설정한다.
    [self addChild:[BackgroundLayer node] z:kBackground tag:kBackground];
    
    GroundLayer *ground =[GroundLayer node];
    int groundHeight = [ground height];
    [self addChild:ground z:kGround tag:kGround];
    
    _copyright = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
    _copyright.anchorPoint = ccp(0.5, 0);
    [_copyright setScale:gScale];
    
    // TODO: 아이패드, 아이폰5에선 오차 발생
    // 노가다를 통한 y축 설정. 땅 부분의 위의 잔디에서 약간만 떨어진 위치 아래에 로고 박히게
    _copyright.position = ccp(winSize.width/2, winSize.height*0.18);
    [self addChild:_copyright z:1];
    
    CCSprite *startMenuNormal = [CCSprite spriteWithSpriteFrameName:@"start.png"];
    CCSprite *startMenuSelect = [CCSprite spriteWithSpriteFrameName:@"start.png"];
    startMenuSelect.color = ccc3(128, 128, 128);

    CCMenuItem *startMenu = [CCMenuItemImage itemWithNormalSprite:startMenuNormal
                               selectedSprite:startMenuSelect
                                        block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[GameScene node]];
                                        }];
    startMenu.scale = gScale;
    
    CCSprite *scoreMenuNormal = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    CCSprite *scoreMenuSelect = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    scoreMenuSelect.color = ccc3(128, 128, 128);

    CCMenuItem *scoreMenu = [CCMenuItemImage itemWithNormalSprite:scoreMenuNormal
                                                   selectedSprite:scoreMenuSelect
                                                            block:^(id sender) {
                                                            }];
    scoreMenu.scale = gScale;
    
    CCMenu *menu = [CCMenu menuWithItems: startMenu, scoreMenu, nil];
    float padding = (winSize.width - [startMenuNormal boundingBox].size.width*2)/3;
    
    // 수평으로 배치.
    [menu alignItemsHorizontallyWithPadding:padding/2];
    [menu setPosition:ccp(winSize.width/2, groundHeight*1.2)];
    
    // 만들어진 메뉴를 배경 sprite 위에 표시합니다.
    [self addChild:menu z:2];

    // 타이틀의 y축을 정한다. Ground 높이를 제외한 높이의 1/2 지점이 적당할 듯하다.
    _title = [Title node];
    float titleHeight = (winSize.height+groundHeight)/2;
    _title.position = ccp(0, titleHeight);
    [self addChild:_title z:1];
    
    // done
	return self;
}

@end
