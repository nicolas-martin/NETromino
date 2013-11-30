//
// Created by Nicolas Martin on 13-08-15.
//
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Tetromino.h"


@interface Board : NSObject

@property (readwrite, assign) int NbBlocks;

@property(nonatomic) NSUInteger Nby;

@property(nonatomic) NSUInteger Nbx;

- (id)init;

+ (id)initBoard;

- (BOOL)isBlockAt:(CGPoint)point;

- (id)getBlockAt:(CGPoint)point;

- (void)DeleteBlock:(Tetromino *)tetromino;

- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino;

- (void)MoveBlock:(Block *)block to:(CGPoint)after;

- (BOOL)boardRowFull:(NSUInteger)y;

- (void)DeleteRow:(NSUInteger)y;

- (NSMutableArray *)MoveBoardDown:(NSUInteger)y;

- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd;

- (void)printCurrentBoardStatus:(BOOL)withPosition;
@end