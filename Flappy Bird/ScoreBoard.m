//
//  ScoreBoard.m
//  Flappy Bird
//
//  Created by newpolaris on 3/8/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "ScoreBoard.h"
#import "Kirakira.h"

@implementation ScoreBoard

- (id)init
{
    self = [super initWithSpriteFrameName:@"score_board.png"];
    if (!self) return nil;
    
    currentScore = 0.0;
    numberAnimationDuring = 0.5;
    
    CGSize size = self.contentSize;
    
    // 백금, 금, 은, 동.
    medals = @[[CCSprite spriteWithSpriteFrameName:@"medal_silver.png"],
               [CCSprite spriteWithSpriteFrameName:@"medal_gold.png"],
               [CCSprite spriteWithSpriteFrameName:@"medal_cupronickel.png"],
               [CCSprite spriteWithSpriteFrameName:@"medal_bronze.png"]];
    
    NSEnumerator *enumerator = [medals objectEnumerator];
    for (id element in enumerator) {
        CCSprite *sprite = (CCSprite*)element;
        sprite.visible = false;
        sprite.position = ccp(size.width*0.21, size.height*0.45);
        [self addChild:sprite];
    }
    
    newLabel = [CCSprite spriteWithSpriteFrameName:@"new.png"];
    newLabel.position = ccp(size.width*0.66, size.height*0.44);
    newLabel.visible = false;
    [self addChild:newLabel];
    
    CCSprite *what = [CCSprite spriteWithSpriteFrameName:@"kirakira.png"];
    what.visible = false;
    [self addChild:what];
    
    kirakira = [Kirakira node];
    kirakira.position = ccp(size.width*0.25, size.height*0.5);
    [self addChild:kirakira];
    
    //
    scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
    scoreLabel.position = ccp(size.width*0.91, size.height*0.66);
    scoreLabel.anchorPoint = ccp(1.0, 0.5);
    
    [self addChild:scoreLabel];
    
    //
    bestScoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
    bestScoreLabel.position = ccp(size.width*0.91, size.height*0.30);
    bestScoreLabel.anchorPoint = ccp(1.0, 0.5);
    
    [self addChild:bestScoreLabel];
    
    return self;
}

- (void)updateNumberAnimation:(ccTime)dt
{
    float increment = (float)self.score*dt/numberAnimationDuring;
    currentScore += increment;
    
    [self scoreRenew:(int)currentScore];
}

- (void)startAnimation
{
    CCCallBlock *numAnimationStart = [CCCallBlock actionWithBlock:^{
        [self schedule:@selector(updateNumberAnimation:)];
    }];
    
    CCDelayTime *numberAnimationDelay = [CCDelayTime actionWithDuration:numberAnimationDuring];

    CCCallBlock *last = [CCCallBlock actionWithBlock:^{
        [self unschedule:@selector(updateNumberAnimation:)];
        [self scoreRenew:self.score];

        if (self.bestScore < self.score)
        {
            [self bestScoreRenew:self.score];
            newLabel.visible = true;
        }
        
        int medalIndex = -1;
        if (self.score >= 40)
            medalIndex = 0;
        else if (self.score >= 30)
            medalIndex = 1;
        else if (self.score >= 20)
            medalIndex = 2;
        else if (self.score >= 10)
            medalIndex = 3;
        
        if (medalIndex >= 0)
        {
            CCSprite *sprite = (CCSprite*)[medals objectAtIndex:medalIndex];
            sprite.visible = true;
        }
    }];
    
    CCSequence *seq = [CCSequence actions:
                       numAnimationStart,
                       numberAnimationDelay,
                       last,
                       nil];
    
    [self runAction:seq];
}

- (void)bestScoreRenew:(int)score
{
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    bestScoreLabel.string = scoreString;
}

- (void)scoreRenew:(int)score
{
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    scoreLabel.string = scoreString;
}

@end
