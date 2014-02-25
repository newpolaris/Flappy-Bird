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
#import "GlobalVariable.h"

#import "TitleLayer.h"

// -----------------------------------------------------------------------
#pragma mark - TitleLayer
// -----------------------------------------------------------------------

@implementation TitleLayer

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (TitleLayer *)scene
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
    
    // 전체 백그라운드를 설정한다.
    _background = [CCSprite spriteWithSpriteFrameName:@"background.png"];
    _background.anchorPoint = CGPointZero;
    
    // window size get
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float scale = winSize.width/_background.contentSize.width;
    
    // 으아아 전역 변수를 쓰고 말았어 으아아
    gScale = scale;
    
    // 가로 화면에 맞춰서 늘린다.
    [_background setScale:scale];
    
    NSAssert(_background!=nil, @"Invalid background sprite for sprite. What the Hell");
    [self addChild:_background z:-2];
    
    // 백그라운드 앞의 땅을 설정한다.
    _ground = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    _ground.anchorPoint = CGPointZero;
    
    // 가로 화면에 맞춰서 늘린다.
    [_ground setScale:scale];
    NSAssert(_ground!=nil, @"Invalid ground sprite for sprite");
    [self addChild:_ground z:-1];
    
    _copyright = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
    _copyright.anchorPoint = ccp(0.5, 0);
    [_copyright setScale:scale];
    // 노가다를 통한 y축 설정. 땅 부분의 위의 잔디에서 약간만 떨어진 위치 아래에 로고 박히게
    _copyright.position = ccp(winSize.width/2, winSize.height*0.18);
    NSAssert(_copyright!=nil, @"Invalid copyright sprite for sprite");
    [self addChild:_copyright z:0];
    
    _start = [CCSprite spriteWithSpriteFrameName:@"start.png"];
    NSAssert(_start!=nil, @"Invalid start sprite for sprite");
    [self addChild:_start];
    
    _score = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    NSAssert(_score!=nil, @"Invalid score sprite for sprite");
    [self addChild:_score];
    
    // 타이틀의 y축을 정한다. Ground 높이를 제외한 높이의 1/2 지점이 적당할 듯하다.
    _title = [Title node];
    float titleHeight = (winSize.height+[_ground boundingBox].size.height)/2;
    _title.position = ccp(0, titleHeight);
    NSAssert(_title!=nil, @"Invalid title sprite for sprite");
    [self addChild:_title z:1];
    
	
    // done
	return self;
}

@end
