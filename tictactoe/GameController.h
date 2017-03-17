//
//  ViewController.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleGame.h"
#import "WatchGame.h"
#import "PairGame.h"

@interface GameController : UIViewController

@property (nonatomic, strong) SingleGame *singleGame ;
@property (nonatomic, strong) WatchGame *watchGame ;
@property (nonatomic, strong) PairGame *pairGame ;

@end

