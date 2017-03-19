//
//  Game.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"
#import "Player.h"

typedef NSArray<Move *> Board ;

@class Game ;

@protocol GameDelegate <NSObject>

- (void)game:(Game *)game player:(Player *)player didMoveTo:(NSInteger)index ;
- (void)game:(Game *)game playerDidReset:(Player *)player ;
- (void)game:(Game *)game player:(Player *)player didChangeState:(BOOL)state ;

@end

@interface Game : NSObject

@property (nonatomic, strong) Board *board ;
@property (nonatomic, strong) id<GameDelegate> delegate ;

- (void)resetBoard ;
- (Board *)availableMoves ;
- (BOOL)isWinningForFigure:(Figure)figure ;
- (BOOL)isFinished ;
- (void)addPlayer:(Player *)player ;
- (Player *)currentPlayer ;
- (void)nextPlayer ;
- (void)player:(Player *)player didMoveTo:(NSInteger)index ;
- (void)playerDidReset:(Player *)player ;
- (void)player:(Player *)player didChangeState:(BOOL)state ;

@end
