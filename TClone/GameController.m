//
// Created by Nicolas Martin on 13-08-15.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameController.h"
#import "Block.h"
#import "Tetromino.h"
#import "Field.h"
#import "GameLogicLayer.h"
#import "GameOverLayer.h"




@implementation GameController {


}
- (id)initWithField:(Field *)aField {
    self = [super init];
    if (self) {
        field = aField;
    }

    return self;
}

+ (id)controllerWithField:(Field *)aField {
    return [[self alloc] initWithField:aField];
}


- (void)moveDownOrCreate {

    if(userTetromino.stuck)
    {
        [self tryToCreateNewTetromino];
    }
    else if([userTetromino lowestPosition].y != 9 && [field boardRowEmpty:[userTetromino lowestPosition].y])
    {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else
    {
        userTetromino.stuck = YES;
        [field checkForRowsToClear];
    }


}
- (id)init {
    if (self = [super init]) {

        _listObservers = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.listObservers forKey:@"self.listObservers"];
}


- (void)tryToCreateNewTetromino
{
    //TODO If any spot in the top two rows where blocks spawn is taken game over

    //Make into propriety?
    userTetromino = [self createNewTetromino];
}

- (void)gameOver:(BOOL)won
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];

}

//Creates a new block
- (Tetromino *)createNewTetromino {

    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];

    //TODO: Should I notify or call update the view directly?
    return tempTetromino;

}


- (void)moveTetrominoDown
{
    //add verification
    [userTetromino moveTetrominoDown];

}


- (void)moveTetrominoLeft{

    if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {
        [userTetromino moveTetrominoInDirection:moveLeft];
    }
}


- (void)moveTetrominoRight{

    if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [userTetromino moveTetrominoInDirection:moveRight];
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
        Block *blockNextToCurrentBlock = board[currentBlock.boardX + offSetX][currentBlock.boardY];
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:blockNextToCurrentBlock]))
        {
            //if there's another block at the position you're looking at, you can't move
            if (board[currentBlock.boardX + offSetX][currentBlock.boardY] != nil)
            {
                return NO;
            }
        }
    }
    return YES;
}


- (BOOL)isTetrominoInBounds:(Tetromino *)rotated oldTetromino:(Tetromino *)userTetromino {
    for (Block *currentBlock in rotated.children)
    {
        //check if the new block is within the bounds and
        if(currentBlock.boardX < 0 || currentBlock.boardX > kLastColumn || currentBlock.boardY < 0 || currentBlock.boardY > kLastRow )
        {
            NSLog(@"DENIED");
            return NO;

        }

        Block *blockInCurrentBoard = board[currentBlock.boardX][currentBlock.boardY];
        //if the current block is NOT part of the currentTetromino
        if (!([userTetromino isBlockInTetromino:blockInCurrentBoard]))
        {
            //and is not empty
            if (board[currentBlock.boardX][currentBlock.boardY] != nil)
            {
                NSLog(@"DENIED");
                return NO;
            }
        }
    }
    return YES;
}

- (void)notifyTretrominoPosition:(Tetromino *)tetromino {
    for (id<GameControllerObserver> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateTetrominoPosition:)]) {
            [observer updateTetrominoPosition:tetromino];
        }
    }
}

- (void)rotateTetromino:(RotationDirection)direction {

     [userTetromino rotateTetromino:direction];

}

- (void)viewTap:(CGPoint)location {

    CGFloat leftMostX = 0;
    CGFloat rightMostX = 0;
    CGFloat lowestY = 0;
    CGFloat highestY = 0;

    leftMostX = COMPUTE_X([userTetromino leftMostPosition].x);
    rightMostX = COMPUTE_X([userTetromino rightMostPosition].x);
    lowestY = COMPUTE_Y([userTetromino lowestPosition].y);
    highestY = COMPUTE_Y([userTetromino highestPosition].y);

    location = [[CCDirector sharedDirector] convertToGL:location];

    //Drop only if touched right under the piece
    if (location.y < lowestY)
    {
        touchType = kDropBlocks;
    }

    else if (location.x < leftMostX)
    {
        touchType = kMoveLeft;
    }
    else if (location.x > rightMostX)
    {
        touchType = kMoveRight;
    }

    [self processTaps];
}



- (void)processTaps
{
    if (touchType == kDropBlocks)
    {
        touchType = kNone;

        while (!userTetromino.stuck)
        {
            [self moveTetrominoDown];
        }
    }
    else if (touchType == kMoveLeft)
    {
        touchType = kNone;

        if (userTetromino.leftMostPosition.x > 0 && !userTetromino.stuck)
        {
            [self moveTetrominoLeft];
        }
    }
    else if (touchType == kMoveRight)
    {
        touchType = kNone;

        if (userTetromino.rightMostPosition.x < kLastColumn && !userTetromino.stuck)
        {
            [self moveTetrominoRight];
        }
    }


}


@end