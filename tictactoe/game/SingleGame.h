//
//  SingleGame.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move+Score.h"
#import "Game.h"

@protocol SingleGameDelegate <NSObject>

- (void)didMove:(Move *)move ;

@end

@interface SingleGame : NSObject

@property (nonatomic, strong) Game *game ;
@property (nonatomic, strong) id<SingleGameDelegate> delegate ;

- (void)move ;

@end
