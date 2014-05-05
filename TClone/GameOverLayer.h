//
// Created by Nicolas Martin on 13-08-15.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer
{
    
}

+ (CCScene *)sceneWithWon:(BOOL)won andPosition:(CGPoint)position;

- (id)initWithWon:(BOOL)won withPosition:(CGPoint)position;

@end
