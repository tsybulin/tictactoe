//
//  WatchPlayer.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/19/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WatchPlayer.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "Game.h"
#import "Move.h"

@interface WatchPlayer () <WCSessionDelegate>

@end

@implementation WatchPlayer

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
    if (player == self) {
        [self.game resetBoard] ;
    } else {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ([session isPaired] && [session isWatchAppInstalled]) {
                TranspDict *dict = [Move transpDictReset] ;
                [session sendMessage:dict replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"playerDidReset sendMessage error %@", error) ;
                }] ;
            }
        }
    }
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    if (player == self) {
        [self.game.board objectAtIndex:index].figure = self.figure ;
    } else {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ([session isPaired] && [session isWatchAppInstalled]) {
                TranspDict *dict = [[Move moveWithIndex:index andFigure:player.figure] transpDict] ;
                [session sendMessage:dict replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"playerDidMoveTo sendMessage error %@", error) ;
                }] ;
            }
        }
    }
}

#pragma mark - <WCSessionDelegate>

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

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    if (activationState == WCSessionActivationStateActivated) {
        if ([session isReachable] && [session isPaired] && [session isWatchAppInstalled]) {
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

- (void)session:(WCSession *)session didReceiveApplicationContext:(TranspDict *)applicationContext {
    [self didReceiveData:applicationContext] ;
}

- (void)session:(WCSession *)session didReceiveMessage:(TranspDict *)message {
    [self didReceiveData:message] ;
}

@end
