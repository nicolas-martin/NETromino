//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"
#import "AddLine.h"
#import "Block.h"

@interface Block (private)

- (void)redrawPositionOnBoard;

@end


@implementation Block

- (instancetype)initWithBlockType:(NSUInteger)blockType {
    Block *temp = nil;
    NSString *filename = nil, *color = nil;

    self = [super init];
    if (self) {
        self.blockType = blockType;

        _spell = nil;
        switch (blockType) {
            case I_block:
                color = @"cyan";
                break;
            case O_block:
                color = @"yellow";
                break;
            case J_block:
                color = @"green";
                break;
            case L_block:
                color = @"red";
                break;
            case Z_block:
                color = @"orange";
                break;
            case S_block:
                color = @"blue";
                break;
            case T_block:
                color = @"magenta";
                break;
            default:
                break;
        }


        self.position = ccp(0,0);
        self.opacity = 255;
        self.stuck = NO;
        self.disappearing = NO;
        _boardX = 0;
        _boardY = 0;


        //TODO: Use their own sprites instead of scaling down.

        filename = [[NSString alloc] initWithFormat:@"%@.png", color];
        Block *block = [self initWithFile:filename];
        [self setAnchorPoint:ccp(0,0)];

    }

    return  self;
}

- (void) addSpellToBlock:(<ICastable>) spell
{
    _spell = spell;
    NSString *spriteFilename;
    spriteFilename = [[NSString alloc] initWithFormat:@"%@", _spell.spriteFileName];

    _spell.spriteFileName = spriteFilename;
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:_spell.spriteFileName]];

    //Block should not know which part of the field it belongs to
//    if (!_isMain)
//    {
//        [self setScale:0.7];
//    }

}

+ (instancetype)blockWithBlockType:(NSUInteger)blockType {
    return [[self alloc] initWithBlockType:blockType];
}


- (NSComparisonResult)compareWithBlock:(Block *)block
{
	return [[NSNumber numberWithInt:self.boardX]
			compare:[NSNumber numberWithInt:block.boardX]];
}


- (void)redrawPositionOnBoard
{
    //compute
	self.position = ccp(_boardX, _boardY);
}

//Remove these?
- (void)moveUp
{
	_boardY -= 1;
	[self redrawPositionOnBoard];
}

- (void)moveDown
{
	_boardY += 1;
	[self redrawPositionOnBoard];
}

-(void)MoveTo:(Block *)block
{
	_boardX = block.boardX;
	_boardY = block.boardY;
	
	[self redrawPositionOnBoard];
}

- (void)moveByX:(NSUInteger)offsetX
{
	_boardX += offsetX;
	[self redrawPositionOnBoard];
}

- (void)moveRight
{
	_boardX += 1;
	[self redrawPositionOnBoard];
}

- (void)moveLeft
{
	_boardX -= 1;
	[self redrawPositionOnBoard];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"self.boardX=%i", self.boardX];
    [description appendFormat:@", self.boardY=%i", self.boardY];

    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];

}


@end
