//
//  PairGame.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "PairGame.h"

@implementation PairGame

- (instancetype)init {
    self = [super init];
    if (self = [super init]) {
        _figure = Zero ;
    }
    
    return self;
}

- (void)flipFigure {
    _figure = _figure == Zero ? Cross : Zero ;
}

- (void)reset {
    _figure = Zero ;
}

@end
