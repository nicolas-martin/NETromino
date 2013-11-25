//
// Created by Nicolas Martin on 13-08-15.
//
//


#import "GameController.h"
#import "GameOverLayer.h"



#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
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
    //[userTetromino getLowestPosition];
    if(userTetromino.stuck || userTetromino == NULL)
    {
        [self tryToCreateNewTetromino];
    }
    else if(userTetromino.lowestPosition.y != 19 && ![field.board isBlockAt:ccp(userTetromino.lowestPosition.x, userTetromino.lowestPosition.y+1)])
    {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else
    {
        userTetromino.stuck = YES;
        //[field checkForRowsToClear];
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
    if(![field.board boardRowFull:0] && ![field.board boardRowFull:1])
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

- (Tetromino *)createNewTetromino {


    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];

    [field.board addTetrominoToBoard:tempTetromino];

    [tempTetromino setPositionUsingFieldValue:tempTetromino height:field.Height width:field.Width tileSize:field.TileSize];

    [field addChild:tempTetromino];

    [self newTetromino:tempTetromino];

    return tempTetromino;

}

- (void)moveTetrominoDown
{

    [field.board DeleteBlock:userTetromino];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];
}

- (void)moveTetrominoLeft{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [field.board DeleteBlock:userTetromino];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)moveTetrominoRight{

    if ([field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [field.board DeleteBlock:userTetromino];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    if([field isTetrominoInBounds:userTetromino])
    {
        [field.board DeleteBlock:userTetromino];

        Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

        [self UpdatesNewTetromino:userTetromino];


    }
}

-(void)UpdatesNewTetromino:(Tetromino*) ToTetromino
{
    [ToTetromino setPositionUsingFieldValue:ToTetromino height:field.Height width:field.Width tileSize:field.TileSize];

    [field.board addTetrominoToBoard:ToTetromino];

    [self notifyTretrominoPosition:ToTetromino];
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