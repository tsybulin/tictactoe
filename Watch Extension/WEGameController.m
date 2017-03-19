//
//  InterfaceController.m
//  Watch Extension
//
//  Created by Pavel Tsybulin on 3/13/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "WEGameController.h"
#import "Game.h"

@interface WEGameController() <GameDelegate> {
    NSArray<NSString *> *imgs ;
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

    cells = @[
        self.cell0, self.cell1, self.cell2,
        self.cell3, self.cell4, self.cell5,
        self.cell6, self.cell7, self.cell8,
    ] ;

    imgs = @[@"wempty", @"wzero", @"wcross"] ;
    
    if (context) {
        if ([@"SingleGame" isEqualToString:[context objectForKey:@"segue"]]) {
            self.game = [context objectForKey:@"game"] ;
        } else if ([@"PhoneGame" isEqualToString:[context objectForKey:@"segue"]]) {
            self.game = [context objectForKey:@"game"] ;
        }
    }
    
    self.game.delegate = self ;

    [self updateBoard] ;
}

- (void)willActivate {
    [super willActivate] ;
    
    self.self.lblMode.text = [self.game currentPlayer].name ;

    for (WKInterfaceButton *button in cells) {
        [button setEnabled:[self.game currentPlayer].interactive] ;
    }
    
    //    if (self.singleGame) {
//        [self.lblMode setText:@"Single"] ;
//        self.singleGame.game = game ;
//        self.singleGame.delegate = self ;
//    } else {
//        [self.lblMode setText:@"iPhone"] ;
//        
//        if ([WCSession isSupported]) {
//            WCSession *wcsession = [WCSession defaultSession] ;
//            wcsession.delegate = self ;
//            [wcsession activateSession] ;
//        } else {
//            [self.lblMode setText:@"Single"] ;
//        }
//    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateBoard {
    for (Move *move in self.game.board) {
        WKInterfaceButton *button = [cells objectAtIndex:move.index] ;
        [button setBackgroundImageNamed:[imgs objectAtIndex:move.figure]] ;
    }
}

- (void)showBanner:(NSString *)banner {
    self.lblBanner.text = banner ;
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
    if ([self.game.board objectAtIndex:tag].figure != Empty) {
        return ;
    }

    [self.game player:[self.game currentPlayer] didMoveTo:tag] ;
}

- (IBAction)onReset {
    [self.game playerDidReset:[self.game currentPlayer]] ;
}

#pragma mark - <GameDelegate>

- (void)game:(Game *)game player:(Player *)player didMoveTo:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateBoard] ;
        
        if ([self.game isWinningForFigure:player.figure]) {
            [self showBanner:[player.name stringByAppendingString:@" won"]] ;
            return ;
        }
        
        if ([self.game isFinished]) {
            [self showBanner:@"Tie"] ;
            return ;
        }

        [self.game nextPlayer] ;
        Player *nextPlayer = [self.game currentPlayer] ;

        for (WKInterfaceButton *button in cells) {
            [button setEnabled:nextPlayer.interactive] ;
        }

        self.self.lblMode.text = nextPlayer.name ;
    }) ;
}

- (void)game:(Game *)game playerDidReset:(Player *)player {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateBoard] ;
        self.viBanner.hidden = YES ;
        self.self.lblMode.text = [self.game currentPlayer].name ;
        
        for (WKInterfaceButton *button in cells) {
            [button setEnabled:[self.game currentPlayer].interactive] ;
        }
    }) ;
}

- (void)game:(Game *)game player:(Player *)player didChangeState:(BOOL)state {
    if (!state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popController] ;
        }) ;
    }
}


@end



