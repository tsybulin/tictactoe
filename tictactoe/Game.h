//
//  Game.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"

typedef NSArray<Move *> Board ;

@interface Game : NSObject

@property (nonatomic, strong) Board *board ;

- (void)resetBoard ;
- (Board *)availableMoves ;
- (BOOL)isWinningForFigure:(Figure)figure ;
- (BOOL)isFinished ;

@end
