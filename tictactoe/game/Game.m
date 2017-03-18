//
//  Game.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Game.h"
#import "Figure.h"

@implementation Game

- (instancetype)init {
    if (self = [super init]) {
        self.board = @[
            [Move moveWithIndex:0 andFigure:Empty], [Move moveWithIndex:1 andFigure:Empty], [Move moveWithIndex:2 andFigure:Empty],
            [Move moveWithIndex:3 andFigure:Empty], [Move moveWithIndex:4 andFigure:Empty], [Move moveWithIndex:5 andFigure:Empty],
            [Move moveWithIndex:6 andFigure:Empty], [Move moveWithIndex:7 andFigure:Empty], [Move moveWithIndex:8 andFigure:Empty]
        ] ;

    }

    return self ;
}

- (void)resetBoard {
    for (Move *move in self.board) {
//        move.score = 0 ;
        move.figure = Empty ;
    }
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

@end
