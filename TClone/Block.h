//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "cocos2d.h"

@interface Block : CCSprite {
	BOOL stuck;
	BOOL disappearing;
}
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;
@property BOOL stuck;
@property BOOL disappearing;

+ (Block *)newEmptyBlockWithColorByType:(int)blockType;
- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (void)moveByX:(int)offsetX;
- (NSComparisonResult)compareWithBlock:(Block *)block;
-(void)MoveTo:(Block *)block;
+ (void)redrawBlock:(Block *)block;

@end
