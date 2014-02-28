//
//  Ready.m
//  Flappy Bird
//
//  Created by newpolaris on 2/27/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GameLayer.h"
#import "GroundLayer.h"
#import "BackgroundLayer.h"
#import "Bird.h"
#import "Pipe.h"

@implementation GameLayer

enum {
    kBackground = 0,
    kPipe,
    kGround,
};

static const int kMaxPipe = 3;

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[BackgroundLayer node] z:kBackground];
    
    _groundLayer = [GroundLayer node];
    [self addChild:_groundLayer z:kGround];
    [self setScreenSpeed:_groundLayer.moveSpeed];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self setBird:[Bird node]];
    [self setBirdHeight:winSize.height/2];
    _bird.position = ccp(winSize.width*0.3, _birdHeight);
    
    [self addChild:_bird];
    
    [self setTutorialLabel:[CCSprite spriteWithSpriteFrameName:@"tutorial.png"]];
    _tutorialLabel.anchorPoint = ccp(0, 0.5);
    _tutorialLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_tutorialLabel];
    
    [self setReadyLabel:[CCSprite spriteWithSpriteFrameName:@"get_ready.png"]];
    _readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:_readyLabel];
    
    _impactTime = 0;
    _play = false;
    
    [self initPipe];
    
    return self;
}

- (void)initPipe
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int viewSize = winSize.height - _groundLayer.height;
    
    pipeArray = [[CCArray alloc] initWithCapacity:kMaxPipe];
    
    // Pipe 갯수 만큼 배열에 넣는다.
    for (int i = 0; i < kMaxPipe; i++)
    {
        const int delay = winSize.width*1.5;
        
        // 총알 노드를 생성
        Pipe *pipe = [Pipe node];
        
        int pipeWidth = pipe.width;
        int pipeGap = (winSize.width + pipeWidth/2)/2;
        int xPos = delay + i*pipeGap;
    
        // 총알의 위치는 플레이어 캐릭터의 앞에 위치.
        pipe.anchorPoint = ccp(0.5, 0.5);
        pipe.position = ccp(xPos, viewSize * 0.5 + _groundLayer.height);
        
        // 배치 노드에 넣는다.
        [self addChild:pipe z:kPipe];
        
        // 충돌 등 계산을 하기 쉽게 하기 위하여 배열에 넣는다.
        [pipeArray addObject:pipe];
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    static const float flyUp = 30;
    
    if (!_play)
    {
        [self removeChild:_tutorialLabel];
        [self removeChild:_readyLabel];
    }
    _play = true;
    
    _impactTime = 5;
    _velocity = flyUp;
    
    return YES;
}

- (void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
    
    // 배경 움직임과 충돌을 체크할 때 사용하는 메인 스케쥴?
    [self scheduleUpdate];
    
    // 점수를 위한 스케쥴
    
    // 새 위치 업데이트
    [self schedule:@selector(updateBirdPosition:)];
    
    // Pipe 움직이고 새롭게 갱신.
    [self schedule:@selector(updatePipe:)];
    
    // 점수를 위한 스케쥴
    // [self schedule:@selector(updateScore:) interval:0.01f];
    
    // 시작 되면 배경 백그라운드 음악이 재생
    // [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3" loop:YES];
}

-(void)update:(ccTime)dt
{
    // if (_birdHeight <= _groundLayer.height)
    //     _birdHeight = _groundLayer.height;
}

-(void)updatePipe:(ccTime)dt
{
    if (!_play)
        return;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for (int i = 0; i < kMaxPipe; i++)
    {
        Pipe* pipe = (Pipe*)[pipeArray objectAtIndex:i];
        CGPoint pos = pipe.position;
        pos.x += dt*_screenSpeed;
        pipe.position = pos;
        
        int pipeGap = (winSize.width + pipe.width/2)/2;
        
        int xLastPos = pipe.position.x + pipe.width;
        if (xLastPos <= 0)
        {
            pipe.position = ccp(pos.x + pipeGap*2, pos.y);
        }
    }
}

-(void)updateBirdPosition:(ccTime)dt
{
    static const float gravity = -98*10;
    
    if (_impactTime > 0)
    {
        _birdHeight += dt*350;
        _impactTime -= dt;
    }
    
    _birdHeight += _velocity * dt;
    _velocity += gravity * dt;
    
    _bird.position = ccp(_bird.position.x, _birdHeight);
}

@end
