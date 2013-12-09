//
// Created by Nicolas Martin on 12/1/2013.
//


#import "Inventory.h"
#import "ICastable.h"
#import "CCSprite.h"
#import "CGPointExtension.h"
#import "CCDirector.h"
#import "CCTouchDispatcher.h"
#import "ccDeprecated.h"
#import "CCActionEase.h"
#import "GameLogicLayer.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation Inventory
- (id)init {
    self = [super init];
    if (self) {
        _Inventory = [NSMutableArray array];
        CCSprite *sprite = [CCSprite spriteWithFile:@"inventory.png"];
        sprite.ignoreAnchorPointForPosition = YES;
        [self addChild:sprite];
        self.ignoreAnchorPointForPosition = YES;
        movableSprites = [NSMutableArray array];
        _fieldBoundingBoxes = [NSMutableArray array];
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
        if (sprite.tag == 1){
            [sprite removeFromParentAndCleanup:YES];
            [movableSprites removeObject:sprite];
        }

    }

    NSUInteger count = 1;
    for (id <ICastable> spell in _Inventory)
    {
        CCSprite *newSpell = [CCSprite spriteWithFile:spell.spriteFileName];
        [newSpell setPosition:ccp(newSpell.contentSize.width*count, 7)];
        [newSpell setTag:1];
        newSpell.userObject = spell;
        [movableSprites addObject:newSpell];
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    if (selSprite) {
        id move = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.1 position:touchLocation]];
        [selSprite runAction:move];

    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    for (NSMutableDictionary *dictionary in _fieldBoundingBoxes)
    {
        for(NSString *key in dictionary)
        {
            CGRect boundingBox = [[dictionary objectForKey:key] CGRectValue];
            if (CGRectContainsPoint(boundingBox, touchLocation)) {
                NSLog(@"DROPPED ON %@", key);

                if (selSprite)
                {
                    id<ICastable> obj = selSprite.userObject;

                    //TODO: Be careful with LEAKS!
                    GameLogicLayer *myParentAsMainClass = (GameLogicLayer*)self.parent.parent;
                    [obj CastSpell:[myParentAsMainClass getFieldFromString:key]];
                    [self removeSpell:selSprite.userObject];

                }

            }

        }
    }

}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites)
    {
        if (sprite.tag == 1){

            if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
                newSprite = sprite;
                break;
            }

        }
    }
    if (newSprite != selSprite) {
        [selSprite stopAllActions];
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selSprite = newSprite;
    }
}

@end