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
    
    tutorialLabel = [CCSprite spriteWithSpriteFrameName:@"tutorial.png"];
    tutorialLabel.anchorPoint = ccp(0, 0.5);
    tutorialLabel.position = ccp(winSize.width/2, winSize.height/2);
    tutorialLabel.scale = scale;
    [self addChild:tutorialLabel];
    
    readyLabel = [CCSprite spriteWithSpriteFrameName:@"get_ready.png"];
    readyLabel.scale = scale;
    readyLabel.position = ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:readyLabel];
    
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
