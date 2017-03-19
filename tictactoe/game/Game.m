//
//  Game.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Game.h"
#import "Figure.h"

@interface Game () {
    NSMutableArray<Player *> *players ;
    NSInteger current ;
}

@end

@implementation Game

- (instancetype)init {
    if (self = [super init]) {
        self.board = @[
            [Move moveWithIndex:0 andFigure:Empty], [Move moveWithIndex:1 andFigure:Empty], [Move moveWithIndex:2 andFigure:Empty],
            [Move moveWithIndex:3 andFigure:Empty], [Move moveWithIndex:4 andFigure:Empty], [Move moveWithIndex:5 andFigure:Empty],
            [Move moveWithIndex:6 andFigure:Empty], [Move moveWithIndex:7 andFigure:Empty], [Move moveWithIndex:8 andFigure:Empty]
        ] ;
        players = [NSMutableArray arrayWithCapacity:0] ;
        current = 0 ;
    }

    return self ;
}

- (void)resetBoard {
    for (Move *move in self.board) {
        move.figure = Empty ;
    }
    current = 0 ;
}

- (Board *)availableMoves {
    return [self.board filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ((Move *)evaluatedObject).figure == Empty ;
    }]] ;
}

- (BOOL)isWinningForFigure:(Figure)figure {
    return
        ([self.board objectAtIndex:0].figure == figure && [self.board objectAtIndex:1].figure == figure && [self.board objectAtIndex:2].figure == figure) ||
        ([self.board objectAtIndex:3].figure == figure && [self.board objectAtIndex:4].figure == figure && [self.board objectAtIndex:5].figure == figure) ||
        ([self.board objectAtIndex:6].figure == figure && [self.board objectAtIndex:7].figure == figure && [self.board objectAtIndex:8].figure == figure) ||

        ([self.board objectAtIndex:0].figure == figure && [self.board objectAtIndex:3].figure == figure && [self.board objectAtIndex:6].figure == figure) ||
        ([self.board objectAtIndex:1].figure == figure && [self.board objectAtIndex:4].figure == figure && [self.board objectAtIndex:7].figure == figure) ||
        ([self.board objectAtIndex:2].figure == figure && [self.board objectAtIndex:5].figure == figure && [self.board objectAtIndex:8].figure == figure) ||
        
        ([self.board objectAtIndex:0].figure == figure && [self.board objectAtIndex:4].figure == figure && [self.board objectAtIndex:8].figure == figure) ||
        ([self.board objectAtIndex:2].figure == figure && [self.board objectAtIndex:4].figure == figure && [self.board objectAtIndex:6].figure == figure)
    ;
}

- (BOOL)isFinished {
    for (Move *move in self.board) {
        if (move.figure == Empty) {
            return NO ;
        }
    }
    
    return YES ;
}

- (void)addPlayer:(Player *)player {
    [players addObject:player] ;
}

- (Player *)currentPlayer {
    if (players.count == 0) {
        current = 0 ;
        return nil ;
    }
    
    if (current > players.count-1) {
        current = 0 ;
    }
    
    return [players objectAtIndex:current] ;
}

- (void)nextPlayer {
    current++ ;
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    [self.board objectAtIndex:index].figure = player.figure ;

    for (Player *p in players) {
        if (p != player) {
            [p player:player didMoveTo:index] ;
        }
    }
    
    if (self.delegate) {
        [self.delegate game:self player:player didMoveTo:index] ;
    }
}

- (void)playerDidReset:(Player *)player {
    [self resetBoard] ;
    
    for (Player *p in players) {
        if (p != player) {
            [p playerDidReset:player] ;
        }
    }

    if (self.delegate) {
        [self.delegate game:self playerDidReset:player] ;
    }
}

- (void)player:(Player *)player didChangeState:(BOOL)state {
    for (Player *p in players) {
        if (p != player) {
            [p player:player didChangeState:state] ;
        }
    }
    
    if (self.delegate) {
        [self.delegate game:self player:player didChangeState:state] ;
    }
}

@end
