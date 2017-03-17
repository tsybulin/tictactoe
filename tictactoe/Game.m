//
//  Game.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Game.h"
#import "Player.h"

@implementation Game

- (instancetype)init {
    if (self = [super init]) {
        self.board = @[
            [Move moveWithIndex:0 andPlayer:Empty], [Move moveWithIndex:1 andPlayer:Empty], [Move moveWithIndex:2 andPlayer:Empty],
            [Move moveWithIndex:3 andPlayer:Empty], [Move moveWithIndex:4 andPlayer:Empty], [Move moveWithIndex:5 andPlayer:Empty],
            [Move moveWithIndex:6 andPlayer:Empty], [Move moveWithIndex:7 andPlayer:Empty], [Move moveWithIndex:8 andPlayer:Empty]
        ] ;

    }

    return self ;
}

- (void)resetBoard {
    for (Move *move in self.board) {
        move.score = 0 ;
        move.player = Empty ;
    }
}

- (Board *)availableMoves {
    return [self.board filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ((Move *)evaluatedObject).player == Empty ;
    }]] ;
}

- (BOOL)isWinningForPlayer:(Player)player {
    return
        ([self.board objectAtIndex:0].player == player && [self.board objectAtIndex:1].player == player && [self.board objectAtIndex:2].player == player) ||
        ([self.board objectAtIndex:3].player == player && [self.board objectAtIndex:4].player == player && [self.board objectAtIndex:5].player == player) ||
        ([self.board objectAtIndex:6].player == player && [self.board objectAtIndex:7].player == player && [self.board objectAtIndex:8].player == player) ||

        ([self.board objectAtIndex:0].player == player && [self.board objectAtIndex:3].player == player && [self.board objectAtIndex:6].player == player) ||
        ([self.board objectAtIndex:1].player == player && [self.board objectAtIndex:4].player == player && [self.board objectAtIndex:7].player == player) ||
        ([self.board objectAtIndex:2].player == player && [self.board objectAtIndex:5].player == player && [self.board objectAtIndex:8].player == player) ||
        
        ([self.board objectAtIndex:0].player == player && [self.board objectAtIndex:4].player == player && [self.board objectAtIndex:8].player == player) ||
        ([self.board objectAtIndex:2].player == player && [self.board objectAtIndex:4].player == player && [self.board objectAtIndex:6].player == player)
    ;
}

- (BOOL)isFinished {
    for (Move *move in self.board) {
        if (move.player == Empty) {
            return NO ;
        }
    }
    
    return YES ;
}

@end
