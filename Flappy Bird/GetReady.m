//
//  GetReady.m
//  Flappy Bird
//
//  Created by newpolaris on 3/5/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "GetReady.h"
#import "MySingleton.h"


@implementation GetReady

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float scale = [MySingleton shared].scale;
    
    [self setTutorialLabel:[CCSprite spriteWithSpriteFrameName:@"tutorial.png"]];
    _tutorialLabel.anchorPoint = ccp(0, 0.5);
    _tutorialLabel.position = ccp(winSize.width/2, winSize.height/2);
    _tutorialLabel.scale = scale;
    [self addChild:_tutorialLabel];
    
    [self setReadyLabel:[CCSprite spriteWithSpriteFrameName:@"get_ready.png"]];
    _readyLabel.scale = scale;
    _readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:_readyLabel];
    
    return self;
}

-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_gameLayer activateSchedule];
    
    CCCallBlock *disableTouch = [CCCallBlock actionWithBlock:^{
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }];
    
    id fadeOut = [CCFadeOut actionWithDuration:0.5];
    
    CCCallBlock *selfDistory = [CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }];
    
    CCSequence *sequence = [CCSequence actions:
                                disableTouch,
                                fadeOut,
                                selfDistory,
                                nil];
    
    [self runAction:sequence];
                       
    return YES;
}

- (void)onEnter
{
    [super onEnter];
    
    // Set priority smaller than menu item.
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:-75
                                                       swallowsTouches:NO];
}

@end
