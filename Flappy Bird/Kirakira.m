//
//  Kirakira.m
//  Flappy Bird
//
//  Created by newpolaris on 3/9/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Kirakira.h"
#import "MySingleton.h"


@implementation Kirakira

-(id)init
{
    self = [super initWithSpriteFrameName:@"blast.png"];
    if (!self) return nil;
    self.visible = false;
    return self;
}

@end
