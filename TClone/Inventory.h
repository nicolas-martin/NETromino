//
// Created by Nicolas Martin on 12/1/2013.
//


#import <Foundation/Foundation.h>
#import "CCLayer.h"

@protocol ICastable;
@class CCSprite;


@interface Inventory : CCLayer
{
    CCSprite * selSprite;
    NSMutableArray *movableSprites;
}
@property NSMutableArray *Inventory;

@property NSMutableArray *fieldBoundingBoxes;

+ (id)initInventory;

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)addSpell:(<ICastable>) spell;
- (void)removeSpell:(<ICastable>) spell;

@end