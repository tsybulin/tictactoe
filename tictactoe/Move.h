//
//  Move.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figure.h"

@interface Move : NSObject

@property (nonatomic) Figure figure ;
@property (nonatomic) NSInteger index ;
@property (nonatomic) NSInteger score ;

+ (instancetype)moveWithIndex:(NSInteger)index andFigure:(Figure)figure ;
- (NSString *)caption ;

@end
