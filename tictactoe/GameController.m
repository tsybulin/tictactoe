//
//  ViewController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "GameController.h"
#import "Game.h"

@interface GameController () <SingleGameDelegate, WatchGameDelegate> {
    Game *game ;
    NSArray<UIButton *> *cells ;
    NSArray<UIImage *> *imgs ;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIStackView *svButtons ;
@property (weak, nonatomic) IBOutlet UIView *viBanner;
@property (weak, nonatomic) IBOutlet UILabel *lblBanner;

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    game = [[Game alloc] init] ;

    cells = @[
        [self.view viewWithTag:1],
        [self.view viewWithTag:2],
        [self.view viewWithTag:3],
        [self.view viewWithTag:4],
        [self.view viewWithTag:5],
        [self.view viewWithTag:6],
        [self.view viewWithTag:7],
        [self.view viewWithTag:8],
        [self.view viewWithTag:9]
    ] ;
    
    imgs = @[
        [UIImage imageNamed:@"empty"],
        [UIImage imageNamed:@"human"],
        [UIImage imageNamed:@"computer"]
    ] ;

    [self updateBoard] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    self.navItem.title = @"Single" ;
    
    if (self.singleGame) {
        self.singleGame.game = game ;
        self.singleGame.delegate = self ;
    }
    
    if (self.watchGame) {
        self.watchGame.delegate = self ;

        if (!self.watchGame.watch) {
            self.watchGame.watch = YES ;
            [self.watchGame cooperate:YES] ;
        }
    }
    
    if (self.pairGame) {
        self.navItem.title = @"Pair" ;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.watchGame && self.watchGame.watch) {
        [self.watchGame cooperate:NO] ;
    }
    
    [super viewWillDisappear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBoard {
    for (Move *move in game.board) {
        UIButton *button = [cells objectAtIndex:move.index] ;
        
        [button setBackgroundImage:[imgs objectAtIndex:move.player] forState:UIControlStateNormal] ;
        button.userInteractionEnabled = move.player == Empty ;
    }
}

- (void)showBanner:(Player)player {
    if (player == Empty) {
        self.lblBanner.text = @"Tie" ;
    } else if (player == Human) {
        self.lblBanner.text = @"X lose" ;
    } else {
        self.lblBanner.text = @"X won" ;
    }

    self.viBanner.hidden = NO ;
    self.svButtons.userInteractionEnabled = NO ;
}

- (IBAction)onHuman:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag ;
    
    if (tag < 1) {
        return ;
    }
    
    if (!self.pairGame) {
        self.svButtons.userInteractionEnabled = NO ;
        
        [game.board objectAtIndex:(tag - 1)].player = Human ;
        [self updateBoard] ;
    } else {
        [game.board objectAtIndex:(tag - 1)].player = self.pairGame.player ;
        [self updateBoard] ;
        [self.pairGame flipPlayer] ;
        
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.5 ] ;
        rotationAnimation.duration = 0.4 ;
        rotationAnimation.cumulative = NO ;
        rotationAnimation.autoreverses = YES ;
        rotationAnimation.repeatCount = 1 ;
        
        [self.svButtons.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"] ;
    }
    
    
    if (self.watchGame.watch) {
        [self.watchGame moveTo:(tag -1)] ;
    }
    
    if ([game isWinningForPlayer:Human]) {
        [self showBanner:Human] ;
        return ;
    }
    
    if ([game isWinningForPlayer:Computer]) {
        [self showBanner:Computer] ;
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

- (IBAction)onReset:(id)sender {
    [game resetBoard] ;
    [self updateBoard] ;
    self.svButtons.userInteractionEnabled = YES ;
    self.viBanner.hidden = YES ;

    if (self.watchGame.watch) {
        [self.watchGame reset] ;
    }
    
    if (self.pairGame) {
        [self.pairGame reset] ;
    }
}

#pragma mark - <SingleGameDelegate>

- (void)didMove:(Move *)move {
    [game.board objectAtIndex:move.index].player = move.player ;
    [self updateBoard] ;

    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"] ;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0] ;
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0] ;
    fadeInAnimation.additive = NO;
    fadeInAnimation.removedOnCompletion = YES ;
    fadeInAnimation.autoreverses = YES ;
    fadeInAnimation.duration = 0.3 ;
    fadeInAnimation.fillMode = kCAFillModeForwards ;
    [[cells objectAtIndex:move.index].layer addAnimation:fadeInAnimation forKey:@"fadeAnimation"] ;
    
    if ([game isWinningForPlayer:Computer]) {
        [self showBanner:Computer] ;
        return ;
    }
    
    if ([game isFinished]) {
        [self showBanner:Empty] ;
        return ;
    }

    self.svButtons.userInteractionEnabled = YES ;
}

#pragma mark - <GameWatchDelegate>

- (void)watchStateDidChange:(BOOL)watch {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (watch) {
            self.navItem.title = @"Watch" ;
        } else {
            [self.navigationController popViewControllerAnimated:YES] ;
        }
    }) ;
}

- (void)didReceiveDictionary:(NSDictionary<NSString *, id> *)dictionary {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *action = [dictionary objectForKey:@"action"] ;
        if (action) {
            if ([@"move" isEqualToString:action]) {
                Move *move = [[Move alloc] init] ;
                move.player = Computer ;
                move.index = [[dictionary objectForKey:@"index"] longValue] ;
                [self didMove:move] ;
            }
        }
    }) ;
}

- (void)reset {
    [self onReset:self] ;
}

@end
