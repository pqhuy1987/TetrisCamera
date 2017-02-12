//
//  Blocks.h
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

 #define NUMBER_OF_BLOCKS 4


typedef enum{
    Block_Original = 0,
    Block_RotateOnce,
    Block_RotateTwice,
    Block_RotateThrice,
    Block_RotatationStoped
}BlockRotation;

typedef enum{
    Type_None = 0,
    Type_I,
    Type_O,
    Type_J,
    
    Type_L,
    Type_S,
    Type_Z,
    Type_T  
    
} BlockType;


@interface Blocks : UIView{

    int GridSize;
}
@property (nonatomic, assign) BOOL isTutorial;

@property (nonatomic, assign) BlockType blockType;
@property (nonatomic, assign) BlockRotation blockRotation;
@property (nonatomic, assign) CGPoint mainBlockCenter;
@property (nonatomic, retain) NSMutableArray *subBlocksCenter;
-(void)rotateBlock;
- (id)initWithBlockType:(BlockType)type Center:(CGPoint)center;
+ (UIColor*)getBlockColorOfType:(BlockType)type;

@end
