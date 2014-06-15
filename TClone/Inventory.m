//
// Created by Nicolas Martin on 12/1/2013.
//


#import "Inventory.h"
#import "ICastable.h"
#import "CCSprite.h"
#import "CGPointExtension.h"
#import "CCActionEase.h"
#import "GameLogicLayer.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation Inventory {
    BOOL _Main;
}


+ (id)initInventory:(BOOL)isMain
{
    return [[self alloc] initWithFieldSize:isMain];
}

- (id)initWithFieldSize:(BOOL)main
{
    NSString *filename;
    self = [super init];
    if (self) {
        _Inventory = [NSMutableArray array];
        _Main = main;



        //TODO: Use their own sprite

        if (!_Main)
        {
            //filename = [[NSString alloc] initWithFormat:@"inventory-small.png"];

        }
        else
        {
            filename = [[NSString alloc] initWithFormat:@"inventory.png"];
        }
        [self setAnchorPoint:ccp(0, 0)];
        movableSprites = [NSMutableArray array];
        _fieldBoundingBoxes = [NSMutableArray array];


        filename = [[NSString alloc] initWithFormat:@"inventory.png"];

    }

    return [self initWithFile:filename];
}

- (void)addSpell:(<ICastable>)spell
{

    if(_Inventory.count < 10)
    {
        [_Inventory addObject:spell];
        CCSprite *newSpellSprite = [CCSprite spriteWithFile:spell.spriteFileName];

        if(!_Main)
        {
            [newSpellSprite setScale:0.7];
        }

        [newSpellSprite setPosition:ccp(newSpellSprite.contentSize.width * _Inventory.count, newSpellSprite.contentSize.height/2)];
        [newSpellSprite setTag:1];
        newSpellSprite.userObject = spell;
        [movableSprites addObject:newSpellSprite];
        [self addChild:newSpellSprite];
    }
}

- (void)removeSpell:(<ICastable>)spell
{
    [_Inventory removeObject:spell];
    [movableSprites removeObject:selSprite];
    [selSprite removeFromParentAndCleanup:YES];

    NSUInteger count = 0;
    for (CCSprite *sprite in movableSprites)
    {
        count++;
        [sprite setPosition:ccp(sprite.contentSize.width*count, sprite.contentSize.height/2)];


    }
}

//TODO: The logic should be thrown to the controller
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    if (selSprite) {
        id move = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.1 position:touchLocation]];
        [selSprite runAction:move];

    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
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
                    //TODO: Check if this works...
                    //GameLogicLayer *myParentAsMainClass = [GameLogicLayer sharedManager];
                    
                    GameLogicLayer *myParentAsMainClass = (GameLogicLayer*)self.parent.parent;
                    [obj CastSpell:[myParentAsMainClass getFieldFromString:key]];
                    [self removeSpell:selSprite.userObject];


                }

            }

        }
    }

}

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
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