//
// Created by Nicolas Martin on 13-08-15.
//
//

#import <Foundation/Foundation.h>
#import "Block.h"

@class Tetromino;

@interface Board : NSObject

@property int NbBlocks;
@property NSUInteger Nby;
@property NSUInteger Nbx;

- (id)init;
+ (id)initBoard;
- (BOOL)isBlockAt:(CGPoint)point;

- (NSMutableArray *)getAllBlocksInBoard;

- (id)getBlockAt:(CGPoint)point;
- (void)DeleteBlock:(Tetromino *)tetromino;
- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino;
- (void)MoveBlock:(Block *)block to:(CGPoint)after;
- (BOOL)boardRowFull:(NSUInteger)y;
- (NSMutableArray *)DeleteRow:(NSUInteger)y;
- (NSMutableArray *)MoveBoardDown:(NSUInteger)y;
- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd;
- (void)printCurrentBoardStatus:(BOOL)withPosition;

@end