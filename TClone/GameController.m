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
    //Perhaps set all tetromino to stuck by default?
    if(userTetromino.stuck || userTetromino == NULL)
    {
        [self tryToCreateNewTetromino];
    }
    else if([userTetromino lowestPosition].y != 9 && [field boardRowEmpty:(NSUInteger)[userTetromino lowestPosition].y])
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
    if(![field.board boardRowEmpty:18] && ![field.board boardRowEmpty:19])
    {
        userTetromino = [self createNewTetromino];
    }
    else
    {
        [self gameOver:YES];
    }
}


- (void)gameOver:(BOOL)won
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

//TODO: Notify views
- (Tetromino *)createNewTetromino {

    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];

    [field.board addTetrominoToBoard:tempTetromino];


    [field addChild:tempTetromino];

    [self newTetromino:tempTetromino];

    return tempTetromino;

}

- (void)AdjustTetrominoPosition:(Tetromino* )tetromino
{

    //tetromino.position.x = tetromino.position.x * field.TileSize;
    //tetromino.position.y = tetromino.position.y
}



//TODO: Adjust the board
- (void)moveTetrominoDown
{
    //TODO: Add verification
    [userTetromino moveTetrominoDown];
    [self notifyTretrominoPosition:userTetromino];
}

- (void)moveTetrominoLeft{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {
        //TODO: Move the blocks in the board
        //[self insertBlockAt:currentBlock at:ccp(currentBlock.boardX,currentBlock.boardY)];
        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];
        [self notifyTretrominoPosition:userTetromino];

    }
}

- (void)moveTetrominoRight{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        //TODO: Move the blocks in the board
        //[self insertBlockAt:currentBlock at:ccp(currentBlock.boardX,currentBlock.boardY)];
        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];
        [self notifyTretrominoPosition:userTetromino];
    }
}


- (void)notifyTretrominoPosition:(Tetromino *)tetromino {
    for (id<GameControllerObserver> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateTetrominoPosition:)]) {
            [observer updateTetrominoPosition:tetromino];
        }
    }
}

- (void)newTetromino:(Tetromino *)tetromino {
    for (id<GameControllerObserver> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(newTetromino:)]) {
            //[observer newTetromino:tetromino];
        }
    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    if([field isTetrominoInBounds:userTetromino]){
        Tetromino *rotatedTetromino = [Tetromino rotateTetromino:userTetromino in:direction];

        [self notifyTretrominoPosition:userTetromino];
        //TODO: Move each block from userTetromino to rotatedTetromino
    }
}

- (void)viewTap:(CGPoint)location {

    CGFloat leftMostX = 0;
    CGFloat rightMostX = 0;
    CGFloat lowestY = 0;
    CGFloat highestY = 0;

    //compute
    leftMostX = [userTetromino leftMostPosition].x;
    rightMostX = [userTetromino rightMostPosition].x;
    lowestY = [userTetromino lowestPosition].y;
    highestY = [userTetromino highestPosition].y;

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


- (void)processTaps{
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