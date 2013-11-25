//
// Created by Nicolas Martin on 13-08-15.
//
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Tetromino.h"


@interface Board : NSObject

@property (readwrite, assign) int NbBlocks;

@property(nonatomic) int Nby;

@property(nonatomic) int Nbx;

- (id)init;

+ (id)initBoard;

- (BOOL)isBlockAt:(CGPoint)point;

- (Block *)getBlockAt:(CGPoint)point;

- (void)DeleteBlock:(Tetromino *)tetromino;

- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino;

- (void)MoveBlock:(Block *)block from:(CGPoint)before to:(CGPoint)after;

- (BOOL)boardRowFull:(int)y;

- (void)clearFullRows;

- (void)addTetrominoToBoard:(Tetromino *)tetromino;
@end