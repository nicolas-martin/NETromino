//
// Created by Nicolas Martin on 13-08-20.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Board.h"
#import "CGPointExtension.h"
#import "Block.h"
#import "Tetromino.h"


@implementation Board {

}


- (id)init {
    self = [super init];
    if (self) {
        Nby = 20;
        Nbx = 10;
        _array = [self get20x10Array];

    }

    return self;
}

-(NSMutableArray*)get20x10Array {
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < Nbx; ++ i) {
        NSMutableArray* subarr = [NSMutableArray array];
        for (int j = 0; j < Nby; ++ j)
            //insert at index??
            [subarr addObject:[NSNumber numberWithInt:0]];
        [arr addObject:subarr];
    }
    return arr;
}

- (BOOL)isBlockAt:(CGPoint)point {

    NSMutableArray *inner = [_array objectAtIndex:(NSUInteger)point.x];

    //TODO: Test if this test really works with the empty array.
    if([inner objectAtIndex:(NSUInteger)point.y])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (Block *)getBlockAt:(CGPoint)point{
    if ([self isBlockAt:point])
    {
        return (Block *)[[_array objectAtIndex:point.x] objectAtIndex:point.y];
    }
    else
    {
        return nil;
    }
}

- (void)insertBlockAt:(Block *)block at:(CGPoint)point
{
    [[_array objectAtIndex:point.x] replaceObjectAtIndex:point.y withObject:block];
}


- (BOOL)boardRowEmpty:(int)y
{
    for (int x = 0;x < Nbx; x++)
    {
        if ([self isBlockAt:ccp(x, y)])
        {
            return NO;
        }
    }
    return YES;
}


- (void)addTetrominoToBoard:(Tetromino *)tetromino {

    for (Block *block in tetromino.children)
    {
        [self insertBlockAt:block at:ccp(block.boardX,block.boardY)];
    }

}
@end