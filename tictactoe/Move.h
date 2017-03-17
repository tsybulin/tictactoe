//
//  Move.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Move : NSObject

@property (nonatomic) Player player ;
@property (nonatomic) NSInteger index ;
@property (nonatomic) NSInteger score ;

+ (instancetype)moveWithIndex:(NSInteger)index andPlayer:(Player)player ;
- (NSString *)caption ;

@end
