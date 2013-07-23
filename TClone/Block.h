//
//  Tetromino.h
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

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



@interface Block : CCSprite {
	int boardX, boardY;
	BOOL stuck;
	BOOL disappearing;
	tetrominoType type;
	NSInteger orientation;

}


@property (readonly) tetrominoType type;
@property (readonly) NSInteger orientation;
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;
@property BOOL stuck;
@property BOOL disappearing;

+ (Block *)newBlock:(int)blockType;
- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (void)moveByX:(int)offsetX;
- (void)rotateInDirection:(RotationDirection)direction;
- (NSComparisonResult)compareWithBlock:(Block *)block;
+ (id)blockWithType:(tetrominoType)blockType
		orientation:(NSInteger)blockOrientation;

// Create random blocks using the frequency information from the game rules
// blockFrequencies must be of length 100
+ (id)randomBlockUsingBlockFrequency:(NSNumber*)blockFrequency;
- (id)initWithRandomTypeAndOrientationUsingFrequency:(NSNumber*)blockFrequency;


@end

#define COMPUTE_X(x) (abs(x) * 24)
#define COMPUTE_Y(y) (456 - (abs(y) * 24))
#define COMPUTE_X_Y(x,y) ccp( COMPUTE_X(x), COMPUTE_Y(y))