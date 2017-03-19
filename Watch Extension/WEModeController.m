//
//  WEModeController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WEModeController.h"
#import "Game.h"
#import "LocalPlayer.h"
#import "MinimaxPlayer.h"
#import "PhonePlayer.h"

@interface WEModeController ()

@end

@implementation WEModeController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (nullable id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([@"SingleGame" isEqualToString:segueIdentifier]) {
        Game *game = [[Game alloc] init] ;
        
        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"Human"] ;
        human.game = game ;
        [game addPlayer:human] ;

        Player *computer = [[MinimaxPlayer alloc] initWithFigure:Zero name:@"Computer"] ;
        computer.game = game ;
        [game addPlayer:computer] ;

        return @{@"segue" : @"SingleGame", @"game" : game} ;
    } else if ([@"PhoneGame" isEqualToString:segueIdentifier]) {
        Game *game = [[Game alloc] init] ;
        
        Player *phone = [[PhonePlayer alloc] initWithFigure:Zero name:@"Phone"] ;
        phone.game = game ;
        [game addPlayer:phone] ;

        Player *human = [[LocalPlayer alloc] initWithFigure:Cross name:@"Human"] ;
        human.game = game ;
        [game addPlayer:human] ;
        

        return @{@"segue" : @"PhoneGame", @"game" : game} ;
    }
    
    return [super contextForSegueWithIdentifier:segueIdentifier] ;
}

@end



