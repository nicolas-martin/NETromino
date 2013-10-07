//
// Created by Nicolas Martin on 13-08-11.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "Board.h"
#import "Tetromino.h"


@interface Field : CCLayer {//<GameControllerObserver> {

}
@property (nonatomic, strong) Board *board;
@property (nonatomic) int FieldWidth;
@property (nonatomic) int FieldHeight;
@property (nonatomic) int TileSize;




- (id)initWithBoard:(Board *)board;

- (id)initWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize;

+ (id)fieldWithBoard:(Board *)board FieldHeight:(int)FieldHeight FieldWidth:(int)FieldWidth TileSize:(int)TileSize;


+ (id)fieldWithBoard:(Board *)board;


- (void)checkForRowsToClear;

- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(int)offSetX;

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino;

- (BOOL)boardRowEmpty:(int)x;

@end