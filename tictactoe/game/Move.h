//
//  Move.h
//  tictactoe
//
//  Created by Pavel Tsybulin on 3/12/17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figure.h"

typedef NSDictionary<NSString *, id> TranspDict ;
#define TD_ACTION @"action"
#define TD_MOVE @"move"
#define TD_INDEX @"index"
#define TD_RESET @"reset"
#define TD_STOP @"stop"

@interface Move : NSObject <NSCopying> {
    NSInteger _score ;
}

@property (nonatomic) Figure figure ;
@property (nonatomic) NSInteger index ;

+ (instancetype)moveWithIndex:(NSInteger)index andFigure:(Figure)figure ;
- (NSString *)caption ;
- (TranspDict *)transpDict ;
+ (TranspDict *)transpDictReset ;
+ (TranspDict *)transpDictStop ;
+ (TranspDict *)transpDictMove:(NSInteger)index ;

@end
