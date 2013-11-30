//
// Created by Nicolas Martin on 13-08-11.
//
//



#import "Board.h"
#import "Tetromino.h"
#import "cocos2d.h"

@interface Field : CCLayer {//<GameControllerObserver> {


}

@property (nonatomic, strong) Board *board;
@property (nonatomic) NSUInteger Width;
@property (nonatomic) NSUInteger Height;
@property (nonatomic) NSUInteger TileSize;




- (id)initWithBoard:(Board *)board FieldHeight:(NSUInteger)FieldHeight FieldWidth:(NSUInteger)FieldWidth TileSize:(NSUInteger)TileSize;

+ (id)fieldWithBoard:(Board *)board FieldHeight:(NSUInteger)FieldHeight FieldWidth:(NSUInteger)FieldWidth TileSize:(NSUInteger)TileSize;

- (BOOL)checkForRowsToClear:(NSMutableArray *)array;

- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY;

- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX;

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;

- (BOOL)boardRowEmpty:(NSUInteger)x;

- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;


@end