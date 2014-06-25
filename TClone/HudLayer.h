//
// Created by Nicolas Martin on 11/29/2013.
//


#import <Foundation/Foundation.h>
#import "CCNode.h"


@interface HudLayer : CCNode

+ (id)initLayer;

- (void)numRowClearedChanged:(int)numRowCleared;

- (NSString *)description;
@end