//
// Created by Nicolas Martin on 13-08-11.
//
//

#import "cocos2d.h"

@class Board;
@class Tetromino;

@interface Field : CCLayer {//<GameControllerObserver> {


}

@property Board *board;
@property NSUInteger Width;
@property NSUInteger Height;
@property NSUInteger TileSize;
@property NSString *Name;
@property NSMutableArray *spellArray;


- (instancetype)initWithName:(NSString *)Name TileSize:(NSUInteger)TileSize Height:(NSUInteger)Height Width:(NSUInteger)Width board:(Board *)board;
+ (instancetype)fieldWithName:(NSString *)Name TileSize:(NSUInteger)TileSize Height:(NSUInteger)Height Width:(NSUInteger)Width board:(Board *)board;
- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage;
- (void)addSpellToField;
- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY;
- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX;
- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;
- (BOOL)boardRowEmpty:(NSUInteger)x;
- (void)addBlocks:(NSMutableArray *)blocksToAdd;
- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;


@end