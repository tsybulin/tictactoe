//
//  MinimaxPlayer.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/18/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "MinimaxPlayer.h"
#import "Figure.h"
#import "Move+Score.h"
#import "Game.h"

@interface MinimaxPlayer () {
    NSOperationQueue *queue ;
}

@end

@implementation MinimaxPlayer

- (instancetype)initWithFigure:(Figure)figure name:(NSString *)name {
    if (self = [super initWithFigure:figure name:name]) {
        queue = [[NSOperationQueue alloc] init] ;
        queue.name = [name stringByAppendingString:@"queue"] ;
        queue.maxConcurrentOperationCount = 1 ;
        queue.qualityOfService = NSQualityOfServiceBackground ;
    }

    return self ;
}

- (Figure)opponetFor:(Figure)figure {
    return figure == Cross ? Zero : Cross ;
}

- (Move *)bestMove:(Game *)game figure:(Figure)figure {
    Board *availables = [game availableMoves] ;
    
    if ([game isWinningForFigure:self.figure]) {
        Move *move = [Move moveWithIndex:10 andFigure:self.figure] ;
        move.score = 10 ;
        return move ;
    }
    
    if ([game isWinningForFigure:[self opponetFor:self.figure]]) {
        Move *move = [Move moveWithIndex:10 andFigure:[self opponetFor:self.figure]] ;
        move.score = -10 ;
        return move ;
    }
    
    
    if (availables.count == 0) {
        return [Move moveWithIndex:10 andFigure:Empty] ;
    }
    
    NSMutableArray<Move *> *moves = [NSMutableArray arrayWithCapacity:0] ;
    
    for (Move *available in availables) {
        Move *move = [Move moveWithIndex:available.index andFigure:figure] ;
        
        [game.board objectAtIndex:available.index].figure = figure ;
        
        Move *m = [self bestMove:game figure:[self opponetFor:figure]] ;
        move.score = m.score ;
        
        [game.board objectAtIndex:available.index].figure = Empty ;
        
        [moves addObject:move] ;
    }
    
    Move *best = [Move moveWithIndex:10 andFigure:figure] ;
    best.score = (figure == self.figure) ? -10000 : 10000 ;
    
    for (Move *move in moves) {
        if (figure == self.figure) {
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

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    [queue addOperationWithBlock:^{
        Game *game = [[Game alloc] init] ;
        for (Move *move in self.game.board) {
            [game.board objectAtIndex:move.index].figure = move.figure ;
        }
        Move *move = [self bestMove:game figure:self.figure] ;
        if (move.figure != Empty) {
            [self.game player:self didMoveTo:move.index] ;
        }
    }] ;
}

- (void)playerDidReset:(Player *)player {
}

- (void)player:(Player *)player didChangeState:(BOOL)state {
}

@end
