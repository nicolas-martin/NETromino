//
// Created by Nicolas Martin on 11/30/2013.
//


#import "RandomRemove.h"
#import "Field.h"
#import "Board.h"


@implementation RandomRemove {

}
- (RandomRemove *)initWith {
    self = [super init];
    if (self) {
        _spellName = @"randomRemove";
        _spriteFileName = @"randomRemove.png";

    }

    return self;
}

+ (RandomRemove *)init {
    return [[self alloc] initWith];
}

- (void)CastSpell:(Field *)targetField {
    Board *board = targetField.board;
    NSMutableArray *allBlockInBoard = [board getAllBlocksInBoard];
    NSMutableArray *blocksToDelete = [NSMutableArray array];

    NSUInteger nbBlockInBoard = allBlockInBoard.count;

    //Removes 10% of all the blocks

    NSUInteger nbBlocksToRemove = (NSUInteger )(nbBlockInBoard / 10);

    for (NSUInteger i = 0; i < nbBlocksToRemove; i++)
    {
        NSUInteger random = arc4random() % nbBlockInBoard;

        Block *block = [allBlockInBoard objectAtIndex:random];

        if (block)
        {
            [blocksToDelete addObject:block];
        }

    }


    [board DeleteBlockFromBoardAndSprite:blocksToDelete];

}

- (NSString *)LogSpell:(Field *)targetField {
    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
}

@end