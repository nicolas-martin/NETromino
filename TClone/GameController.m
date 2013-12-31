//
// Created by Nicolas Martin on 13-08-15.
//
//


#import "GameController.h"
#import "GameOverLayer.h"
#import "HudLayer.h"
#import "Field.h"
#import "Board.h"
#import "Inventory.h"
#import "Nuke.h"
#import "RandomRemove.h"
#import "AddLine.h"
#import "Gravity.h"


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface GameController ()

@end

@implementation GameController {


}

- (id)initWithField:(Field *)aField andPlayerSize:(BOOL)isMain{
    self = [super init];
    if (self) {
        self.field = aField;
        //change to init?
        HudLayer *hud = [HudLayer initLayer];
        [_field addChild:hud];
        [hud setPosition:ccp(_field.Width + 10, _field.Height + 10)];
        self.hudLayer = hud;
        self.isMain = isMain;

        Inventory *inventory = [Inventory initInventory:isMain ];
        [_field addChild:inventory];

        [inventory setPosition:ccp(inventory.contentSize.width/2, 0)];
        self.inventory = inventory;
    }

    return self;
}

+ (id)controllerWithField:(Field *)aField isMain:(BOOL)isMain {
    return [[self alloc] initWithField:aField andPlayerSize:isMain];
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

        if([_field.Name isEqual:@"MainField"])
        {
            [_field.board printCurrentBoardStatus:YES];
        }

//        RandomRemove *s = [RandomRemove init];
//        Nuke *n = [Nuke init];
        Gravity *a = [Gravity init];
        NSMutableArray *array = [NSMutableArray array];
//        [array addObject:s];
//        [array addObject:n];
        [array addObject:a];
        [self addSpellsToInventory:array];

        NSUInteger nbLinesCleared = [self checkForRowsToClear:userTetromino.children];
        if(nbLinesCleared > 0)
        {
            self.numRowCleared + nbLinesCleared;
            [_hudLayer numRowClearedChanged:_numRowCleared];
            [_field addSpellToField];
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

- (NSUInteger)checkForRowsToClear:(NSMutableArray *)blocksToCheck {

    BOOL occupied = NO;
    NSUInteger nbLinesToDelete = 0;

    NSUInteger deletedRow = (NSUInteger) nil;
    for (Block *block in blocksToCheck) {

        //Skip row already processed
        if ([block boardY] == (NSUInteger) deletedRow) {
            continue;
        }

        for (int x = 0; x < [_field.board Nbx]; x++) {

            if (![_field.board isBlockAt:ccp(x, block.boardY)]) {
                occupied = NO;
                //Since there's an empty block on this column there's no need to look at the others
                //Exits both loops and get the next row
                break;

            }
            else {
                occupied = YES;
            }
        }

        if (occupied) {

            deletedRow = [block boardY];

            NSMutableArray *spellsToAdd = [_field.board DeleteRow:(NSUInteger)deletedRow];
            if(spellsToAdd.count > 0)
            {
                [self addSpellsToInventory:spellsToAdd];
            }

            [_field setPositionUsingFieldValue:[_field.board MoveBoardDown:(NSUInteger) (deletedRow - 1)]];
            nbLinesToDelete++;

        }
        else {
            continue;
        }
    }
    return nbLinesToDelete;

}

-(void) addSpellsToInventory:(NSMutableArray *)spellsToAdd
{
    for (id <ICastable> spell in spellsToAdd)
    {
        [_inventory addSpell:spell];
    }
}



- (void)gameOver:(BOOL)won
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}



- (void)createNewTetromino {


    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency:_isMain ];

    [self VerifyNewBlockCollision:tempTetromino];

    [self.field.board addTetrominoToBoard:tempTetromino.children];

    [self.field setPositionUsingFieldValue:tempTetromino.children];

    [self.field addChild:tempTetromino];

    [self newTetromino:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown
{

    [self.field.board DeleteBlockFromBoard:userTetromino.children];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];
}

- (void)moveTetrominoLeft{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [self.field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)moveTetrominoRight{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [self.field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if([self.field isTetrominoInBounds:rotated noCollisionWith:userTetromino])
    {
        [self.field.board DeleteBlockFromBoard:userTetromino.children];

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