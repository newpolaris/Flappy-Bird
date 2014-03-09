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
#import "MySingleton.h"
#import "TitleLayer.h"
#import "SimpleAudioEngine.h"
#import "HudLayer.h"
#import "ResultLayer.h"
#import "ScoreBoard.h"

@implementation GameLayer

enum {
    kPipe,
    kGround,
    kBird,
    kColorLayer,
};

static const int kMaxPipe = 3;

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    state = kAlive;
    winSize = [[CCDirector sharedDirector] winSize];
    gScale = [MySingleton shared].scale;
    _pipeUpDownGap = winSize.height / 4;
    
    [self initGround]; // 순서 조심.
    [self initPipe];
    [self initBird];
    
    return self;
}

- (void)initGround
{
    // Ground 레이어 추가하기
    GroundLayer *groundLayer = [GroundLayer node];
    [self addChild:groundLayer z:kGround];
    
    groundHeight = groundLayer.height;
    
    // 게임 레이어의 ground 에 Ground레이어 전다.
    self.ground = groundLayer;
    
}
- (void)initBird
{
    [self setBird:[Bird node]];
    [self setBirdHeight:winSize.height/2];
    _bird.position = ccp(winSize.width*0.3, _birdHeight);
    
    [self addChild:_bird z:kBird];
    
    _gone = - _delayPipeStart + winSize.width*0.3 + _pipeGap;
}

- (void)initPipe
{
    _delayPipeStart = winSize.width*1.5;

    pipeArray = [[CCArray alloc] initWithCapacity:kMaxPipe];
    
    // Pipe 갯수 만큼 배열에 넣는다.
    for (int i = 0; i < kMaxPipe; i++)
    {
        Pipe *pipe = [Pipe node];
        [pipe setPipeGap:_pipeUpDownGap];
        
        float pipeWidth = pipe.width;
        _pipeGap = (winSize.width + pipeWidth/2)/2;
        float xPos = _delayPipeStart + i*_pipeGap;
    
        pipe.anchorPoint = ccp(0.5, 0.5);
        pipe.position = ccp(xPos, [self nextPipePosY]);
        
        [self addChild:pipe z:kPipe];
       
        // 충돌 등 계산을 하기 쉽게 하기 위하여 배열에 넣는다.
        [pipeArray addObject:pipe];
    }
}

- (void)activateSchedule
{
    // 새 위치 업데이트
    [self schedule:@selector(updateBirdPosition:)];
    
    // Pipe 움직이고 새롭게 갱신.
    [self schedule:@selector(updatePipe:)];
    
    // 점수를 위한 스케쥴
    [self schedule:@selector(updateScore:) interval:0.05];
    
}

- (void)unactivateSchedule
{
    [self unschedule:@selector(updatePipe:)];
    [self unschedule:@selector(bird:)];
    [self unschedule:@selector(updateScore:)];
}

