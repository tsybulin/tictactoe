//
//  NetworkGame.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/17/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NetworkGame ;

@protocol NetworkGameDelegate <NSObject>

- (void)networkGame:(NetworkGame *)networkGame didChangeState:(BOOL)network ;
- (void)networkGame:(NetworkGame *)networkGame didMoveTo:(NSInteger)index ;
- (void)resetFromNetworkGame:(NetworkGame *)networkGame ;
- (void)stopFromNetworkGame:(NetworkGame *)networkGame ;

@end

@interface NetworkGame : NSObject

@property (nonatomic, readonly) BOOL network, initiated, paired ;
@property (nonatomic, strong) id<NetworkGameDelegate> delegate ;

- (void)postInitWithName:(NSString *)name ;
- (void)pair:(UIViewController *)viewController ;
- (void)moveTo:(NSInteger)index ;
- (void)reset ;
- (void)stop ;

@end
