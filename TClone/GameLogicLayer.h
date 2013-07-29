//
//  GameLogicLayer.h
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tetromino.h"
#import "Block.h"
#define kLastColumn 9
#define kLastRow 19

@interface GameLogicLayer : CCLayer {
	enum touchTypes {
		kNone,
		kDropBlocks,
		kBlockFlip,
		kMoveLeft,
		kMoveRight
	} touchType;
	/*
	NSMutableArray *curRow;
	NSMutableArray *array = [NSMutableArray alloc] init];
	curRow = [NSMutableArray array];
	[curRow addObject:];
	[curRow addObject:];
	[curRow addObject:];
	[array addObject:curRow]; 

	curRow = [NSMutableArray array];
	[curRow addObject:];
	[curRow addObject:];
	[curRow addObject:];
	[array addObject:curRow];
*/
	
	Block *board[kLastColumn + 1][kLastRow + 1];
	Tetromino *userTetromino;
	int frameCount;
	int moveCycleRatio;
	int difficulty;
	int score;
		
	CGPoint dragStartPoint;
	CGPoint lastDragMove;
	int lastDragStartTime;
	
	NSMutableArray *tetronimoInGame;
	
}


- (void)updateBoard:(ccTime)dt;
+(CCScene *) scene;

@end
