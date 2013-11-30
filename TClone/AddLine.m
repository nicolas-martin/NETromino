//
// Created by Nicolas Martin on 11/30/2013.
//


#import "AddLine.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation AddLine {

}

- (instancetype)initWithTargetField:(Field *)targetField {
    self = [super init];
    if (self) {
        self.targetField = targetField;
    }

    return self;
}

+ (instancetype)lineWithTargetField:(Field *)targetField {
    return [[self alloc] initWithTargetField:targetField];
}

- (NSString *)spellName {
    return @"AddLine";
}

- (void)CreateBlockLine{
    NSMutableArray *bArray = [NSMutableArray array];

    for (NSUInteger x = 0; x < _targetField.board.Nbx; x++) {

        if ((arc4random() % 3) > 0)
        {
            Block *block = [Block newEmptyBlockWithColorByType:2];
            [block setBoardX:x];
            [block setBoardY:19];

            [bArray addObject:block];
        }

    }

    [_targetField addBlocks:bArray];
}

- (void)CastSpell {
    NSLog(@"ADD LINE CALLED!!!!!!");

    Board *board = _targetField.board;

    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (NSUInteger y = 0; y < board.Nby; y++) {
        for (NSUInteger x = 0; x < board.Nbx; x++) {
            Block *current = [board getBlockAt:ccp(x, y)];
            if (current != nil) {

                [board MoveBlock:current to:ccp(x, y - 1)];

                [current moveUp];

                [blocksToSetPosition addObject:current];

            }
        }
    }

    [_targetField setPositionUsingFieldValue:blocksToSetPosition];

    [self CreateBlockLine];


}

- (NSString *)LogSpell {
    NSString *Output = [NSString stringWithFormat:@"%@ was casted on %@", _spellName, _targetField.Name];
    return Output;
}


@end