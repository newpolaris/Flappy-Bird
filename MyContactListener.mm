//
//  MyContactListener.m
//  Flappy Bird
//
//  Created by newpolaris on 3/1/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "MyContactListener.h"
#import "Bird.h"
#import "Pipe.h"
#import "CCSprite.h"
#import "GameLayer.h"

void MyContactListener::BeginContact(b2Contact* contact) {
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
    b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
    {
        CCSprite* bNodeA = (__bridge CCSprite*)bodyA->GetUserData();
        CCSprite* bNodeB = (__bridge CCSprite*)bodyB->GetUserData();
        
        Bird *bird = nil;
        
        if ([bNodeA isKindOfClass:[Bird class]])
            bird = (Bird *)bNodeA;
            
        if ([bNodeB isKindOfClass:[Bird class]])
            bird = (Bird *)bNodeB;
        
        if (bird != nil)
            [(GameLayer *)[bird parent] collisionWithObject];
    }
}


