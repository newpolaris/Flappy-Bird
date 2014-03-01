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
#import "GB2ShapeCache.h"
#import "Box2D.h"
#import "GLES-Render.h"

@implementation GameLayer

enum {
    kBackground = -5,
    kPipe,
    kGround,
    kBird,
};

static const int kMaxPipe = 3;

-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addChild:[BackgroundLayer node] z:kBackground];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self setTutorialLabel:[CCSprite spriteWithSpriteFrameName:@"tutorial.png"]];
    _tutorialLabel.anchorPoint = ccp(0, 0.5);
    _tutorialLabel.position = ccp(winSize.width/2, winSize.height/2);
    _tutorialLabel.scale = gScale;
    [self addChild:_tutorialLabel];
    
    [self setReadyLabel:[CCSprite spriteWithSpriteFrameName:@"get_ready.png"]];
    _readyLabel.scale = gScale;
    _readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:_readyLabel];
    
    _impactTime = 0;
    _play = false;
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"collision.plist"];

    [self setupPhysicsWorld];
    
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
    
    [_groundLayer createBox2dObject:world];
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_groundLayer.body
                                           forShapeName:@"ground"];
}

- (void)initBird
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self setBird:[Bird node]];
    [self setBirdHeight:winSize.height/2];
    _bird.position = ccp(winSize.width*0.3, _birdHeight);
    
    [self addChild:_bird z:kBird];
    [_bird createBox2dObject:world];
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_bird.body
                                           forShapeName:@"bird_normal"];
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
        
        Pipe *pipe = [Pipe node];
        
        int pipeWidth = pipe.width;
        int pipeGap = (winSize.width + pipeWidth/2)/2;
        int xPos = delay + i*pipeGap;
    
        pipe.anchorPoint = ccp(0.5, 0.5);
        pipe.position = ccp(xPos, viewSize * 0.5 + _groundLayer.height);
        
        // 배치 노드에 넣는다.
        [self addChild:pipe z:kPipe];
       
        [pipe createBox2dObject:world];
        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:pipe.bodyUp
                                               forShapeName:@"pipe_up"];
        
        
        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:pipe.bodyDown
                                               forShapeName:@"pipe_down"];
        // 충돌 등 계산을 하기 쉽게 하기 위하여 배열에 넣는다.
        [pipeArray addObject:pipe];
    }
}

- (void)setupPhysicsWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);

    world = new b2World(gravity);
    
    b2Draw *debugDraw = new GLESDebugDraw(PTM_RATIO);
    debugDraw->SetFlags(GLESDebugDraw::e_shapeBit);
    world->SetDebugDraw(debugDraw);
    world->DrawDebugData();
    
    contactListener = new MyContactListener();
    world->SetContactListener(contactListener);
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
    
    _impactTime = 0.8;
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

-(void)collisionWithObject
{
    if (!_play) return;
    
    // [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];

    [self unschedule:@selector(updatePipe:)];
    [self unschedule:@selector(bird:)];
    
    [[[CCDirector sharedDirector] touchDispatcher] setDispatchEvents:NO];
    [_bird stopAllActions];
    [_groundLayer unscheduleAllSelectors];
    
    /*
     for (Bullet *bullet in bulletsArray) {
        bullet.visible = NO;
        [bullet removeFromParentAndCleanup:YES];
     }

     [self unschedule:@selector(updateScore:)];

     CCCallBlock *allStop = [CCCallBlock actionWithBlock:^{
         [[[CCDirector sharedDirector] touchDispatcher]
            removeDelegate:self];
         [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
     }];

     CCDelayTime *delay = [CCDelayTime actionWithDuration:2.0f];
     [[[CCDirector sharedDirector] touchDispatcher] setDispatchEvents:NO];
     CCCallBlock *block = [CCCallBlock actionWithBlock:^{
         [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
     }];
     */
}

-(void)update:(ccTime)dt
{
    world->Step(dt, 0, 0);
    
    for (b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (__bridge CCSprite*)b->GetUserData();
            b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                       sprite.position.y/PTM_RATIO);
            
            float b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            b->SetTransform(b2Position, b2Angle);
        }
    }
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
            pipe.position = ccp(pos.x + pipeGap*3, pos.y);
        }
    }
}

-(void)updateBirdPosition:(ccTime)dt
{
    if (!_play) return;
    
    static const float gravity = -98*10;
    
    if (_impactTime > 0)
    {
        _birdHeight += dt*350;
        _impactTime -= dt;
    }
    
    _birdHeight += _velocity * dt;
    _velocity += gravity * dt;
    
    static const int maxDownFall = -1370;
    if (_velocity <= maxDownFall)
        _velocity = maxDownFall;
    
    int _birdBottom = _birdHeight + [_bird boundingBox].size.height/2;
    
    int winHeight = [CCDirector sharedDirector].winSize.height;
    
    if (_birdBottom <= _groundLayer.height) {
        [self unschedule:@selector(updateBirdPosition:)];
        [self collisionWithObject];
    } else if (_birdHeight > winHeight) {
        _birdHeight = winHeight;
        [self collisionWithObject];
    }
    
    if (_impactTime > 0)
        _bird.rotation = -30;
    else
        _bird.rotation = min(-_velocity*0.05, 90);
    
    _bird.position = ccp(_bird.position.x, _birdHeight);
}

-(void) draw
{
    // IMPORTANT:
    // This is only for debug purposes
    // It is recommend to disable it

    [super draw];

    // 2.
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );

    kmGLPushMatrix();
    world->DrawDebugData();
    kmGLPopMatrix();
}

@end
