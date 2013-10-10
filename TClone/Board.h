//
// Created by Nicolas Martin on 13-08-15.
//
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import "Tetromino.h"


@interface Board : NSObject {
    int Nby;
    int Nbx;

}

@property (readwrite, assign) int NbBlocks;
@property (nonatomic, strong) NSMutableArray *array;

- (id)init;

- (BOOL)isBlockAt:(CGPoint)point;

- (Block *)getBlockAt:(CGPoint)point;

- (void)MoveBlocksInBoard:(Tetromino *)tetromino in:(MoveDirection)direction;

- (BOOL)boardRowEmpty:(int)y;

- (void)clearFullRows;

- (void)addTetrominoToBoard:(Tetromino *)tetromino;
@end