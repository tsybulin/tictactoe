//
//  InterfaceController.h
//  Watch Extension
//
//  Created by Pavel Tsybulin on 3/13/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Game.h"

@interface WEGameController : WKInterfaceController

@property (nonatomic, strong) Game *game ;

@end
