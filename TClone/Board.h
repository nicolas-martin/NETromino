//
// Created by Nicolas Martin on 13-08-20.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Board : NSObject {
    int Nby;
    int Nbx;

}

@property (readwrite, assign) int NbBlocks;
@property (nonatomic, strong) NSMutableArray *array;

- (id)init;

- (BOOL)isBlockAt:(CGPoint)point;

- (Block *)getBlockAt:(CGPoint)point;

- (BOOL)boardRowEmpty:(int)y;

- (void)clearFullRows;
@end