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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReset;

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

    self.svButtons.userInteractionEnabled = [self.game currentPlayer].interactive ;
    self.btnReset.enabled = [self.game currentPlayer].interactive ;
    self.navItem.title = [self.game currentPlayer].name ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.game player:[self.game currentPlayer] didChangeState:NO] ;
    [super viewWillDisappear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)onReset:(id)sender {
    [self.game playerDidReset:[self.game currentPlayer]] ;
}

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
        
        if (player.interactive && [self.game currentPlayer].interactive) {
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.5 ] ;
            rotationAnimation.duration = 0.4 ;
            rotationAnimation.cumulative = NO ;
            rotationAnimation.autoreverses = YES ;
            rotationAnimation.repeatCount = 1 ;
            [self.svButtons.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"] ;
        }
        
        self.svButtons.userInteractionEnabled = [self.game currentPlayer].interactive ;
        self.btnReset.enabled = [self.game currentPlayer].interactive ;
        self.navItem.title = [self.game currentPlayer].name ;
    }) ;
}

- (void)game:(Game *)game playerDidReset:(Player *)player {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateBoard] ;
        self.viBanner.hidden = YES ;

        self.svButtons.userInteractionEnabled = [self.game currentPlayer].interactive ;
        self.btnReset.enabled = [self.game currentPlayer].interactive ;
        self.navItem.title = [self.game currentPlayer].name ;
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
