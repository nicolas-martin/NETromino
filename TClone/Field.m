//
// Created by Nicolas Martin on 13-08-11.
//
//


#import "CCLayer.h"
#import "Field.h"
#import "Board.h"
#import "Tetromino.h"
#import "SpellFactory.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation Field {


}
- (instancetype)initWithName:(NSString *)Name TileSize:(NSUInteger)TileSize Height:(NSUInteger)Height Width:(NSUInteger)Width board:(Board *)board {
    self = [super init];
    if (self) {
        self.Name = Name;
        self.TileSize = TileSize;
        self.Height = Height;
        self.Width = Width;
        self.board = board;
        self.anchorPoint = ccp(0, 0);
    }

    return self;
}

+ (instancetype)fieldWithName:(NSString *)Name TileSize:(NSUInteger)TileSize Height:(NSUInteger)Height Width:(NSUInteger)Width board:(Board *)board {
    return [[self alloc] initWithName:Name TileSize:TileSize Height:Height Width:Width board:board];
}

- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage
{
    return (arc4random() % 100) < percentage;
}

- (void) addSpellToField
{
    NSMutableArray *allBlocksInBoard = [_board getAllBlocksInBoard];
    NSUInteger nbBlocksInBoard = allBlocksInBoard.count;
    NSUInteger nbSpellToAdd = 0;

    for (NSUInteger i = 0; i < nbBlocksInBoard; i++)
    {
        if([self randomBoolWithPercentage:55])
        {
            nbSpellToAdd++;
        }
    }

    for (NSUInteger i = 0; i < nbSpellToAdd; i++)
    {
        NSUInteger posOfSpell = arc4random() % nbBlocksInBoard;
        Block * block = [allBlocksInBoard objectAtIndex:posOfSpell];
        if (block.spell == nil)
        {
            [block addSpellToBlock:[SpellFactory getSpellUsingFrequency]];
        }
    }
}


- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY {

    // Sort blocks by x value if moving left, reverse order if moving right
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetY > 0) {
        [reversedChildren reverseObjects];
    }

    for (Block *currentBlock in reversedChildren) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]) {
                return NO;
            }
        }
    }
    return YES;

}


- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX {

    // Sort blocks by x value if moving left, reverse order if moving right
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetX > 0) {
        [reversedChildren reverseObjects];
    }

    for (Block *currentBlock in reversedChildren) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]) {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with {

    for (Block *currentBlock in tetromino.children) {
        //check if the new block is within the bounds and
        if (currentBlock.boardX < 0 || currentBlock.boardX >= [self.board Nbx]
                || currentBlock.boardY < 0 || currentBlock.boardY >= [self.board Nby]) {
            NSLog(@"DENIED - OUT OF BOUNDS");
            return NO;

        }

        for (Block *old in with.children) {
            if (!([old boardX] == [currentBlock boardX]) && ![old boardY] == [currentBlock boardY]) {
                if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)]) {
                    NSLog(@"DENIED - COLLISION");
                    return NO;
                }
            }
        }


        //}
    }
    return YES;
}


- (BOOL)boardRowEmpty:(NSUInteger)y {

    return [_board boardRowFull:y];

}

- (void)addBlocks:(NSMutableArray *)blocksToAdd
{

    [self.board addTetrominoToBoard:blocksToAdd];

    [self setPositionUsingFieldValue:blocksToAdd];

    for (Block * blocks in blocksToAdd)
    {
        //TODO Create and pass a field type(main or not) and resolve the dimensions
        //32 = main 16 = no
        if (self.TileSize == 16){
            blocks.scale = 0.5;
        }

        //if the block has a parent it is already been added
        //through the tetromino
        if (blocks.parent == nil){
            [self addChild:blocks];

        }


    }

    //[self newTetromino:blocksToAdd];

}

- (void)setPositionUsingFieldValue:(NSMutableArray *) arrayOfBlocks
{
    //CGPoint fieldPositionInView = [self position];

    for (Block *block in arrayOfBlocks)
    {
        NSInteger boardX = [block boardX];
        NSInteger boardY = [block boardY];
        NSInteger boardYTimeSize = boardY * _TileSize;

        NSInteger x = (boardX * _TileSize);// + fieldPositionInView.x);
        NSInteger y = (-boardYTimeSize + _Height);// + fieldPositionInView.y);
        [block setPosition:ccp(x, y)];
    }

}
@end