- (int)nextPipePosY
{
    // *2가 넉넉하나 좁아보이므로 1.5로 정함.
    int viewSize = winSize.height - groundHeight - _pipeUpDownGap*1.5;
    return arc4random_uniform(viewSize) + groundHeight + _pipeUpDownGap;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // 위로의 수직 상승 속도.
    static const float flyUp = 140;
    
    _velocity = flyUp;
    [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_wing.wav"];
    
    return YES;
}

- (void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
}

-(void)updateScore:(ccTime)dt
{
    _gone -= dt*_ground.moveSpeed;
    
    float newScore = _gone / _pipeGap;
    if ((int)newScore > (int)_score)
    {
        _score = newScore;
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_point.wav"];
        [_hud scoreRenew:newScore];
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
        CGPointMake(+4.0, +1.0),
        CGPointMake(-5.0, -5.0),
        CGPointMake(+2.0, +4.0),
        CGPointMake(+1.0, -2.0)
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
    [self unactivateSchedule];
    
    _hud.visible = false;
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [_bird stopAllActions];
    [_ground unscheduleAllSelectors];

    // Sound Effect Play.
    CCCallBlock *playHit = [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_hit.wav"];
    }];
    CCDelayTime *delaySound = [CCDelayTime actionWithDuration:0.5];
    CCCallBlock *playDie = [CCCallBlock actionWithBlock:^{
        if (state == kKIA)
            [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_die.wav"];
    }];
    
    // Earthquake effect: Viewport move & TintByWhite
    CCSpawn *spawn = [CCSpawn actions:[self TintByWhite],
                                        [self earthquakeEffect],
                                        [CCSequence actions:playHit, delaySound, playDie, nil],
                                         nil];
    
    [self runAction:spawn];
    
    int pastBestScore = [self getHighScore];
    if (pastBestScore < self.score)
        [self setHightScore:self.score];
    
    // [_result setScore:self.score best:pastBestScore];
    [_result setScore:80 best:pastBestScore];
    [_result runAction];
}

-(int)getHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *bestScore = [defaults objectForKey:@"best_score"];
    
    if (bestScore == nil)
        return 0;
    else
        return bestScore.intValue;
}

-(void)setHightScore:(int)score
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *bestScore = [NSNumber numberWithInt:score];
    [defaults setObject:bestScore forKey:@"best_score"];
}

-(bool)isCollision:(Pipe*)pipe
{
    CGRect up = pipe.pipeUp.boundingBox;
    up.origin = [pipe.pipeUp.parent convertToWorldSpace:up.origin];
    
    CGRect down = pipe.pipeDown.boundingBox;
    down.origin = [pipe.pipeDown.parent convertToWorldSpace:down.origin];
    
#if USE_BIRD_BOUNDING_BOX
    return CGRectIntersectsRect(up, _bird.boundingBox)
        || CGRectIntersectsRect(down, _bird.boundingBox);
#else
    return CGRectContainsPoint(up, _bird.position)
        || CGRectContainsPoint(down, _bird.position);
#endif
}

-(void)updatePipe:(ccTime)dt
{
    for (int i = 0; i < kMaxPipe; i++)
    {
        Pipe* pipe = (Pipe*)[pipeArray objectAtIndex:i];
        CGPoint pos = pipe.position;
        
        pos.x += dt*_ground.moveSpeed;
        
        pipe.position = pos;
        
        if ([self isCollision:pipe])
        {
            if (state == kAlive)
            {
                state = kKIA;
                [self collisionWithObject];
            }
        }
        
        float xLastPos = pipe.position.x + pipe.width;
        if (xLastPos < 0)
        {
            pipe.position = ccp(pos.x + _pipeGap*3, [self nextPipePosY]);
        }
    }
}

-(void)updateBirdPosition:(ccTime)dt
{
    static const float gravity = -98*4.6;
    
    float oldHeight = _birdHeight;
    
    int winHeight = [CCDirector sharedDirector].winSize.height;
    
    _birdHeight += _velocity * winHeight * dt / 160;
    _velocity += gravity * dt;
    
    static const float maxDownFall = -winHeight/2;
    if (_velocity <= maxDownFall)
        _velocity = maxDownFall;
    
    
    static const float factor = 100;
    float realV = -(_birdHeight -oldHeight)*factor/winHeight/dt;
    if (realV >= 90)
        realV = 90;
    else if (realV < -35)
        realV = -35;
    
    _bird.rotation = realV;
    if (_birdHeight <= groundHeight) {
        [self unschedule:@selector(updateBirdPosition:)];
        if (state == kAlive)
        {
            state = kGroundHit;
            [self collisionWithObject];
        }
        _birdHeight = groundHeight;
      } else if (_birdHeight > winHeight) {
          _birdHeight = winHeight;
          if (state == kAlive)
          {
              state = kKIA;
              [self collisionWithObject];
          }
    }
    
    _bird.position = ccp(_bird.position.x, _birdHeight);
}

@end
