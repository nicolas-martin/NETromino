//
// Created by Nicolas Martin on 12/1/2013.
//


#import "Inventory.h"
#import "ICastable.h"
#import "CCSprite.h"
#import "CGPointExtension.h"
#import "ccDeprecated.h"


@implementation Inventory {

}
- (id)init {
    self = [super init];
    if (self) {
        _Inventory = [NSMutableArray array];
        CCSprite *sprite = [CCSprite spriteWithFile:@"inventory.png"];
        [self addChild:sprite];
        self.ignoreAnchorPointForPosition = YES;

    }

    return self;
}

+ (id)initInventory {
    return [[self alloc] init];
}

- (void) updateInventory
{
    for (CCSprite *sprite in self.children)
    {
        if (sprite.tag == 0){
            [sprite removeFromParentAndCleanup:YES];
        }

    }

    NSUInteger count = 1;
    for (id <ICastable> spell in _Inventory)
    {
        CCSprite *newSpell = [CCSprite spriteWithFile:spell.spriteFileName];
        //TODO: Find a better way to set the position to the left...
        [newSpell setPosition:ccp(newSpell.contentSize.width*count - 60, 0)];
        [newSpell setTag:1];
        [self addChild:newSpell];
        count++;
    }
}


- (void)addSpell:(<ICastable>)spell {
    [_Inventory addObject:spell];
    [self updateInventory];

}

- (void)removeSpell:(<ICastable>)spell {
    [_Inventory removeObject:spell];
    [self updateInventory];

}


@end