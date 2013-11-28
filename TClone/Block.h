//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "cocos2d.h"

@interface Block : CCSprite {
	BOOL stuck;
	BOOL disappearing;
}
@property (readwrite, assign) NSUInteger boardX;
@property (readwrite, assign) NSUInteger boardY;
@property BOOL stuck;
@property BOOL disappearing;

+ (Block *)newEmptyBlockWithColorByType:(NSUInteger)blockType;
- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (void)moveByX:(NSUInteger)offsetX;
- (NSComparisonResult)compareWithBlock:(Block *)block;
-(void)MoveTo:(Block *)block;

- (NSString *)description;
+ (void)redrawBlock:(Block *)block;

@end
