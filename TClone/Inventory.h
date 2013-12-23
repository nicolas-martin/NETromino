//
// Created by Nicolas Martin on 12/1/2013.
//


#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "CCSprite.h"

@protocol ICastable;
@class CCSprite;


@interface Inventory : CCSprite
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