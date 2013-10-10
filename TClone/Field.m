//
// Created by Nicolas Martin on 13-08-11.
//
//


#import "CCLayer.h"
#import "Field.h"
#import "CGPointExtension.h"
#import "Tetromino.h"

int Nby;

int Nbx;

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


- (void)checkForRowsToClear {

//Return the row to clear or clear it myself?

    BOOL occupied = NO;
    for (int y = 0;y < Nby; y++)
    {

        for (int x = 0; x < Nbx; x++)
        {

            if(![_board isBlockAt:ccp(x, y)])
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

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino {

    for (Block *currentBlock in tetromino.children)
    {
        //check if the new block is within the bounds and
        if(currentBlock.boardX < 0 || currentBlock.boardX > kLastColumn || currentBlock.boardY < 0 || currentBlock.boardY > kLastRow )
        {
            NSLog(@"DENIED");
            return NO;

        }

        //if the current block is NOT part of the currentTetromino
        if (!([tetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)]]))
        {
            //and is not empty
            if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)])
            {
                NSLog(@"DENIED");
                return NO;
            }
        }
    }
    return YES;
}


- (BOOL)boardRowEmpty:(int)y {

    return [_board boardRowEmpty:y];

}

@end