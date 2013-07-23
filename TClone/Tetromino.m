//
//  Tetromino.m
//  Tetris
//
//  Created by Joshua Aburto on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tetromino.h"
#import "Block.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface Tetromino (private)
- (void)initializeTetromino;
- (void)setShape;
@end

@implementation Tetromino
@synthesize tetrominoType;
@synthesize boardX;
@synthesize boardY;


- (id)init
{
	if (self = [super init])
	{
		_blocksInTetromino = [[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) {
			Block *tempBlock = [Block newBlock:tetrominoType];
			[self addChild:tempBlock];
			[_blocksInTetromino addObject:tempBlock];
			[tempBlock release];
		}
		[self initializeTetromino];
		
	}
	return self;
}


- (void)initializeTetromino
{
	self.stuck = NO;
	[self setShape];
	Block *firstBlock = [children_ objectAtIndex:0];
	self.boardX = firstBlock.boardX;
	self.boardY = firstBlock.boardY;
	self.anchorPoint = ccp(0,0);
}


- (tetrominoType*)generateNextBlock
{
	return [Block randomBlockUsingBlockFrequency:blockFrequencies];
}





//Generates a random shape
//What is the index for?
- (void)setShape
{
	NSUInteger index = 0;
	//Why is the loop there?
	for (Block *currentBlock in self.children)
	{
		
		switch (tetrominoType)
		{
			case I_block:
			{
				currentBlock.boardX = index+3;
				currentBlock.boardY = 0;
				break;
			}
			case O_block:
			{
				if (index == 0 || index == 1) {
					currentBlock.boardX = index+5;
					currentBlock.boardY = 0;
					
				} else {
					currentBlock.boardX = index+3;
					currentBlock.boardY = 1;
				}
				break;
			}
			case J_block:
			{
				if (index == 0 || index == 1) {
					currentBlock.boardX = index+6;
					currentBlock.boardY = 0;
				} else {
					currentBlock.boardX = index+3;
					currentBlock.boardY = 1;
				}
				break;
			}
			case L_block:
			{
				if (index == 0 || index == 1) {
					currentBlock.boardX = index+5;
					currentBlock.boardY = 0;
				} else {
					currentBlock.boardX = index+4;
					currentBlock.boardY = 1;
				}
				break;
			}
			case Z_block:
			{
				if (index == 3) {
					currentBlock.boardX = index+4;
					currentBlock.boardY = 1;
				} else {
					currentBlock.boardX = index+5;
					currentBlock.boardY = 0;
				}
				break;
			}
			case S_block:
			{
				if (index == 3) {
					currentBlock.boardX = index+3;
					currentBlock.boardY = 1;
				} else {
					currentBlock.boardX = index+5;
					currentBlock.boardY = 0;
				}
				break;
			}
			case T_block:
			{
				if (index == 3) {
					currentBlock.boardX = index+3;
					currentBlock.boardY = 1;
				} else {
					currentBlock.boardX = index+5;
					currentBlock.boardY = 0;
				}
				break;
			}
			default:
			{
				break;
			}
		}
		currentBlock.position = COMPUTE_X_Y(currentBlock.boardX, currentBlock.boardY);
		index++;
	}
}


- (BOOL)stuck
{
	for (Block *block in self.children) {
		stuck = block.stuck;
	}
	return stuck;
}

- (void)setStuck:(BOOL)stuckValue
{
	stuck = stuckValue;
	for (Block *block in self.children) {
		block.stuck = stuckValue;
	}
}

- (BOOL)isBlockInTetromino:(id)block
{
	for (Block *currentBlock in self.children) {
		if ([currentBlock isEqual:block]) {
			return YES;
		}
		
	}
	return NO;
}

- (void)moveTetrominoDown
{
	CCArray *reversedChildren = [[[CCArray alloc] initWithArray:children_]autorelease];  // make copy
	[reversedChildren reverseObjects]; // reverse contents
	
	for (Block *currentBlock in reversedChildren) {
		//move each block down
		[currentBlock moveDown];
	}
	//set the tetromino one down
	self.boardY += 1;
	//NSLog(@"Move down = %d, and pixel Y = %d",COMPUTE_X(self.boardX), COMPUTE_Y(self.boardY));
	//[self runAction:[MoveTo actionWithDuration:1.0/45.0 position:COMPUTE_X_Y(self.boardX, self.boardY)]];
	
	
}

- (void)dealloc
{
	
	[super dealloc];
}

- (CGPoint)leftMostPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.x > currentBlock.boardX) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myLeftPosition;
	
}

- (CGPoint)rightMostPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.x < currentBlock.boardX) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myRightPosition;
}

@end
