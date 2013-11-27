//
// Created by Nicolas Martin on 13-08-11.
//
//


#import "CCLayer.h"
#import "Field.h"
#import "CGPointExtension.h"
#import "Tetromino.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@implementation Field {

}
- (id)initWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize {
    self = [super init];
    if (self) {
        self.board = board;
        self.Height = FieldHeight;
        self.Width = FieldWidth;
        self.TileSize = TileSize;
    }

    return self;
}

+ (id)fieldWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize {
    return [[self alloc] initWithBoard:board FieldHeight:FieldHeight FieldWidth:FieldWidth TileSize:TileSize];
}


- (void)checkForRowsToClear:(Tetromino *)tetromino {

    BOOL occupied = NO;
    for (Block *block in tetromino.children)
    {

        for (int x = block.boardX; x < [_board Nbx]; x++)
        {

            if(![_board isBlockAt:ccp(x, block.boardY)])
            {
                occupied = NO;
                //Since there's an empty block on this column there's no need to look at the others
                //Exits both loops and get the next row
                break;

            }
            else
            {
                occupied = YES;
            }
        }

        if(occupied)
        {
            //TODO: remove row from the board using Tetromino shape?
            //TODO: Notify the views

        }
        else
        {
            continue;
        }
    }

}

- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(int)offSetY {

    // Sort blocks by x value if moving left, reverse order if moving right
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetY > 0)
    {
        [reversedChildren reverseObjects];
    }

    for (Block *currentBlock in reversedChildren)
    {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]]))
        {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)])
            {
                return NO;
            }
        }
    }
    return YES;

}



- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(int)offSetX {

    // Sort blocks by x value if moving left, reverse order if moving right
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetX > 0)
    {
        [reversedChildren reverseObjects];
    }

    for (Block *currentBlock in reversedChildren)
    {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]]))
        {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)])
            {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with {

    for (Block *currentBlock in tetromino.children)
    {
        //check if the new block is within the bounds and
        if(currentBlock.boardX < 0 || currentBlock.boardX >= [self.board Nbx]
                    || currentBlock.boardY < 0 || currentBlock.boardY >= [self.board Nby] )
        {
            NSLog(@"DENIED - OUT OF BOUNDS");
            return NO;

        }

        //if the current block is NOT part of the currentTetromino
        /*if (!([tetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)]]))
        {
            if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)])
            {
                NSLog(@"DENIED - COLLISION");
                return NO;
            }
        }*/



        for(Block *old in with.children)
        {
            if(!([old boardX] == [currentBlock boardX]) && ![old boardY] == [currentBlock boardY]) {
                if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)])
                {
                    NSLog(@"DENIED - COLLISION");
                    return NO;
                }
            }
        }


        //}
    }
    return YES;
}


- (BOOL)boardRowEmpty:(int)y {

    return [_board boardRowFull:y];

}

@end