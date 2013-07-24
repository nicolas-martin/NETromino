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
@end

@implementation Tetromino
@synthesize tetrominoType;
@synthesize boardX;
@synthesize boardY;
@synthesize orientation;
@synthesize type;

typedef uint8_t BLOCK[4][4];
static BLOCK bI[2] = {
	{
		{0,0,0,0},
		{1,1,1,1},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,1,0,0},
		{0,1,0,0},
		{0,1,0,0},
		{0,1,0,0}
	}
};
static BLOCK bO[1] = {
	{
		{0,2,2,0},
		{0,2,2,0},
		{0,0,0,0},
		{0,0,0,0}
	}
};
static BLOCK bJ[4] = {
	{
		{3,0,0,0},
		{3,3,3,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,3,3,0},
		{0,3,0,0},
		{0,3,0,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{3,3,3,0},
		{0,0,3,0},
		{0,0,0,0}
	}, {
		{0,3,0,0},
		{0,3,0,0},
		{3,3,0,0},
		{0,0,0,0}
	},
};
static BLOCK bL[4] = {
	{
		{0,0,4,0},
		{4,4,4,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,4,0,0},
		{0,4,0,0},
		{0,4,4,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{4,4,4,0},
		{4,0,0,0},
		{0,0,0,0}
	}, {
		{4,4,0,0},
		{0,4,0,0},
		{0,4,0,0},
		{0,0,0,0}
	}
};
static BLOCK bZ[2] = {
	{
		{5,5,0,0},
		{0,5,5,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,0,5,0},
		{0,5,5,0},
		{0,5,0,0},
		{0,0,0,0}
	}
};
static BLOCK bS[2] = {
	{
		{0,1,1,0},
		{1,1,0,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{1,0,0,0},
		{1,1,0,0},
		{0,1,0,0},
		{0,0,0,0}
	}
};
static BLOCK bT[4] = {
	{
		{0,2,0,0},
		{2,2,2,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,2,0,0},
		{0,2,2,0},
		{0,2,0,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{2,2,2,0},
		{0,2,0,0},
		{0,0,0,0}
	}, {
		{0,2,0,0},
		{2,2,0,0},
		{0,2,0,0},
		{0,0,0,0}
	}
};
//This is a 2D array
static BLOCK *blocks[7] = {bI, bO, bJ, bL, bZ, bS, bT};
static NSInteger orientationCount[7] = {2, 1, 4, 4, 2, 2, 4};
- (id)init
{
	if (self = [super init])
	{
		//[self generateNextBlock];
		//NSLog(@"random with arc4random %d",arc4random() % 7);
		NSLog(@"random with normal %ld", random() % 7);
		NSNumber *blockFrequency = random() % 7;
		
		type = (tetrominoType)blockFrequency;
		orientation = (random() % orientationCount[type]);
		
		_blocksInTetromino = [[NSMutableArray alloc] init];
		
		//Tetromino *tempTetromino = [self generateNextBlock];
		
		BLOCK* contents = [self contents];
		
		for (NSInteger row = 0; row < 4; row++)
		{
			for (NSInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];
				
				// If the cell is empty, skip to the next iteration of the loop
				if (cellType == 0)
					continue;
				
				Block *newBlock = [Block newEmptyBlockWithColorByType:type];
				newBlock.boardX = row + 3;
				newBlock.boardY = col;
				newBlock.position = COMPUTE_X_Y(newBlock.boardX, newBlock.boardY);
				[self addChild:newBlock];
				
				
			}
		}
		
		[_blocksInTetromino addObject:self];
		
		[self initializeTetromino];
		
	}
	return self;
}

- (BLOCK*)contents
{
	return &(blocks[type][orientation]);
}


#pragma mark -
#pragma mark Initializers

+ (id)randomBlockUsingBlockFrequency
{
	return [[[self alloc] initWithRandomTypeAndOrientationUsingFrequency] autorelease];
}

- (id)initWithRandomTypeAndOrientationUsingFrequency
{
	//NSLog(@"random with arc4random %d",arc4random() % 7);
	NSLog(@"random with normal %ld", random() % 7);
	NSNumber *blockFrequency = random() % 7;
	
	type = (tetrominoType)blockFrequency;
	orientation = (random() % orientationCount[type]);
	
	return self;
}


- (id)initWithType:(tetrominoType)blockType
	   orientation:(NSInteger)blockOrientation
{
	type = blockType;
	orientation = (blockOrientation % orientationCount[type]);
	
	return self;
}



- (void)initializeTetromino
{
	self.stuck = NO;
	//[self setShape];
	Block *firstBlock = [children_ objectAtIndex:0];
	self.boardX = firstBlock.boardX;
	self.boardY = firstBlock.boardY;
	self.anchorPoint = ccp(0,0);
}


- (Tetromino *)generateNextBlock
{
	return [Tetromino randomBlockUsingBlockFrequency];
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
