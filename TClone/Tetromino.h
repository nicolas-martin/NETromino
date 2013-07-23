//
//  Tetromino.h
//  Tetris
//
//  Created by Joshua Aburto on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Block.h"


@interface Tetromino : CCSprite {

	tetrominoType tetrominoType;
	BOOL stuck;
	
	CGPoint leftMostPosition;
	CGPoint rightMostPosition;
	
	int boardX;
	int boardY;
	NSNumber* blockFrequencies;
}



@property (readwrite, assign) NSMutableArray *blocksInTetromino;
@property (readonly) tetrominoType tetrominoType;
@property (assign) BOOL stuck;
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;


@property (readonly) CGPoint leftMostPosition;
@property (readonly) CGPoint rightMostPosition;


- (BOOL)isBlockInTetromino:(id)block;
- (void)moveTetrominoDown;

- (tetrominoType*)generateNextBlock;


@end
