//
//  NetworkPlayer.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/19/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface NetworkPlayer : Player <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session ;
@property (nonatomic, strong)  NSArray<MCPeerID *> *peers ;

@end
