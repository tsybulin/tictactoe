//
//  SingleGame.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "SingleGame.h"

@interface SingleGame () {
    NSOperationQueue *queue ;
}

@end

@implementation SingleGame

- (instancetype)init {
    if (self = [super init]) {
        queue = [[NSOperationQueue alloc] init] ;
        queue.name = @"SingleQameQueue" ;
        queue.maxConcurrentOperationCount = 1 ;
        queue.qualityOfService = NSQualityOfServiceBackground ;
    }

    return self ;
}

- (Move *)bestMoveFor:(Player)player {
    Board *availables = [self.game availableMoves] ;

    if ([self.game isWinningForPlayer:Human]) {
        Move *move = [[Move alloc] init] ;
        move.score = -10 ;
        move.player = Human ;
        return move ;
    }

    if ([self.game isWinningForPlayer:Computer]) {
        Move *move = [[Move alloc] init] ;
        move.score = 10 ;
        move.player = Computer ;
        return move ;
    }

    if (availables.count == 0) {
        return [[Move alloc] init] ;
    }

    NSMutableArray<Move *> *moves = [NSMutableArray arrayWithCapacity:0] ;

    for (Move *available in availables) {
        Move *move = [[Move alloc] init] ;
        move.index = available.index ;

        [self.game.board objectAtIndex:available.index].player = player ;

        Move *m = [self bestMoveFor:(player == Human) ? Computer : Human] ;
        move.score = m.score ;
        move.player = player ;

        [self.game.board objectAtIndex:available.index].player = Empty ;

        [moves addObject:move] ;
    }

    Move *best = [[Move alloc] init] ;
    best.player = player ;
    best.score = (player == Computer) ? -10000 : 10000 ;

    for (Move *move in moves) {
        if (player == Computer) {
            if (move.score > best.score) {
                best = move ;
            }
        } else {
            if (move.score < best.score) {
                best = move ;
            }
        }
    }

    return best ;
}

- (void)move {
    [queue addOperationWithBlock:^{
        Move *move = [self bestMoveFor:Computer] ;
        if (self.delegate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didMove:move] ;
            }) ;
        }
    }] ;
}

@end
