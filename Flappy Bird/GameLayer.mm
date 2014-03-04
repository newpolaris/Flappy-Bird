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
#import "GlobalVariable.h"
#import "TitleLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer

enum {
    kBackground = -1,
    kPipe,
    kGround,
    kBird,
    kColorLayer,
    kResult,
};

static const int kMaxPipe = 3;

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[BackgroundLayer node] z:kBackground];
    
    _gameOver = false;
    
    self.touchEnabled = false;
    
    [self initGround]; // 순서 상관 있음.
    [self initPipe];
    [self initBird];
    
    return self;
}

- (void)initGround
{
    _groundLayer = [GroundLayer node];
    [self addChild:_groundLayer z:kGround];
    [self setScreenSpeed:_groundLayer.moveSpeed];
}

- (void)initBird
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self setBird:[Bird node]];
    [self setBirdHeight:winSize.height/2];
    _bird.position = ccp(winSize.width*0.3, _birdHeight);
    
    [self addChild:_bird z:kBird];
    
    _gone = - _delayPipeStart + winSize.width*0.3 + _pipeGap;
}

- (void)initPipe
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int viewSize = winSize.height - _groundLayer.height;
    _delayPipeStart = winSize.width*1.5;

    pipeArray = [[CCArray alloc] initWithCapacity:kMaxPipe];
    
    // Pipe 갯수 만큼 배열에 넣는다.
    for (int i = 0; i < kMaxPipe; i++)
    {
        Pipe *pipe = [Pipe node];
        
        int pipeWidth = pipe.width;
        _pipeGap = (winSize.width + pipeWidth/2)/2;
        int xPos = _delayPipeStart + i*_pipeGap;
    
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
    // 위로의 수직 상승 속도.
    static const float flyUp = 120;
    
    _velocity = flyUp;
    [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_wing.wav"];
    
    return YES;
}

- (void)addResult
{
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
    [self schedule:@selector(updateScore:) interval:0.3f];
}

-(void)updateScore:(ccTime)dt
{
    _gone -= dt*_screenSpeed;
    
    int newScore = _gone / _pipeGap;
    if (newScore > _score)
    {
        _score = newScore;
        // Draw _score
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_point.wav"];
    }
}

-(CCSequence*)earthquakeEffect
{
    static float oneFrame = 2.0 / 24.0;
    static CGPoint viewMove[] = {
        CGPointMake(+2.0, -4.0),
        CGPointMake(-4.0, +6.0),
        CGPointMake(+4.0, -4.0),
        CGPointMake(-4.0, +4.0),
        CGPointMake(+4.0, +2.0),
        CGPointMake(-5.0, -4.0),
        CGPointMake(+2.0, +4.0),
        CGPointMake(+1.0, +2.0)
    };
    
    id delayTimeAction = [CCDelayTime actionWithDuration:oneFrame];
    
    NSMutableArray *earthquake = [NSMutableArray array];
    
    for (int i = 0; i < sizeof(viewMove)/sizeof(viewMove[0]); i++)
    {
        CGPoint pt = viewMove[i];
        CCCallBlock *run = [CCCallBlock actionWithBlock:^{
            // 카메라 move
            float centerX, centerY, centerZ;
            float eyeX, eyeY, eyeZ;
            
            [self.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
            [self.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
            
            [self.camera setCenterX:centerX+gScale*pt.x centerY:centerY+gScale*pt.y centerZ:centerZ];
            [self.camera setEyeX:centerX+gScale*pt.x eyeY:eyeY+gScale*pt.y eyeZ:eyeZ];
        }];
        
        [earthquake addObject:run];
        [earthquake addObject:delayTimeAction];
    }
    
    return [CCSequence actionWithArray:earthquake];
}

-(CCSequence*)TintByWhite
{
    float waiting = 0.5;
    
    CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 128)];
    id opaque = [CCFadeOut actionWithDuration:waiting];
    
    CCCallBlock *changeColor = [CCCallBlock actionWithBlock:^{
        // 화면 전체를 하얀색에서 정상색으로 되돌리기
        colorLayer.scale = 1.2;
        [self addChild:colorLayer z:kColorLayer];
        [colorLayer runAction:opaque];
    }];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:waiting];
    CCCallBlock *removeLayer = [CCCallBlock actionWithBlock:^{
        [self removeChild:colorLayer];
    }];
    
    return [CCSequence actions:changeColor, delay, removeLayer, nil];
}

-(void)collisionWithObject
{
    if (_gameOver) return;
    
    _gameOver = YES;
    
    [self unschedule:@selector(updatePipe:)];
    [self unschedule:@selector(bird:)];
    [self unschedule:@selector(updateScore:)];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [_bird stopAllActions];
    [_groundLayer unscheduleAllSelectors];

    // Sound Effect Play.
    CCCallBlock *playHit = [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_hit.wav"];
    }];
    CCDelayTime *delaySound = [CCDelayTime actionWithDuration:0.5];
    CCCallBlock *playDie = [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_die.wav"];
    }];
    
    // Disappear
    // Pause button & score
    
    // Earthquake effect: Viewport move & TintByWhite
    CCSpawn *parllel = [CCSpawn actions:[self TintByWhite],
                                        [self earthquakeEffect],
                                        [CCSequence actions:playHit, delaySound, playDie, nil],
                                         nil];
    
    [self runAction:parllel];
    [self resultMenuShow];
}

