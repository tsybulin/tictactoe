//
//  WEModeController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/16/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WEModeController.h"
#import "SingleGame.h"

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
        return @{@"segue" : @"SingleGame", @"singleGame" : [[SingleGame alloc] init]} ;
    }
    
    return [super contextForSegueWithIdentifier:segueIdentifier] ;
}

@end



