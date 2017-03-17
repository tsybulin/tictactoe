//
//  WatchGame.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/15/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WatchGameDelegate <NSObject>

- (void)watchStateDidChange:(BOOL)watch ;
- (void)didReceiveDictionary:(NSDictionary<NSString *, id> *)dictionary ;
- (void)reset ;

@end

@interface WatchGame : NSObject

@property (nonatomic) BOOL watch ;
@property (nonatomic, strong) id<WatchGameDelegate> delegate ;

- (void)cooperate:(BOOL)watch ;
- (void)moveTo:(NSInteger)index ;
- (void)reset ;

@end
