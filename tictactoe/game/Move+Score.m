//
//  Move+Score.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/18/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Move+Score.h"

@implementation Move (Score)

- (NSInteger)score {
    return _score ;
}

- (void)setScore:(NSInteger)score {
    _score = score ;
}

@end
