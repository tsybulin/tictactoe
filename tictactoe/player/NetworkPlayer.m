//
//  NetworkPlayer.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/19/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "NetworkPlayer.h"
#import "Game.h"
#import "Move.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@implementation NetworkPlayer

- (void)playerDidReset:(Player *)player {
    NSError *error ;
    [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:[Move transpDictReset]] toPeers:self.peers withMode:MCSessionSendDataReliable error:&error] ;
    if (error) {
        NSLog(@"Session send error %@", error) ;
    }
}

- (void)player:(Player *)player didChangeState:(BOOL)state {
    if (!state) {
        NSError *error ;
        [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:[Move transpDictStop]] toPeers:self.peers withMode:MCSessionSendDataReliable error:&error] ;
        if (error) {
            NSLog(@"Session send error %@", error) ;
        }
    }
}

- (void)player:(Player *)player didMoveTo:(NSInteger)index {
    NSError *error ;
    [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:[Move transpDictMove:index]] toPeers:self.peers withMode:MCSessionSendDataReliable error:&error] ;
    if (error) {
        NSLog(@"Session send error %@", error) ;
    }
}

#pragma mark - <MCSessionDelegate>

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateNotConnected) {
        [self.game player:self didChangeState:NO] ;
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error {
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    TranspDict *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    NSString *action = [dict objectForKey:TD_ACTION] ;

    if ([TD_RESET isEqualToString:action]) {
        [self.game playerDidReset:self] ;
    } else if ([TD_MOVE isEqualToString:action]) {
        [self.game player:self didMoveTo:[[dict objectForKey:TD_INDEX] longValue]] ;
    } else if ([TD_STOP isEqualToString:action]) {
        [self.game player:self didChangeState:NO] ;
    }
    
}

@end
