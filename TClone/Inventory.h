//
// Created by Nicolas Martin on 12/1/2013.
//


#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "CCSprite.h"

@protocol ICastable;
@class CCSprite;


@interface Inventory : CCNode
{
    CCSprite * selSprite;
    NSMutableArray *movableSprites;
}
@property NSMutableArray *Inventory;

@property NSMutableArray *fieldBoundingBoxes;

+ (id)initInventory:(BOOL)isMain;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

- (id)initWithFieldSize:(BOOL)main;

- (void)addSpell:(<ICastable>) spell;
- (void)removeSpell:(<ICastable>) spell;

@end