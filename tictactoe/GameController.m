//
//  ViewController.m
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "GameController.h"

@interface GameController () {
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
        [UIImage imageNamed:@"zero"],
        [UIImage imageNamed:@"cross"]
    ] ;

    [self updateBoard] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    self.navItem.title = [self.game currentPlayer].name ;
    
    
    
//    if (self.networkGame) {
//        self.navItem.title = @"Network" ;
//        self.networkGame.delegate = self ;
//    }
//    
//    if (self.networkGame && !self.networkGame.initiated) {
//        [self.networkGame postInitWithName:[UIDevice currentDevice].name] ;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
//    if (self.networkGame && !self.networkGame.paired) {
//        [self.networkGame pair:self] ;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.game player:[self.game currentPlayer] didChangeState:NO] ;
//    if (self.networkGame && self.networkGame.network) {
//        [self.networkGame stop] ;
//    }
    
    [super viewWillDisappear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBoard {
    for (Move *move in self.game.board) {
        UIButton *button = [cells objectAtIndex:move.index] ;
        
        [button setBackgroundImage:[imgs objectAtIndex:move.figure] forState:UIControlStateNormal] ;
        button.userInteractionEnabled = move.figure == Empty ;
    }
}

- (void)showBanner:(NSString *)banner {
    self.lblBanner.text = banner ;
    self.viBanner.hidden = NO ;
    self.svButtons.userInteractionEnabled = NO ;
}

- (IBAction)onHuman:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag ;
    
    if (tag < 1) {
        return ;
    }
    
    [self.game player:[self.game currentPlayer] didMoveTo:(tag-1)] ;
}

- (void)resetBoard {
    [self.game resetBoard] ;
    [self updateBoard] ;
    self.svButtons.userInteractionEnabled = YES ;
    self.viBanner.hidden = YES ;
}

- (IBAction)onReset:(id)sender {
    [self.game playerDidReset:[self.game currentPlayer]] ;
}

#pragma mark - <NetworkGameDelegate>

//- (void)networkGame:(NetworkGame *)networkGame didChangeState:(BOOL)network {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (network) {
//            self.navItem.title = @"Network" ;
//        } else {
//            [self.navigationController popViewControllerAnimated:YES] ;
//        }
//    }) ;
//}
//
//- (void)networkGame:(NetworkGame *)networkGame didMoveTo:(NSInteger)index {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        Move *move = [[Move alloc] init] ;
//        move.figure = Cross ;
//        move.index = index ;
//        [self didMove:move] ;
//    }) ;
//}
//
//- (void)resetFromNetworkGame:(NetworkGame *)networkGame {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self resetBoard] ;
//    }) ;
//}
//
//- (void)stopFromNetworkGame:(NetworkGame *)networkGame {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES] ;
//    }) ;
//}

#pragma mark - <GameDelegate>

- (void)game:(Game *)game player:(Player *)player didMoveTo:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateBoard] ;
        
        if (!player.interactive) {
            CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"] ;
            fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0] ;
            fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0] ;
            fadeInAnimation.additive = NO;
            fadeInAnimation.removedOnCompletion = YES ;
            fadeInAnimation.autoreverses = YES ;
            fadeInAnimation.duration = 0.3 ;
            fadeInAnimation.fillMode = kCAFillModeForwards ;
            [[cells objectAtIndex:index].layer addAnimation:fadeInAnimation forKey:@"fadeAnimation"] ;
        }
        
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
        
        if (player.interactive && nextPlayer.interactive) {
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.5 ] ;
            rotationAnimation.duration = 0.4 ;
            rotationAnimation.cumulative = NO ;
            rotationAnimation.autoreverses = YES ;
            rotationAnimation.repeatCount = 1 ;
            [self.svButtons.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"] ;
        }
        
        self.svButtons.userInteractionEnabled = nextPlayer.interactive ;
        self.navItem.title = nextPlayer.name ;
    }) ;
}

- (void)game:(Game *)game playerDidReset:(Player *)player {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetBoard] ;
    }) ;
}

- (void)game:(Game *)game player:(Player *)player didChangeState:(BOOL)state {
    if (!state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES] ;
        }) ;
    }
}

@end
