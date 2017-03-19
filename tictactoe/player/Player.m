//
//  Player.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/18/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithFigure:(Figure)figure name:(NSString *)name {
    if (self = [super init]) {
        _figure = figure ;
        self.interactive = NO ;
        self.name = name ;
    }

    return self ;
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    [self doesNotRecognizeSelector:_cmd] ;
}

- (void)playerDidReset:(Player *)player {
    [self doesNotRecognizeSelector:_cmd] ;
}

- (void)player:(Player *)player didChangeState:(BOOL)state {
    [self doesNotRecognizeSelector:_cmd] ;
}

@end
