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
@synthesize boardX;
@synthesize boardY;
@synthesize orientation;
@synthesize type;

typedef uint8_t BLOCK[4][4];

/*- (id)init
{
	if (self = [super init])
	{
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
}*/

- (BLOCK*)contents
{
	return &(blocks[type][orientation]);
}

- (Tetromino*)TetrominoRotatedInDirection:(RotationDirection)direction
{
	NSInteger newOrientation = (orientation + direction + [self numOrientations]) % [self numOrientations];
	//TODO Do I need to return a new one or just this one?
	return [Tetromino blockWithType:type orientation:newOrientation BoardX:boardX BoardY:boardY];
}

+ (id)blockWithType:(tetrominoType)blockType orientation:(RotationDirection)blockOrientation BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY
{
	return [[self alloc] initWithTypeRotationPosition:blockType rotationDirection:blockOrientation BoardX:positionX BoardY:positionY];
}

- (id)initWithTypeRotationPosition:(tetrominoType)blockType rotationDirection:(RotationDirection)blockDirection BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY
{
	if (self = [super init])
	{
		
		type = blockType;
		orientation = (orientation + blockDirection + [self numOrientations]) % [self numOrientations];
		
		NSLog(@"ROTATE BLOCKTYPE = %d, ORIENTATION = %d, POSITIONX = %d, POSITIONY = %d", blockType, blockDirection, positionX, positionY);
		
		_blocksInTetromino = [[NSMutableArray alloc] init];
		
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
				newBlock.boardX = (row + 3) + positionX;
				newBlock.boardY = col + positionY;
				newBlock.position = COMPUTE_X_Y(newBlock.boardX, newBlock.boardY);
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
		
		[self initializeTetromino];
		
	}
	return self;

}

- (NSInteger)numOrientations
{
	return orientationCount[type];
}


+ (id)randomBlockUsingBlockFrequency
{
	return [[self alloc] initWithRandomTypeAndOrientationUsingFrequency];
}

//This works with random orientation and random types!!
- (id)initWithRandomTypeAndOrientationUsingFrequency
{

	if (self = [super init])
	{
		
		int blockFrequency = arc4random() % 7;
		type = (tetrominoType)blockFrequency;
		int randomOrientation = arc4random() % orientationCount[type];
				
		NSLog(@"----> blockType =  %d With orientation %d",blockFrequency, randomOrientation );
		
		orientation = randomOrientation;
		_blocksInTetromino = [[NSMutableArray alloc] init];
				
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
				//[_blocksInTetromino addObject:newBlock];
				
			}
		}
				
		[self initializeTetromino];
		
	}
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
	CCArray *reversedChildren = [[CCArray alloc] initWithArray:children_];  // make copy
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

- (CGPoint)highestPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.y > currentBlock.boardY) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myLeftPosition;
	
}

- (CGPoint)lowestPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.y < currentBlock.boardY) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
	return myRightPosition;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@: type = %d, boardX = %d, boardY = %d, orientation = %d", [super description], type, boardX, boardY, orientation];
}

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
@end
