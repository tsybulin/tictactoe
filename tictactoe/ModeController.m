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
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;
        
        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"Human"] ;
        human.game = game ;
        [game addPlayer:human] ;
        
        Player *computer = [[MinimaxPlayer alloc] initWithFigure:Zero name:@"Computer"] ;
        computer.game = game ;
        [game addPlayer:computer] ;

        return ;
    } else if ([@"WatchGame" isEqualToString:segue.identifier]) {
        GameController *controller = (GameController *) segue.destinationViewController ;
        Game *game = [[Game alloc] init] ;
        controller.game = game ;
        game.delegate = controller ;
        
        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"Human"] ;
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
        ((GameController *) segue.destinationViewController).networkGame = [[NetworkGame alloc] init] ;
        return ;
    }
}

@end
