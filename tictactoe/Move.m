//
//  Move.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Move.h"

@implementation Move

- (instancetype)init {
    if (self = [super init]) {
        self.player = Empty ;
        self.score = 0 ;
        self.index = 0 ;
    }
    return self ;
}

+ (instancetype)moveWithIndex:(NSInteger)index andPlayer:(Player)player {
    Move *move = [[Move alloc] init] ;
    move.index = index ;
    move.player = player ;
    return move ;
}

- (NSString *)description {
    NSString *player ;
    if (self.player == Human) {
        player = @"Human" ;
    } else if (self.player == Computer) {
        player = @"Computer" ;
    } else {
        player = @"Empty" ;
    }
    return [NSString stringWithFormat:@"Move player %@, index %ld, score %ld", player, (long)self.index, (long)self.score] ;
}

- (NSString *)caption {
    if (self.player == Human) {
        return @"0" ;
    } else if (self.player == Computer) {
        return @"X" ;
    }
    
    return @" " ;
}

@end
