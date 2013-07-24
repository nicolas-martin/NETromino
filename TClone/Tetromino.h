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
@interface Tetromino : CCSprite {

	tetrominoType tetrominoType;
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

@property (readwrite, assign) NSMutableArray *blocksInTetromino;
@property (readonly) tetrominoType tetrominoType;
@property (assign) BOOL stuck;
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;


@property (readonly) CGPoint leftMostPosition;
@property (readonly) CGPoint rightMostPosition;


- (NSComparisonResult)compareWithBlock:(Block *)block;

// Create random blocks using the frequency information from the game rules
// blockFrequencies must be of length 100
+ (id)randomBlockUsingBlockFrequency;
- (id)initWithRandomTypeAndOrientationUsingFrequency;


- (BOOL)isBlockInTetromino:(id)block;
- (void)moveTetrominoDown;

- (Block*)generateNextBlock;


@end
