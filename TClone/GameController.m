//
// Created by Nicolas Martin on 13-08-15.
//
//


#import "GameController.h"
#import "GameOverLayer.h"
#import "HudLayer.h"
#import "AddLine.h"


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface GameController ()

@end

@implementation GameController {


}

- (id)initWithField:(Field *)aField {
    self = [super init];
    if (self) {
        self.field = aField;
        //change to init?
        HudLayer *hud = [HudLayer initLayer];
        [_field addChild:hud];
        [hud setPosition:ccp(_field.Width + 10, _field.Height + 10)];
        self.hudLayer = hud;

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
        [self createNewTetromino];
    }
    else if(userTetromino.lowestPosition.y != 19 && [self.field canMoveTetrominoByYTetromino:userTetromino offSetY:1])
    {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else
    {
        userTetromino.stuck = YES;
        [_field.board printCurrentBoardStatus:YES];
        if([self.field checkForRowsToClear:userTetromino.children])
        {
            self.numRowClearedd++;
            [_hudLayer numRowClearedChanged:_numRowClearedd];
        }

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


- (void)VerifyNewBlockCollision:(Tetromino *)new
{

    BOOL collision = NO;

    for (Block *block in new.children)
    {
        if ([self.field.board isBlockAt:ccp(block.boardX, block.boardY)])
        {
            collision = YES;
            continue;
        }
    }

    if (collision)
    {
        [self gameOver:NO];
    }


}


- (void)gameOver:(BOOL)won
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}



- (void)createNewTetromino {


    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency];

    [self VerifyNewBlockCollision:tempTetromino];

    [self.field.board addTetrominoToBoard:tempTetromino.children];

    [self.field setPositionUsingFieldValue:tempTetromino.children];

    [self.field addChild:tempTetromino];

    [self newTetromino:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown
{

    [self.field.board DeleteBlock:userTetromino];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];
}

- (void)moveTetrominoLeft{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [self.field.board DeleteBlock:userTetromino];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)moveTetrominoRight{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [self.field.board DeleteBlock:userTetromino];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if([self.field isTetrominoInBounds:rotated noCollisionWith:userTetromino])
    {
        [self.field.board DeleteBlock:userTetromino];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

        [self UpdatesNewTetromino:userTetromino];


    }
}

-(void)UpdatesNewTetromino:(Tetromino*) ToTetromino
{
    [self.field setPositionUsingFieldValue:ToTetromino.children];

    [self.field.board addTetrominoToBoard:ToTetromino.children];

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

    //location = [[CCDirector sharedDirector] convertToGL:location];

    //TODO: Maybe change this so that the bottom left == (0,0 instead of (0,19)?
    if (location.y > lowestY)
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
            [self moveDownOrCreate];
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