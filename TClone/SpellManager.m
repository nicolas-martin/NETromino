//
// Created by Nicolas Martin on 12/8/2013.
//


#import "SpellManager.h"
#import "ICastable.h"
#import "AddLine.h"
#import "RandomRemove.h"


@implementation SpellManager {

}

const NSUInteger dropAddLine = 50;
const NSUInteger dropRandomRemove = 50;

- (instancetype)initWithDropAddLine{
    self = [super init];
    if (self) {

    }

    return self;
}

+ (instancetype)managerWithDropAddLine{
    return [[self alloc] initWithDropAddLine];
}

+ (BOOL)randomBoolWithPercentage:(NSUInteger)percentage
{
    return (arc4random() % 100) < percentage;
}

//Bad :(
+ (id <ICastable>) getSpellUsingFrequency
{
    id <ICastable> spell = nil;

    for (NSUInteger j = 0; j < 2;  j++) {
        if ([self randomBoolWithPercentage:(NSUInteger) dropAddLine])
        {
            spell =  [AddLine initStuff];
        }
        else if ([self randomBoolWithPercentage:(NSUInteger) dropRandomRemove])
        {
            spell = [RandomRemove init];
        }


    }

    spell;

}


@end