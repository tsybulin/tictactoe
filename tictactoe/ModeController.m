//
//  ModeController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/15/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "ModeController.h"
#import "GameController.h"
#import "SingleGame.h"
#import "WatchGame.h"
#import "PairGame.h"
#import "NetworkGame.h"

@interface ModeController ()

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
        ((GameController *) segue.destinationViewController).singleGame = [[SingleGame alloc] init] ;
        ((GameController *) segue.destinationViewController).watchGame = nil ;
        ((GameController *) segue.destinationViewController).pairGame = nil ;
        return ;
    } else if ([@"WatchGame" isEqualToString:segue.identifier]) {
        ((GameController *) segue.destinationViewController).singleGame = nil ;
        ((GameController *) segue.destinationViewController).watchGame = [[WatchGame alloc] init] ;
        ((GameController *) segue.destinationViewController).pairGame = nil ;
        return ;
    } else if ([@"PairGame" isEqualToString:segue.identifier]) {
        ((GameController *) segue.destinationViewController).singleGame = nil ;
        ((GameController *) segue.destinationViewController).watchGame = nil ;
        ((GameController *) segue.destinationViewController).pairGame = [[PairGame alloc] init] ;
        return ;
    } else if ([@"NetworkGame" isEqualToString:segue.identifier]) {
        ((GameController *) segue.destinationViewController).networkGame = [[NetworkGame alloc] init] ;
        return ;
    }
}

@end
