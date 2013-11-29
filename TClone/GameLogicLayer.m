//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "GameLogicLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "Field.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
GameController *gameController1;
GameController *gameController2;
GameController *gameController3;

GameController *gameController4;

@interface GameLogicLayer (private)

- (void)startGame;

@end

@implementation GameLogicLayer


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];

    GameLogicLayer *layer = [[GameLogicLayer alloc] init];
    [scene addChild: layer];
    
    return scene;
}

- (id)init {

	if ((self = [super init]))
	{
        playerWidth = 160;
        playerHeight = 320;
        playerTileSize = 16;

        mainWidth = 320;
        mainHeight = 740;
        mainTileSize = 32;

        _MainField = [Field node];
        _FieldLayer1 = [Field node];
        _FieldLayer2 = [Field node];
        _FieldLayer3 = [Field node];
        _FieldLayer4 = [Field node];

        Board *mainBoard = [Board initBoard];
        Board *player1Board = [Board initBoard];
        Board *player2Board = [Board initBoard];
        Board *player3Board = [Board initBoard];
        Board *player4Board = [Board initBoard];

        [_MainField initWithBoard:mainBoard FieldHeight:640 FieldWidth:320 TileSize:32];
        [_FieldLayer1 initWithBoard:player1Board FieldHeight:320 FieldWidth:160 TileSize:16];
        [_FieldLayer2 initWithBoard:player2Board FieldHeight:320 FieldWidth:160 TileSize:16];
        [_FieldLayer3 initWithBoard:player3Board FieldHeight:320 FieldWidth:160 TileSize:16];
        [_FieldLayer4 initWithBoard:player4Board FieldHeight:320 FieldWidth:160 TileSize:16];


        CGSize winSize = [CCDirector sharedDirector].winSize;

        //Set the field position on screen
        [_MainField setPosition:ccp(0,0)];
        [_MainField setContentSize:CGSizeMake(mainWidth, mainHeight)];
        CCLayerColor *layerColorMain = [CCLayerColor layerWithColor:ccc4(50, 50, 100, 128) width:_MainField.contentSize.width height:_MainField.contentSize.height];
        [_MainField addChild:layerColorMain z:-1];

        [_FieldLayer1 setPosition:ccp(winSize.width - playerWidth, 0)];
        [_FieldLayer1 setContentSize:CGSizeMake(playerWidth, playerHeight)];
        CCLayerColor *layerColor1 = [CCLayerColor layerWithColor:ccc4(100, 150, 50, 128) width:_FieldLayer1.contentSize.width height:_FieldLayer1.contentSize.height];
        [_FieldLayer1 addChild:layerColor1 z:-1];

        [_FieldLayer2 setPosition:ccp(winSize.width - playerWidth, winSize.height - playerHeight)];
        [_FieldLayer2 setContentSize:CGSizeMake(playerWidth, playerHeight)];
        CCLayerColor *layerColor2 = [CCLayerColor layerWithColor:ccc4(200, 50, 100, 128) width:_FieldLayer2.contentSize.width height:_FieldLayer2.contentSize.height];
        [_FieldLayer2 addChild:layerColor2 z:-1];

        [_FieldLayer3 setPosition:ccp(winSize.width - (playerWidth + 200), 0)];
        [_FieldLayer3 setContentSize:CGSizeMake(playerWidth, playerHeight)];
        CCLayerColor *layerColor3 = [CCLayerColor layerWithColor:ccc4(200, 50, 100, 128) width:_FieldLayer3.contentSize.width height:_FieldLayer3.contentSize.height];
        [_FieldLayer3 addChild:layerColor3 z:-1];

        [_FieldLayer4 setPosition:ccp(winSize.width - (playerWidth + 200), winSize.height - (playerHeight))];
        _FieldLayer4.contentSize = CGSizeMake(playerWidth, playerHeight);
        CCLayerColor *layerColor4 = [CCLayerColor layerWithColor:ccc4(200, 50, 100, 128) width:_FieldLayer4.contentSize.width height:_FieldLayer4.contentSize.height];
        [_FieldLayer4 addChild:layerColor4 z:-1];

        [self addChild:_MainField z:-1];
        [self addChild:_FieldLayer1 z:-1];
        [self addChild:_FieldLayer2 z:-1];
        [self addChild:_FieldLayer3 z:-1];
        [self addChild:_FieldLayer4 z:-1];

        self.isTouchEnabled = YES;

		//creates the swipeRight gesture recognizer for the layer
		UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGestureRecognizer:)];
		swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		swipeRightGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeRightGestureRecognizer];

        //creates the swipeLeft gesture recognizer for the layer
		UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGestureRecognizer:)];
		swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		swipeLeftGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeLeftGestureRecognizer];

        //Creates a new controller with a field.
        _gameController = [GameController controllerWithField:_MainField];

        //////// TESTING ////////
        gameController1 = [GameController controllerWithField:_FieldLayer1];
        gameController2 = [GameController controllerWithField:_FieldLayer2];
        gameController3 = [GameController controllerWithField:_FieldLayer3];
        gameController4 = [GameController controllerWithField:_FieldLayer4];
        Block *block = [Block newEmptyBlockWithColorByType:2];
        [block setBoardX:5];
        [block setBoardY:10];
        NSMutableArray *bArray = [NSMutableArray array];
        [bArray addObject:block];
        [gameController1 addBlocks:bArray];
        //////// TESTING ////////

        [self startGame];
	
	}
	return self;
}

//Returns the tileCoordinate from a X and Y position
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    NSUInteger x = (NSUInteger) (position.x / mainTileSize);//500,200
    NSUInteger y = (NSUInteger) (20-(((mainHeight) - position.y) / mainTileSize));
    //NSLog(@"position clicked on board x = %d and y = %d", x, y);
    return ccp(x, y);
}
- (void)swipeRightGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[_gameController rotateTetromino:rotateClockwise];
	
}

- (void)swipeLeftGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[_gameController rotateTetromino:rotateCounterclockwise];
	
}

- (void)startGame{


	[_gameController tryToCreateNewTetromino];
    [gameController1 tryToCreateNewTetromino];
    [gameController2 tryToCreateNewTetromino];
    [gameController3 tryToCreateNewTetromino];
    [gameController4 tryToCreateNewTetromino];

	frameCount = 0;
	moveCycleRatio = 10;
    [self schedule:@selector(updateBoard:) interval:(1.0 / 60.0)];
}

- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4 {
    return nil;
}

- (void)updateBoard:(ccTime)dt  {
    frameCount += 1;
    if (frameCount % moveCycleRatio == 0)
    {
        [_gameController moveDownOrCreate];
        [gameController1 moveDownOrCreate];
        [gameController2 moveDownOrCreate];
        [gameController3 moveDownOrCreate];
        [gameController4 moveDownOrCreate];

    }
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];


    [_gameController viewTap:[self tileCoordForPosition:location]];

}


@end
