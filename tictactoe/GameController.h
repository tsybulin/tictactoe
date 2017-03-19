//
//  ViewController.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Player.h"

@interface GameController : UIViewController <GameDelegate>

@property (nonatomic, strong) Game *game ;

@end

