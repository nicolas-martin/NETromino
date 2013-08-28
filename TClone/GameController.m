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
    //TODO If any spot in the top two rows where blocks spawn is taken game over

    userTetromino = [self createNewTetromino];
}


- (void)gameOver:(BOOL)won
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

//TODO: Add to board
//TODO: Notify views
- (Tetromino *)createNewTetromino {

    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];


    return tempTetromino;

}

//TODO: Add verification
//TODO: Adjust the board
//TODO: Notify
- (void)moveTetrominoDown
{
    //??? Instance Method or Class method?
    [userTetromino moveTetrominoDown];
}

//TODO: Adjust the board
//TODO: Notify
- (void)moveTetrominoLeft{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {
        //field calls the board
        //- (void)moveTetrominoInDirection:(Tetromino *)tetromino in:(MoveDirection)direction

    }
}

//TODO: Adjust the board
//TODO: Notify
- (void)moveTetrominoRight{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        //field calls the board
        //- (void)moveTetrominoInDirection:(Tetromino *)tetromino in:(MoveDirection)direction
    }
}


- (void)notifyTretrominoPosition:(Tetromino *)tetromino {
    for (id<GameControllerObserver> observer in _listObservers) {
        if ([observer respondsToSelector:@selector(updateTetrominoPosition:)]) {
            [observer updateTetrominoPosition:tetromino];
        }
    }
}

//TODO: Adjust the board
//TODO: Notify
- (void)rotateTetromino:(RotationDirection)direction {

    if([field isTetrominoInBounds:userTetromino]){
        Tetromino *rotatedTetromino = [Tetromino rotateTetromino:userTetromino in:direction];
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