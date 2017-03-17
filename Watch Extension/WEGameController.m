//
//  InterfaceController.m
//  Watch Extension
//
//  Created by Pavel Tsybulin on 3/13/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WEGameController.h"
#import "Game.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface WEGameController() <SingleGameDelegate, WCSessionDelegate> {
    NSArray<NSString *> *imgs ;
    Game *game ;
    NSArray<WKInterfaceButton *> *cells ;
}

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblMode;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell0;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell4;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell5;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell6;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell7;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cell8;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *viBanner;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblBanner;

@end


@implementation WEGameController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    game = [[Game alloc] init] ;
    cells = @[
        self.cell0, self.cell1, self.cell2,
        self.cell3, self.cell4, self.cell5,
        self.cell6, self.cell7, self.cell8,
    ] ;

    imgs = @[@"wempty", @"whuman", @"wcomputer"] ;
    
    [self updateBoard] ;
    
    if (context) {
        if ([@"SingleGame" isEqualToString:[context objectForKey:@"segue"]]) {
            self.singleGame = [context objectForKey:@"singleGame"] ;
        } else {
            self.singleGame = nil ;
        }
    }
}

- (void)willActivate {
    [super willActivate] ;
    
    if (self.singleGame) {
        [self.lblMode setText:@"Single"] ;
        self.singleGame.game = game ;
        self.singleGame.delegate = self ;
    } else {
        [self.lblMode setText:@"iPhone"] ;
        
        if ([WCSession isSupported]) {
            WCSession *wcsession = [WCSession defaultSession] ;
            wcsession.delegate = self ;
            [wcsession activateSession] ;
        } else {
            [self.lblMode setText:@"Single"] ;
        }
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateBoard {
    for (Move *move in game.board) {
        WKInterfaceButton *button = [cells objectAtIndex:move.index] ;
        [button setBackgroundImageNamed:[imgs objectAtIndex:move.player]] ;
    }
}

- (void)showBanner:(Player)player {
    if (player == Empty) {
        self.lblBanner.text = @"Tie" ;
    } else if (player == Human) {
        self.lblBanner.text = @"You won" ;
    } else {
        self.lblBanner.text = @"You lose" ;
    }
    
    self.viBanner.hidden = NO ;
}

- (IBAction)onHuman0 {
    [self onHuman:0] ;
}

- (IBAction)onHuman1 {
    [self onHuman:1] ;
}

- (IBAction)onHuman2 {
    [self onHuman:2] ;
}

- (IBAction)onHuman3 {
    [self onHuman:3] ;
}

- (IBAction)onHuman4 {
    [self onHuman:4] ;
}

- (IBAction)onHuman5 {
    [self onHuman:5] ;
}

- (IBAction)onHuman6 {
    [self onHuman:6] ;
}

- (IBAction)onHuman7 {
    [self onHuman:7] ;
}

- (IBAction)onHuman8 {
    [self onHuman:8] ;
}

- (void)onHuman:(NSInteger)tag {
    if ([game.board objectAtIndex:tag].player != Empty) {
        return ;
    }

    [game.board objectAtIndex:tag].player = Human ;
    [self updateBoard] ;
    
    for (WKInterfaceButton *button in cells) {
        [button setEnabled:NO] ;
    }
    
    if (!self.singleGame) {
        if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession] ;
            if ([session isReachable]) {
                [session sendMessage:@{@"action": @"move", @"index" : [NSNumber numberWithLong:tag]} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"WCSession sendMessage error %@", error) ;
                }] ;
            } else {
                NSError *error = nil ;
                [session updateApplicationContext:@{@"action": @"move", @"index" : [NSNumber numberWithLong:tag]} error:&error] ;
                if (error) {
                    NSLog(@"WCSession updateApplicationContext error %@", error) ;
                }
            }
        }
    }
    
    if ([game isWinningForPlayer:Human]) {
        [self showBanner:Human] ;
        return ;
    }
    
    if ([game isFinished]) {
        [self showBanner:Empty] ;
        return ;
    }
    
    if (self.singleGame) {
        [self.singleGame move] ;
    }
}

- (void)resetBoard {
    [game resetBoard] ;
    
    [self updateBoard] ;
    
    for (WKInterfaceButton *button in cells) {
        [button setEnabled:YES] ;
    }
    
    self.viBanner.hidden = YES ;
}

- (IBAction)onReset {
    [self resetBoard] ;
    
    if (!self.singleGame) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession] ;
            if ([session isReachable]) {
                [session sendMessage:@{@"action": @"reset"} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"WCSession sendMessage error %@", error) ;
                }] ;
            } else {
                NSError *error = nil ;
                [session updateApplicationContext:@{@"action": @"reset"} error:&error] ;
                if (error) {
                    NSLog(@"WCSession updateApplicationContext error %@", error) ;
                }
            }
        }
    }
    
}

#pragma mark <SingleGameDelegate>

- (void)didMove:(Move *)move {
    [game.board objectAtIndex:move.index].player = move.player ;
    [self updateBoard] ;
    
    if ([game isWinningForPlayer:Computer]) {
        [self showBanner:Computer] ;
        return ;
    }
    
    if ([game isFinished]) {
        [self showBanner:Empty] ;
        return ;
    }

    for (WKInterfaceButton *button in cells) {
        [button setEnabled:YES] ;
    }
}

#pragma mark <WCSessionDelegate>

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    
}

- (void)sessionDidDeactivate:(WCSession *)session {
    [self dismissController] ;
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message {
    NSString *action = [message objectForKey:@"action"] ;
    if (action) {
        if ([@"start" isEqualToString:action]) {
            return ;
        }
        
        if ([@"stop" isEqualToString:action]) {
            [self popController] ;
            return ;
        }

        if ([@"reset" isEqualToString:action]) {
            [self resetBoard] ;
            return ;
        }

        if ([@"move" isEqualToString:action]) {
            Move *move = [[Move alloc] init] ;
            move.player = Computer ;
            move.index = [[message objectForKey:@"index"] longValue] ;
            
            [self didMove:move] ;
        }
    }
}

@end



