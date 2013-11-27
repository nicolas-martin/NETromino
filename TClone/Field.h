//
// Created by Nicolas Martin on 13-08-11.
//
//



#import "Board.h"
#import "Tetromino.h"


@interface Field : CCLayer {//<GameControllerObserver> {

}
@property (nonatomic, strong) Board *board;
@property (nonatomic) int Width;
@property (nonatomic) int Height;
@property (nonatomic) int TileSize;




- (id)initWithBoard:(Board *)board;

- (id)initWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize;

+ (id)fieldWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize;


+ (id)fieldWithBoard:(Board *)board;


- (void)checkForRowsToClear:(Tetromino *)array;

- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(int)offSetY;

- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(int)offSetX;

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;

- (BOOL)boardRowEmpty:(int)x;

@end