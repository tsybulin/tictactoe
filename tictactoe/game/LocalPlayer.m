//
//  LocalPlayer.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/18/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "LocalPlayer.h"
#import "Game.h"

@implementation LocalPlayer

- (instancetype)initWithFigure:(Figure)figure name:(NSString *)name {
    if (self = [super initWithFigure:figure name:name]) {
        self.interactive = YES ;
    }

    return self ;
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    if (player == self) {
        [self.game.board objectAtIndex:index].figure = self.figure ;
    }
}

- (void)playerDidReset:(Player *)player {
    if (player == self) {
        [self.game resetBoard] ;
    }
}

@end
