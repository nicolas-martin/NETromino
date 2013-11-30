//
// Created by Nicolas Martin on 13-08-11.
//
//

#import "cocos2d.h"

@class Board;
@class Tetromino;

@interface Field : CCLayer {//<GameControllerObserver> {


}

@property (nonatomic, strong) Board *board;
@property (nonatomic) NSUInteger Width;
@property (nonatomic) NSUInteger Height;
@property (nonatomic) NSUInteger TileSize;
@property (nonatomic, strong) NSObject *Name;
@property (strong) NSMutableArray *spellArray;


- (id)initWithBoard:(Board *)board FieldHeight:(NSUInteger)FieldHeight FieldWidth:(NSUInteger)FieldWidth TileSize:(NSUInteger)TileSize;

+ (id)fieldWithBoard:(Board *)board FieldHeight:(NSUInteger)FieldHeight FieldWidth:(NSUInteger)FieldWidth TileSize:(NSUInteger)TileSize;

- (BOOL)checkForRowsToClear:(NSMutableArray *)array;

- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY;

- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX;

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;

- (BOOL)boardRowEmpty:(NSUInteger)x;

- (void)addBlocks:(NSMutableArray *)blocksToAdd;

- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;


@end