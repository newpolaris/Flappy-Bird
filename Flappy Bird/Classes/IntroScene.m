//
//  IntroScene.m
//  Flappy Bird
//
//  Created by newpolaris on 2/23/14.
//  Copyright newpolaris 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"
#import "Bird.h"
#import "GlobalVariable.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // 스프라이트 프레임 캐쉬에 스프라이트를 저장한다.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FlappyBird.plist"];
    
    // window size get!
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    
    // 전체 백그라운드를 설정한다.
    _background = [CCSprite spriteWithImageNamed:@"background.png"];
    _background.anchorPoint = CGPointZero;
    [self addChild:_background z:-2];
    
    float scale = winSize.width/_background.contentSize.width;
    
    // 으아아 전역 변수를 쓰고 말았어 으아아
    gScale = scale;
    
    // 가로 화면에 맞춰서 늘린다.
    [_background setScale:scale];
    
    // 백그라운드 앞의 땅을 설정한다.
    _ground = [CCSprite spriteWithImageNamed:@"ground.png"];
    _ground.anchorPoint = CGPointZero;
    
    // 가로 화면에 맞춰서 늘린다.
    [_ground setScale:scale];
    [self addChild:_ground z:-1];
    
    _copyright = [CCSprite spriteWithImageNamed:@"logo.png"];
    _copyright.anchorPoint = ccp(0.5, 0);
    [_copyright setScale:scale];
    // 노가다를 통한 y축 설정. 땅 부분의 위의 잔디에서 약간만 떨어진 위치 아래에 로고 박히게
    _copyright.position = ccp(winSize.width/2, winSize.height*0.18);
    [self addChild:_copyright z:0];
    
    _start = [CCSprite spriteWithImageNamed:@"start.png"];
    [self addChild:_start];
    
    _score = [CCSprite spriteWithImageNamed:@"score.png"];
    [self addChild:_score];
    
    // 타이틀의 y축을 정한다. Ground 높이를 제외한 높이의 1/2 지점이 적당할 듯하다.
    _title = [Title node];
    float titleHeight = (winSize.height+[_ground boundingBox].size.height)/2;
    _title.position = ccp(0, titleHeight);
    [self addChild:_title z:1];
    
    // Spinning scene button
    CCButton *spinningButton = [CCButton buttonWithTitle:@"[ Simple Sprite ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    spinningButton.positionType = CCPositionTypeNormalized;
    spinningButton.position = ccp(0.5f, 0.35f);
    [spinningButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:spinningButton];
    
    // Next scene button
    CCButton *newtonButton = [CCButton buttonWithTitle:@"[ Newton Physics ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    newtonButton.positionType = CCPositionTypeNormalized;
    newtonButton.position = ccp(0.5f, 0.20f);
    [newtonButton setTarget:self selector:@selector(onNewtonClicked:)];
    [self addChild:newtonButton];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    // start newton scene with transition
    // the current scene is pushed, and thus needs popping to be brought back. This is done in the newton scene, when pressing back (upper left corner)
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
