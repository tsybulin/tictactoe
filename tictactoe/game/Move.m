//
//  Move.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Move.h"

@interface Move () {
    NSInteger _score ;
}

@end
@implementation Move

- (instancetype)init {
    if (self = [super init]) {
        self.figure = Empty ;
        self.index = 0 ;
    }
    return self ;
}

+ (instancetype)moveWithIndex:(NSInteger)index andFigure:(Figure)figure {
    Move *move = [[Move alloc] init] ;
    move.index = index ;
    move.figure = figure ;
    return move ;
}

- (NSString *)description {
    NSString *figure ;
    if (self.figure == Zero) {
        figure = @"Zero" ;
    } else if (self.figure == Cross) {
        figure = @"Cross" ;
    } else {
        figure = @"Empty" ;
    }
    return [NSString stringWithFormat:@"Move figure %@, index %ld, score %ld", figure, (long)self.index, (long)_score] ;
}

- (NSString *)caption {
    if (self.figure == Zero) {
        return @"0" ;
    } else if (self.figure == Cross) {
        return @"X" ;
    }
    
    return @" " ;
}

@end