-(CCMenu*)getResultMenuItem
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
    
    CCMenu *menu = [CCMenu menuWithItems: menuItemOk, menuItemShare, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float padding = (winSize.width - [menuItemOk boundingBox].size.width*2)/3;
    
    // 수평으로 배치.
    [menu alignItemsHorizontallyWithPadding:padding/2];
    [menu setPosition:ccp(winSize.width/2, winSize.height*0.5)];

    return menu;
}

// 만들어진 메뉴를 배경 sprite 위에 표시합니다.
-(void)resultMenuShow
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 떨어지는 시간까지 딜레이
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0f];
    
    CCSprite *gameOverLabel = [CCSprite spriteWithSpriteFrameName:@"game over.png"];
    gameOverLabel.position = ccp(winSize.width/2, winSize.height * 0.7);
    gameOverLabel.scale = gScale;
    gameOverLabel.anchorPoint = ccp(0.5, 0.5);
    gameOverLabel.visible = false;
    float duration = 0.8;
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:duration];
    [self addChild:gameOverLabel z:kResult];
    
    CCCallBlock *fadeInGameOver = [CCCallBlock actionWithBlock:^{
        gameOverLabel.visible = true;
        [gameOverLabel runAction:fadeIn];
    }];
    
    CCDelayTime *delayGameOver = [CCDelayTime actionWithDuration:duration];
    
    CCCallBlock *showResultBoard = [CCCallBlock actionWithBlock:^{
    }];
    
    /*
    CCCallBlock *showResultWindow = [CCCallBlock actionWithBlock:^{
        CGPoint startPos = resultMenu.position;
        startPos.y += -winSize.height;
        CCMoveBy *moveResult = [CCMoveBy actionWithDuration:0.7
                                                   position:startPos];
                                
        [self addChild:resultMenu z:kResult];
        [resultMenu runAction:moveResult];
    }];
     */
    
    // Ok & Share
    CCMenu *resultMenu = [self getResultMenuItem];
    resultMenu.anchorPoint = ccp(0.5, 0);
    resultMenu.position = ccp(winSize.width/2, _groundLayer.height * 1.3);
    
    CCCallBlock *showResultWindow = [CCCallBlock actionWithBlock:^{
        [self addChild:resultMenu z:kResult];
    }];
    
    CCSequence *seq = [CCSequence actions:delay,
                       fadeInGameOver,
                       delayGameOver,
                       showResultBoard,
                       showResultWindow,
                       nil];
    
    // 액션 실행
    [self runAction:seq];
}

-(bool)isCollision:(Pipe*)pipe
{
    CGRect up = pipe.pipeUp.boundingBox;
    up.origin = [pipe.pipeUp.parent convertToWorldSpace:up.origin];
    
    CGRect down = pipe.pipeDown.boundingBox;
    down.origin = [pipe.pipeDown.parent convertToWorldSpace:down.origin];
    
    return CGRectIntersectsRect(up, _bird.boundingBox)
        || CGRectIntersectsRect(down, _bird.boundingBox);
}

-(void)updatePipe:(ccTime)dt
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for (int i = 0; i < kMaxPipe; i++)
    {
        Pipe* pipe = (Pipe*)[pipeArray objectAtIndex:i];
        CGPoint pos = pipe.position;
        pos.x += dt*_screenSpeed;
        pipe.position = pos;
        
        int pipeGap = (winSize.width + pipe.width/2)/2;
        
        if ([self isCollision:pipe])
        {
            [self collisionWithObject];
        }
        
        int xLastPos = pipe.position.x + pipe.width;
        if (xLastPos <= 0)
        {
            pipe.position = ccp(pos.x + pipeGap*3, pos.y);
        }
    }
}

-(void)updateBirdPosition:(ccTime)dt
{
    static const float gravity = -98*4.6;
    
    int oldHeight = _birdHeight;
    
    int winHeight = [CCDirector sharedDirector].winSize.height;
    
    _birdHeight += _velocity * winHeight * dt / 150;
    _velocity += gravity * dt;
    
    static const int maxDownFall = -winHeight/2;
    if (_velocity <= maxDownFall)
        _velocity = maxDownFall;
    
    
    int _birdBottom = _birdHeight + [_bird boundingBox].size.height/2;
    
    static const float factor = 100;
    int realV = -(_birdHeight -oldHeight)*factor/winHeight/dt;
    if (realV >= 90)
        realV = 90;
    else if (realV < -35)
        realV = -35;
    
    _bird.rotation = realV;
    if (_birdBottom <= _groundLayer.height) {
        [self unschedule:@selector(updateBirdPosition:)];
        [self collisionWithObject];
        _birdHeight = _groundLayer.height;
      } else if (_birdHeight > winHeight) {
        _birdHeight = winHeight;
        [self collisionWithObject];
    }
    
    _bird.position = ccp(_bird.position.x, _birdHeight);
}

@end
