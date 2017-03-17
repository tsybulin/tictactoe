//
//  WatchGame.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/15/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WatchGame.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface WatchGame () <WCSessionDelegate>

@end

@implementation WatchGame

- (instancetype)init {
    if (self = [super init]) {
        self.watch = NO ;
    }
    
    return self ;
}

- (void)cooperate:(BOOL)watch {
    if (watch) {
        self.watch = YES ;
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            session.delegate = self ;
            [session activateSession] ;
            
            if (self.delegate) {
                [self.delegate resetFromWatchGame:self] ;
            }
            
        } else {
            self.watch = NO ;
        }
    } else {
        self.watch = NO ;
        
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ([session isReachable] && [session isPaired] && [session isWatchAppInstalled]) {
                [session sendMessage:@{@"action": @"stop"} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"WCSession activationDidCompleteWithState error %@", error) ;
                }] ;
            }
        }
    }
    
    if (self.delegate) {
        [self.delegate watchGame:self didChangeState:self.watch] ;
    }
}

- (void)moveTo:(NSInteger)index {
    if (self.watch) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ([session isPaired] && [session isWatchAppInstalled]) {
                [session sendMessage:@{@"action": @"move", @"index" : [NSNumber numberWithLong:index]} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"WCSession sendMessage error %@", error) ;
                }] ;
            }
        }
    }
}

- (void)reset {
    if (self.watch) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ((session.activationState == WCSessionActivationStateActivated) && [session isReachable] && [session isPaired] && [session isWatchAppInstalled]) {
                [session sendMessage:@{@"action": @"reset"} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"WCSession onReset error %@", error) ;
                }] ;
            }
        }
    }
}

- (void)didReceiveDictionary:(NSDictionary<NSString *, id> *)dict {
    NSString *action = [dict objectForKey:@"action"] ;
    if (self.delegate) {
        if ([@"move" isEqualToString:action]) {
            [self.delegate watchGame:self didMoveTo:[[dict objectForKey:@"index"] longValue]] ;
        } else if ([@"reset" isEqualToString:action]) {
            [self.delegate resetFromWatchGame:self] ;
        }
    }
}

#pragma mark <WCSessionDelegate>

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    if (activationState == WCSessionActivationStateActivated) {
        if ([session isReachable] && [session isPaired] && [session isWatchAppInstalled]) {
            self.watch = YES ;
        } else {
            self.watch = NO ;
            if (self.delegate) {
                [self.delegate watchGame:self didChangeState:NO] ;
            }
        }
    }
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    self.watch = NO ;
    if (self.delegate) {
        [self.delegate watchGame:self didChangeState:NO] ;
    }
}

- (void)sessionDidDeactivate:(WCSession *)session {
    self.watch = NO ;
    if (self.delegate) {
        [self.delegate watchGame:self didChangeState:NO] ;
    }
}


- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
    [self didReceiveDictionary:applicationContext] ;
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message {
    [self didReceiveDictionary:message] ;
}


@end
