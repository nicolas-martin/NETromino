//
// Created by Nicolas Martin on 12/1/2013.
//


#import <Foundation/Foundation.h>
#import "CCLayer.h"

@protocol ICastable;


@interface Inventory : CCLayer

@property (nonatomic, strong) NSMutableArray *Inventory;

+ (id)initInventory;

- (void)addSpell:(<ICastable>) spell;
- (void)removeSpell:(<ICastable>) spell;

@end