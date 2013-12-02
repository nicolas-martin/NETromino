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


@implementation Inventory
- (id)init {
    self = [super init];
    if (self) {
        self.Inventory = [NSMutableArray array];
        CCSprite *sprite = [CCSprite spriteWithFile:@"inventory.png"];
        sprite.ignoreAnchorPointForPosition = YES;
        [self addChild:sprite];
        self.ignoreAnchorPointForPosition = YES;






    }

    return self;
}

+ (id)initInventory {
    return [[self alloc] init];
}




- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {

        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        [self selectSpriteForTouch:touchLocation];

    } else if (recognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
        [recognizer setTranslation:CGPointZero inView:recognizer.view];

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

        if (!selSprite) {
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint newPos = ccpAdd(self.position, ccpMult(velocity, scrollDuration));
            //newPos = [self.position boundLayerPos:newPos];

            [self stopAllActions];
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];
            [self runAction:[CCEaseOut actionWithAction:moveTo rate:1]];
        }

    }
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
    for (id <ICastable> spell in self.Inventory)
    {
        CCSprite *newSpell = [CCSprite spriteWithFile:spell.spriteFileName];
        [newSpell setPosition:ccp(newSpell.contentSize.width*count, 7)];
        [newSpell setTag:1];
        [self addChild:newSpell];
        count++;
    }
}

- (void)addSpell:(<ICastable>)spell {
    [self.Inventory addObject:spell];
    [self updateInventory];

}

- (void)removeSpell:(<ICastable>)spell {
    [self.Inventory removeObject:spell];
    [self updateInventory];

}
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in _Inventory) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
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
//
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
//    [self selectSpriteForTouch:touchLocation];
//    return TRUE;
//}
//
//- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
//
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//
//        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
//        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
//        touchLocation = [self convertToNodeSpace:touchLocation];
//        [self selectSpriteForTouch:touchLocation];
//
//    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
//
//        CGPoint translation = [recognizer translationInView:recognizer.view];
//        translation = ccp(translation.x, -translation.y);
//        CGPoint newPos = ccpAdd(selSprite.position, translation);
//        selSprite.position = newPos;
//        [recognizer setTranslation:CGPointZero inView:recognizer.view];
//
//    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//
//        if (!selSprite) {
//            float scrollDuration = 0.2;
//            CGPoint velocity = [recognizer velocityInView:recognizer.view];
//            CGPoint newPos = ccpAdd(self.position, ccpMult(velocity, scrollDuration));
//
//            [self stopAllActions];
//            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];
//            [self runAction:[CCEaseOut actionWithAction:moveTo rate:1]];
//        }
//
//    }
//}


@end