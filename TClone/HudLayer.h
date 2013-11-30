//
// Created by Nicolas Martin on 11/29/2013.
//


#import <Foundation/Foundation.h>
#import "CCLayer.h"


@interface HudLayer : CCLayer

+ (id)initLayer;

- (void)numRowClearedChanged:(int)numRowCleared;

- (NSString *)description;
@end