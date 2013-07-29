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

@interface Tetromino : CCSprite {

	//tetrominoType tetrominoType;
	BOOL stuck;	
	CGPoint leftMostPosition;
	CGPoint rightMostPosition;	
	int boardX;
	int boardY;
	tetrominoType type;
	NSInteger orientation;
	
}


@property (readonly) tetrominoType type;
@property (readonly) NSInteger orientation;
@property (readwrite, strong) NSMutableArray *blocksInTetromino;
//@property (readonly) tetrominoType tetrominoType;
@property (assign) BOOL stuck;
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;
@property (readonly) CGPoint leftMostPosition;
@property (readonly) CGPoint rightMostPosition;
@property (readonly) CGPoint highestPosition;
@property (readonly) CGPoint lowestPosition;

+ (id)randomBlockUsingBlockFrequency;
- (id)initWithRandomTypeAndOrientationUsingFrequency;
+ (id)blockWithType:(tetrominoType)blockType orientation:(RotationDirection)blockOrientation BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY;
- (Tetromino*)TetrominoRotatedInDirection:(RotationDirection)direction;
- (BOOL)isBlockInTetromino:(id)block;
- (void)moveTetrominoDown;


@end
