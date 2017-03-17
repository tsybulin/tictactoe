//
//  WatchGame.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/15/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WatchGame ;

@protocol WatchGameDelegate <NSObject>

- (void)watchGame:(WatchGame *)watchGame didChangeState:(BOOL)watch ;
- (void)watchGame:(WatchGame *)watchGame didMoveTo:(NSInteger)index ;
- (void)resetFromWatchGame:(WatchGame *)watchGame ;

@end

@interface WatchGame : NSObject

@property (nonatomic) BOOL watch ;
@property (nonatomic, strong) id<WatchGameDelegate> delegate ;

- (void)cooperate:(BOOL)watch ;
- (void)moveTo:(NSInteger)index ;
- (void)reset ;

@end
