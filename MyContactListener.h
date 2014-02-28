//
//  MyContactListener.h
//  Flappy Bird
//
//  Created by newpolaris on 3/1/14.
//  Copyright 2014 newpolaris. All rights reserved.
//

#import "Box2D.h"

class MyContactListener : public b2ContactListener {

public:
    void BeginContact(b2Contact* contact);
};
