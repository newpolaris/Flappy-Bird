//
//  MySingleton.h
//  Flappy Bird
//
//  Created by newpolaris on 2/25/14.
//  Copyright (c) 2014 newpolaris. All rights reserved.
//

// -----------------------------------------------------------------------
// iPhone resource를 가지고 iPad 대응하기 위해 리소스 크기 비교 후 scale을 세팅.
#pragma once

@interface MySingleton : NSObject {
}

// Class methods (static methods)
+(MySingleton*)shared;

// Public properties
@property (atomic, readonly) float scale;
@end

#define PTM_RATIO 16
