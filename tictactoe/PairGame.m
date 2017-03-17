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
        _player = Human ;
    }
    
    return self;
}

- (void)flipPlayer {
    _player = _player == Human ? Computer : Human ;
}

- (void)reset {
    _player = Human ;
}

@end
