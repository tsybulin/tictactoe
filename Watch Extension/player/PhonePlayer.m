//
//  PhonePlayer.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/19/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "PhonePlayer.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Game.h"
#import "Move.h"

@interface PhonePlayer () <WCSessionDelegate>

@end

@implementation PhonePlayer

- (instancetype)initWithFigure:(Figure)figure name:(NSString *)name {
    if (self = [super initWithFigure:figure name:name]) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            session.delegate = self ;
            [session activateSession] ;
        }
    }
    
    return self ;
}

- (void)playerDidReset:(Player *)player {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession] ;
        if ([session isReachable]) {
            TranspDict *dict = [Move transpDictReset] ;
            [session sendMessage:dict replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"playerDidReset sendMessage error %@", error) ;
            }] ;
        }
    }
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession] ;
        if ([session isReachable]) {
            TranspDict *dict = [[Move moveWithIndex:index andFigure:player.figure] transpDict] ;
            [session sendMessage:dict replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"playerDidMoveTo sendMessage error %@", error) ;
            }] ;
        }
    }
}

- (void)player:(Player *)player didChangeState:(BOOL)state {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession] ;
        if ([session isReachable] && !state) {
            TranspDict *dict = [Move transpDictStop] ;
            [session sendMessage:dict replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"playerDidReset sendMessage error %@", error) ;
            }] ;
        }
    }
}

- (void)didReceiveData:(TranspDict *)dict {
    NSString *action = [dict objectForKey:TD_ACTION] ;
    
    if ([TD_RESET isEqualToString:action]) {
        [self.game playerDidReset:self] ;
    } else if ([TD_MOVE isEqualToString:action]) {
        [self.game player:self didMoveTo:[[dict objectForKey:TD_INDEX] longValue]] ;
    } else if ([TD_STOP isEqualToString:action]) {
        [self.game player:self didChangeState:NO] ;
    }
}

#pragma mark - <WCSessionDelegate>

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    if (activationState == WCSessionActivationStateActivated) {
        if ([session isReachable]) {
            [self.game player:self didChangeState:YES] ;
        } else {
            [self.game player:self didChangeState:NO] ;
        }
    }
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    [self.game player:self didChangeState:NO] ;
}

- (void)sessionDidDeactivate:(WCSession *)session {
    [self.game player:self didChangeState:NO] ;
}

- (void)session:(WCSession *)session didReceiveMessage:(TranspDict *)message {
    [self didReceiveData:message] ;
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(TranspDict *)applicationContext {
    [self didReceiveData:applicationContext] ;
}

@end
