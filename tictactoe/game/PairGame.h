//
//  PairGame.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figure.h"

@interface PairGame : NSObject

@property (nonatomic, readonly) Figure figure ;

- (void)flipFigure ;
- (void)reset ;

@end
