//
//  Player.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/18/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figure.h"

@class Game ;

@interface Player : NSObject

@property (nonatomic, readonly) Figure figure ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic) BOOL interactive ;
@property (nonatomic, strong) Game *game ;

- (instancetype)init NS_UNAVAILABLE ;
- (instancetype)initWithFigure:(Figure)figure name:(NSString *)name NS_DESIGNATED_INITIALIZER ;
- (void)player:(Player *)player didMoveTo:(NSInteger)index ;
- (void)playerDidReset:(Player *)player ;
- (void)player:(Player *)player didChangeState:(BOOL)state ;

@end
