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

@interface GameLogicLayer : CCLayer <UIGestureRecognizerDelegate>
{
	enum touchTypes {
		kNone,
		kDropBlocks,
		kBlockFlip,
		kMoveLeft,
		kMoveRight
	} touchType;
	
		
	Block *board[kLastColumn + 1][kLastRow + 1];
	
	//NSMutableArray *curRow;
	NSMutableArray *boardArray;	

	Tetromino *userTetromino;
	int frameCount;
	int moveCycleRatio;
	int difficulty;
	int score;
		
	CGPoint dragStartPoint;
	CGPoint lastDragMove;
	int lastDragStartTime;
	
	NSMutableArray *tetrominoInGame;
	
}


- (void)updateBoard:(ccTime)dt;
+(CCScene *) scene;

@end
