//
//  TitleLayer.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright newpolaris 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "Title.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "GameScene.h"
#import "TitleLayer.h"
#import "MySingleton.h"
#import "AppDelegate.h"
#import "iAdLayer.h"

// -----------------------------------------------------------------------
#pragma mark - TitleLayer
// -----------------------------------------------------------------------

@implementation TitleLayer

enum {
    kBackground = 0,
    kGround,
    kMenu,
    kCopyright,
    kTitle,
    kiAD
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
    
    winSize = [[CCDirector sharedDirector] winSize];
    gScale = [MySingleton shared].scale;
    
    [self initBackground];
    [self initGround];
    [self initCopyright];
    [self initMenu];
    [self initTitle];
    
    self.iAd = [iAdLayer node];
    [self addChild:self.iAd];
    
    // done
	return self;
}

- (void)initBackground
{
    // 전체 백그라운드를 설정한다.
    BackgroundLayer *backgroundLayer = [BackgroundLayer node];
    [self addChild:backgroundLayer z:kBackground];
    
}

- (void)initGround
{
    GroundLayer *ground =[GroundLayer node];
    groundHeight = [ground height];
    [self addChild:ground z:kGround];
}

- (void)initCopyright
{
    _copyright = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
    _copyright.anchorPoint = ccp(0.5, 0);
    [_copyright setScale:gScale];
    
    _copyright.position = ccp(winSize.width/2,
                              groundHeight - [_copyright boundingBox].size.height*2);
    [self addChild:_copyright z:kCopyright];
}

- (void)initMenu
{
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
    menu.position = ccp(winSize.width/2, groundHeight*1.3);
    
    // 만들어진 메뉴를 배경 sprite 위에 표시합니다.
    [self addChild:menu z:kMenu];

}

- (void)initTitle
{
    // 타이틀의 y축을 정한다. Ground 높이를 제외한 높이의 1/2 지점이 적당할 듯하다.
    _title = [Title node];
    float titleHeight = (winSize.height+groundHeight)/2;
    _title.position = ccp(0, titleHeight);
    [self addChild:_title z:kTitle];
}

@end
