//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"
#import "Field.h"

@protocol GameControllerObserver <NSObject>

@optional
- (void)updateTetrominoPosition:(Tetromino *)tetromino;
@end


@interface GameController : NSObject <NSCoding> {

    Field *field;
    Tetromino *userTetromino;

    enum touchTypes {
        kNone,
        kDropBlocks,
        kMoveLeft,
        kMoveRight
    } touchType;

}

@property (nonatomic, strong) NSMutableArray* listObservers;

- (id)initWithField:(Field *)aField;

+ (id)controllerWithField:(Field *)aField;

- (void)tryToCreateNewTetromino;

- (void)rotateTetromino:(RotationDirection)direction;

- (void)viewTap:(CGPoint)location;

- (void)moveDownOrCreate;

@end