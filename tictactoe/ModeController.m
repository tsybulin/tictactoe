//
//  ModeController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/15/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "ModeController.h"
#import "GameController.h"
#import "Game.h"
#import "Player.h"
#import "LocalPlayer.h"
#import "MinimaxPlayer.h"
#import "WatchPlayer.h"
#import "NetworkPlayer.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ModeController () <MCSessionDelegate, MCBrowserViewControllerDelegate> {
    MCPeerID *localPeerID ;
    MCSession *session ;
    MCBrowserViewController *browser ;
    MCAdvertiserAssistant *advertiser ;
    NSMutableArray<MCPeerID *> *peers ;
}

@end

@implementation ModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"SingleGame" isEqualToString:segue.identifier]) {
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;
        
        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"You"] ;
        human.game = game ;
        [game addPlayer:human] ;
        
        Player *computer = [[MinimaxPlayer alloc] initWithFigure:Zero name:[UIDevice currentDevice].name] ;
        computer.game = game ;
        [game addPlayer:computer] ;

        return ;
    } else if ([@"WatchGame" isEqualToString:segue.identifier]) {
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;
        
        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"You"] ;
        human.game = game ;
        [game addPlayer:human] ;

        Player *watch = [[WatchPlayer alloc] initWithFigure:Zero name:@"Watch"] ;
        watch.game = game ;
        [game addPlayer:watch] ;

        return ;
    } else if ([@"PairGame" isEqualToString:segue.identifier]) {
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;

        Player *cross = [[LocalPlayer alloc] initWithFigure:Cross name:@"Cross"] ;
        cross.game = game ;
        [game addPlayer:cross] ;

        Player *zero = [[LocalPlayer alloc] initWithFigure:Zero name:@"Zero"] ;
        zero.game = game ;
        [game addPlayer:zero] ;

        return ;
    } else if ([@"NetworkGame" isEqualToString:segue.identifier]) {
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;
        
        // To detect Players order
        if ([localPeerID.displayName compare:[peers firstObject].displayName] == NSOrderedAscending) {
            Player *cross = [[LocalPlayer alloc] initWithFigure:Cross name:localPeerID.displayName] ;
            cross.game = game ;
            [game addPlayer:cross] ;
            
            NetworkPlayer *zero = [[NetworkPlayer alloc] initWithFigure:Zero name:[peers firstObject].displayName] ;
            zero.game = game ;
            zero.session = session ;
            zero.peers = peers ;
            session.delegate = zero ;
            [game addPlayer:zero] ;
        } else {
            NetworkPlayer *zero = [[NetworkPlayer alloc] initWithFigure:Zero name:[peers firstObject].displayName] ;
            zero.game = game ;
            zero.session = session ;
            zero.peers = peers ;
            session.delegate = zero ;
            [game addPlayer:zero] ;

            Player *cross = [[LocalPlayer alloc] initWithFigure:Cross name:localPeerID.displayName] ;
            cross.game = game ;
            [game addPlayer:cross] ;
        }

        return ;
    }
}

- (IBAction)onNetworkGame:(id)sender {
    if (!peers) {
        peers = [NSMutableArray arrayWithCapacity:0] ;
    } else {
        [peers removeAllObjects] ;
    }
    
    if (!localPeerID) {
        localPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name] ;
    }
    
    if (session) {
        [session disconnect] ;
    }

    session = [[MCSession alloc] initWithPeer:localPeerID] ;
    session.delegate = self ;
    
    browser = [[MCBrowserViewController alloc] initWithServiceType:@"tic-tac-toe" session:session] ;
    browser.maximumNumberOfPeers = 2 ;
    browser.minimumNumberOfPeers = 2 ;
    browser.delegate = self ;
    
    advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"tic-tac-toe" discoveryInfo:nil session:session] ;
    [advertiser start] ;
    
    [self presentViewController:browser animated:YES completion:nil] ;
}

#pragma mark - <MCSessionDelegate>

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        [peers addObject:peerID] ;
    } else if (state == MCSessionStateNotConnected) {
        [peers removeObject:peerID] ;
    }
    
    if (peers.count == 1) {
        [self browserViewControllerDidFinish:browser] ;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error {
}

#pragma mark - <MCBrowserViewControllerDelegate>

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [advertiser stop] ;
    
    if (peers.count == 1) {
        [browser dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"NetworkGame" sender:self] ;
        }] ;
    }
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [advertiser stop] ;
    [browser dismissViewControllerAnimated:YES completion:nil] ;
}



@end
