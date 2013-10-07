//
//  Tetromino.h
//  Tetris
//
//  Created by Joshua Aburto on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Block.h"

#define kLastColumn 9
#define kLastRow 19
#define rowoffset 3

typedef enum
{
	I_block,
	O_block,
	J_block,
	L_block,
	Z_block,
	S_block,
	T_block
} tetrominoType;


typedef enum
{
	rotateCounterclockwise = -1,
	rotateNone = 0,
	rotateClockwise = 1
} RotationDirection;

typedef enum
{
    moveLeft = -1,
    moveNone = 0,
    moveRight = 1
} MoveDirection;

@interface Tetromino : CCSprite
{
	BOOL stuck;	
	CGPoint leftMostPosition;
	CGPoint rightMostPosition;
	tetrominoType type;
	NSInteger orientation;
	
}



@property (readonly) NSInteger orientation;
@property (readwrite, strong) NSMutableArray *blocksInTetromino;
@property (assign) BOOL stuck;
@property (readwrite, assign) int anchorX;
@property (readwrite, assign) int anchorY;
@property (readonly) CGPoint leftMostPosition;
@property (readonly) CGPoint rightMostPosition;
@property (readonly) CGPoint highestPosition;
@property (readonly) CGPoint lowestPosition;


+ (id)randomBlockUsingBlockFrequency;
- (id)initWithRandomTypeAndOrientationUsingFrequency;

+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY CurrentOrientation:(NSInteger)CurrentOrientation;

- (BOOL)isBlockInTetromino:(id)block;

- (void)moveTetrominoInDirection:(Tetromino *)tetromino inDirection:(MoveDirection)direction;

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction;

- (void)moveTetrominoDown;
@end
