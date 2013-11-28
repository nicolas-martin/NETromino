//
// Created by Nicolas Martin on 13-08-20.
//
//


#import "Board.h"


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation Board {

@private
    NSMutableArray *_array;
}

- (id)init {
    self = [super init];
    if (self) {
        self.Nbx = 10;
        self.Nby = 20;
        _array = self.get20x10Array;

    }

    return self;
}

//ok
+ (id)initBoard {
    return [[self alloc] init];
}

- (NSMutableArray *)get20x10Array {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.Nbx; ++i) {
        NSMutableArray *subarr = [NSMutableArray array];
        for (int j = 0; j < self.Nby; ++j)
                //insert at index??
                [subarr addObject:[NSNumber numberWithInt:0]];
        [arr addObject:subarr];
    }
    return arr;
}

- (BOOL)isBlockAt:(CGPoint)point {

    //TODO: Fix onclick event
    if (point.x == 20) {
        point.x = 19;
    }
    NSMutableArray *inner = [_array objectAtIndex:(NSUInteger) point.x];

    if ([inner objectAtIndex:(NSUInteger) point.y] != [NSNumber numberWithChar:0]) {
        return YES;
    }
    else {
        return NO;
    }
}


- (Block *)getBlockAt:(CGPoint)point {

    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    if ([self isBlockAt:point]) {
        return [[_array objectAtIndex:x] objectAtIndex:y];
    }
    else {
        return nil;
    }
}

- (void)insertBlockAt:(Block *)block at:(CGPoint)point {
    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:block];
}

- (void)DeleteBlock:(Tetromino *)tetromino {

    for (Block *block in tetromino.children) {
        [[_array objectAtIndex:(NSUInteger) block.boardX] replaceObjectAtIndex:(NSUInteger) block.boardY withObject:[NSNumber numberWithInt:0]];
    }

}

- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino {

    //delete
    for (Block *block in FromTetromino.children) {
        [[_array objectAtIndex:block.boardX] replaceObjectAtIndex:block.boardY withObject:[NSNumber numberWithInt:0]];
    }
    //insert
    [self addTetrominoToBoard:ToTetromino];

}


- (void)MoveBlock:(Block *)block to:(CGPoint)after {
    NSUInteger x = (NSUInteger) [block boardX];
    NSUInteger y = (NSUInteger) [block boardY];

    //delete
    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:0]];
    //insert
    [self insertBlockAt:block at:after];
    [block setBoardX:(NSUInteger) after.x];
    [block setBoardY:(NSUInteger) after.y];

}


- (BOOL)boardRowFull:(NSUInteger)y {
    for (int x = 0; x < self.Nbx; x++) {
        if (![self isBlockAt:ccp(x, y)]) {
            return NO;
        }
    }
    return YES;
}

- (void)DeleteRow:(NSUInteger)y {
    for (NSUInteger x = 0; x < _Nbx; x++) {
        [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:0]];
    }

}

- (NSMutableArray *)MoveBoardDown:(NSUInteger)y {
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (y; y > 0; y--) {
        for (NSUInteger x = 0; x < _Nbx; x++) {
            Block *current = [self getBlockAt:ccp(x, y)];
            if (current != nil) {
                [self MoveBlock:current to:ccp(x, y+1)];
                [current moveDown];
                [blocksToSetPosition addObject:current];

            }
        }
    }
    return blocksToSetPosition;
}


- (void)addTetrominoToBoard:(Tetromino *)tetromino {

    for (Block *block in tetromino.children) {
        [self insertBlockAt:block at:ccp(block.boardX, block.boardY)];
    }

}

- (void)printCurrentBoardStatus:(BOOL *)withPosition {
    NSLog(@"--------------------------------------------------------------------");
    for (int j = 0; j < 20; ++j) {
        NSMutableString *row = [NSMutableString string];
        for (int i = 0; i < 10; ++i) {

            if ([self isBlockAt:ccp(i, j)]) {
                if (withPosition) {
                    [row appendFormat:@"(%02d,%02d) ", i, j];
                }
                else {
                    [row appendFormat:@"X "];
                }
            }
            else {
                if (withPosition) {
                    [row appendFormat:@"(  ,  ) "];
                }
                else {
                    [row appendFormat:@"  "];
                }
            }

        }

        NSLog(@"%@", row);

    }
}

@end