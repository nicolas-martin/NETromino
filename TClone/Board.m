//
// Created by Nicolas Martin on 13-08-20.
//
//


#import "Board.h"



@implementation Board {

@private
    NSMutableArray *_array;
}

- (id)init {
    self = [super init];
    if (self) {
        _array = self.get20x10Array;
        self.Nbx = 10;
        self.Nby = 20;
    }

    return self;
}
//ok
+ (id)initBoard {
    return [[self alloc] init];
}

-(NSMutableArray*)get20x10Array {
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < self.Nbx; ++ i) {
        NSMutableArray* subarr = [NSMutableArray array];
        for (int j = 0; j < self.Nby; ++ j)
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

- (Block *)getBlockAt:(CGPoint)point
{

    NSUInteger x = (NSUInteger)point.x;
    NSUInteger y = (NSUInteger)point.y;

    return [self isBlockAt:point] ? (Block *) [[_array objectAtIndex:x] objectAtIndex:y] : nil;
}

- (void)insertBlockAt:(Block *)block at:(CGPoint)point
{
    NSUInteger x = (NSUInteger)point.x;
    NSUInteger y = (NSUInteger)point.y;

    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:block];
}

- (void)MoveBlock:(Block*)block from:(CGPoint)before to:(CGPoint)after
{
    NSUInteger x = (NSUInteger)before.x;
    NSUInteger y = (NSUInteger)before.y;

    //delete
    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:0]];
    //insert
    [self insertBlockAt:block at:after];

}


- (BOOL)boardRowEmpty:(int)y
{
    for (int x = 0;x < self.Nbx; x++)
    {
        if ([self isBlockAt:ccp(x, y)])
        {
            return NO;
        }
    }
    return YES;
}


- (void)addTetrominoToBoard:(Tetromino *)tetromino
{

    for (Block *block in tetromino.children)
    {
        [self insertBlockAt:block at:ccp(block.boardX,block.boardY)];
    }

}

@end