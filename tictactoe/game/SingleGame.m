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

- (Move *)bestMoveFor:(Figure)figure {
    Board *availables = [self.game availableMoves] ;

    if ([self.game isWinningForFigure:Zero]) {
        Move *move = [[Move alloc] init] ;
        move.score = -10 ;
        move.figure = Zero ;
        return move ;
    }

    if ([self.game isWinningForFigure:Cross]) {
        Move *move = [[Move alloc] init] ;
        move.score = 10 ;
        move.figure = Cross ;
        return move ;
    }

    if (availables.count == 0) {
        return [[Move alloc] init] ;
    }

    NSMutableArray<Move *> *moves = [NSMutableArray arrayWithCapacity:0] ;

    for (Move *available in availables) {
        Move *move = [[Move alloc] init] ;
        move.index = available.index ;

        [self.game.board objectAtIndex:available.index].figure = figure ;

        Move *m = [self bestMoveFor:(figure == Zero) ? Cross : Zero] ;
        move.score = m.score ;
        move.figure = figure ;

        [self.game.board objectAtIndex:available.index].figure = Empty ;

        [moves addObject:move] ;
    }

    Move *best = [[Move alloc] init] ;
    best.figure = figure ;
    best.score = (figure == Cross) ? -10000 : 10000 ;

    for (Move *move in moves) {
        if (figure == Cross) {
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
        Move *move = [self bestMoveFor:Cross] ;
        if (self.delegate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didMove:move] ;
            }) ;
        }
    }] ;
}

@end
