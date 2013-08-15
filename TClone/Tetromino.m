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
@synthesize anchorX;
@synthesize anchorY;
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


- (BLOCK*)contents
{
	return &(blocks[type][orientation]);
}


+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY CurrentOrientation:(NSInteger)CurrentOrientation;
{
	return [[self alloc] initWithTypeRotationPosition:blockType rotationDirection:blockOrientation BoardX:positionX BoardY:positionY CurrentOrientation:CurrentOrientation];
}

- (id)initWithTypeRotationPosition:(tetrominoType)blockType rotationDirection:(RotationDirection)blockDirection BoardX:(NSInteger)positionX BoardY:(NSInteger)positionY CurrentOrientation:(NSInteger)CurrentOrientation;
{
	if (self = [super init])
	{
		self.anchorX = positionX;
		self.anchorY = positionY;
		type = blockType;
		orientation = CurrentOrientation;

		orientation = (orientation + blockDirection + [self numOrientations]) % [self numOrientations];

		_blocksInTetromino = [[NSMutableArray alloc] init];
		
		BLOCK* contents = [self contents];
		
		for (NSInteger row = 0; row < 4; row++)
		{
			for (NSInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];
				
				// If the cell is empty, skip to the next iteration of the Ïloop
				if (cellType == 0)
					continue;
				
				Block *newBlock = [Block newEmptyBlockWithColorByType:type];
				newBlock.boardX = (row + anchorX);
				newBlock.boardY = col + anchorY;
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
				
		
		
		orientation = randomOrientation;
		_blocksInTetromino = [[NSMutableArray alloc] init];
				
		BLOCK* contents = [self contents];
		
		self.anchorX = rowoffset;
		self.anchorY = 0;
		
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
				newBlock.boardX = row + anchorX;
				newBlock.boardY = col + anchorY;
				newBlock.position = COMPUTE_X_Y(newBlock.boardX, newBlock.boardY);
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
				
		[self initializeTetromino];
		
	}
	return self;
}
+ (void)RemoveBlock:(Block*) blockToRemove
{
	
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
	/*Block *firstBlock = [children_ objectAtIndex:0];
	self.anchorX = firstBlock.boardX;
	self.anchorY = firstBlock.boardY;*/
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

+ (id)moveTetrominoRight:(Tetromino *)tetrominoToMove {
    return nil;
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
	
	for (Block *currentBlock in reversedChildren)
	{
		//move each block down
		[currentBlock moveDown];
	}

	self.anchorY += 1;	
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
	return [NSString stringWithFormat:@"%@: type = %d, boardX = %d, boardY = %d, orientation = %d", [super description], type, anchorX, anchorY, orientation];
}


@end
