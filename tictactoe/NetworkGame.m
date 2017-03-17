//
//  NetworkGame.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/17/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "NetworkGame.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface NetworkGame () <MCSessionDelegate, MCBrowserViewControllerDelegate> {
    MCPeerID *localPeerID ;
    MCSession *session ;
    MCBrowserViewController *browser ;
    MCAdvertiserAssistant *advertiser ;
    NSMutableArray<MCPeerID *> *peers ;
}

@end

@implementation NetworkGame

- (instancetype)init {
    if (self = [super init]) {
        _network = NO ;
        _initiated = NO ;
        _paired = NO ;
        peers = [NSMutableArray arrayWithCapacity:0] ;
    }
    return self ;
}

- (void)dealloc {
    [session disconnect] ;
}

- (void)postInitWithName:(NSString *)name {
    _initiated = YES ;
    localPeerID = [[MCPeerID alloc] initWithDisplayName:name] ;
    session = [[MCSession alloc] initWithPeer:localPeerID] ;
    session.delegate = self ;
    browser = [[MCBrowserViewController alloc] initWithServiceType:@"tic-tac-toe" session:session] ;
    browser.maximumNumberOfPeers = 2 ;
    browser.minimumNumberOfPeers = 2 ;
    browser.delegate = self ;
    advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"tic-tac-toe" discoveryInfo:nil session:session] ;
}

- (void)pair:(UIViewController *)viewController {
    _paired = YES ;
    [advertiser start] ;
    [viewController presentViewController:browser animated:YES completion:^{
        NSLog(@"MCBrowserCcntroller presented") ;
    }] ;
}

- (void)moveTo:(NSInteger)index {
    NSError *error ;
    [session sendData:[NSKeyedArchiver archivedDataWithRootObject:@{@"action": @"move", @"index" : [NSNumber numberWithLong:index]}] toPeers:peers withMode:MCSessionSendDataReliable error:&error] ;
    if (error) {
        NSLog(@"Session send error %@", error) ;
    }
}

- (void)reset {
    NSError *error ;
    [session sendData:[NSKeyedArchiver archivedDataWithRootObject:@{@"action": @"reset"}] toPeers:peers withMode:MCSessionSendDataReliable error:&error] ;
    if (error) {
        NSLog(@"Session send error %@", error) ;
    }
}

- (void)stop {
    NSError *error ;
    [session sendData:[NSKeyedArchiver archivedDataWithRootObject:@{@"action": @"stop"}] toPeers:peers withMode:MCSessionSendDataReliable error:&error] ;
    if (error) {
        NSLog(@"Session send error %@", error) ;
    }
}

#pragma mark - <MCSessionDelegate>

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"peer %@ didChangeState %ld", peerID, (long)state) ;
    
    if (state == MCSessionStateConnected) {
        NSLog(@"connected peer %@", peerID) ;
        [peers addObject:peerID] ;
    } else if (state == MCSessionStateNotConnected) {
        NSLog(@"disconnected peer %@", peerID) ;
        [peers removeObject:peerID] ;
    }
    
    if (peers.count == 1) {
        _network = YES ;
    } else {
        _network = NO ;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    NSString *action = [dict objectForKey:@"action"] ;

    if (self.delegate) {
        if ([@"move" isEqualToString:action]) {
            [self.delegate networkGame:self didMoveTo:[[dict objectForKey:@"index"] longValue]] ;
        } else if ([@"reset" isEqualToString:action]) {
            [self.delegate resetFromNetworkGame:self] ;
        } else if ([@"stop" isEqualToString:action]) {
            [self.delegate stopFromNetworkGame:self] ;
        }
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error {
}

#pragma mark - <MCBrowserViewControllerDelegate>

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    NSLog(@"MCBrowserCcntroller didFinish") ;
    
    [advertiser stop] ;

    if (peers.count == 1) {
        [browser dismissViewControllerAnimated:YES completion:^{
            if (self.delegate) {
                [self.delegate networkGame:self didChangeState:YES] ;
            }
        }] ;
    }
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    NSLog(@"MCBrowserCcntroller wasCancelled") ;
    
    [advertiser stop] ;

    [browser dismissViewControllerAnimated:YES completion:^{
        _network = NO ;

        if (self.delegate) {
            [self.delegate networkGame:self didChangeState:NO] ;
        }
    }] ;
}

@end
