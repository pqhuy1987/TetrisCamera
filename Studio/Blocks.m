//
//  Blocks.m
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import "Blocks.h"
#import   "TetrizController.h"
@implementation Blocks
@synthesize subBlocksCenter,blockType,mainBlockCenter,blockRotation;
- (id)initWithBlockType:(BlockType)type Center:(CGPoint)center{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        GridSize=64;
    else
    {
        if(IS_IPHONE_5)
            GridSize=32;
        else         GridSize=28;
        
        
    }    blockType = type;
    
    
    mainBlockCenter = center;
    CGRect frame;
    switch (type) {
        case Type_I:
            frame = CGRectMake(GridSize*(1+2+3/4), 0, GridSize * 4, GridSize * 4);
            break;
        case Type_O:
            frame = CGRectMake(GridSize*4.0, 0, GridSize * 2, GridSize * 2);
            break;
        case Type_J:
        case Type_L:
        case Type_S:
        case Type_T:
        case Type_Z:
            frame = CGRectMake(GridSize*4.0, 0, GridSize * 3, GridSize * 3);
            break;
        default:
            break;
    }
   
    
    
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            GridSize=64;
        else
        {
            if(IS_IPHONE_5)
                GridSize=32;
            else         GridSize=28;
            
            
        }        [self setBackgroundColor:[UIColor clearColor]];
        blockRotation = Block_Original;
        //initializing blocks
        subBlocksCenter = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_BLOCKS];
        CGPoint point = CGPointMake(1, 1);
        
        switch (blockType) {
            case Type_J:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(0, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_L:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_S:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(1, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_T:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(1, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_Z:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(1, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_I:
                point = CGPointMake(1, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                
                point = CGPointMake(0, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(2, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(3, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            case Type_O:
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];

                point = CGPointMake(0, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(0, 1);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                point = CGPointMake(1, 0);
                [subBlocksCenter addObject:[NSValue valueWithCGPoint:point]];
                break;
            default:
                break;
        }
        
    }
    return self;
}
+ (UIColor*)getBlockColorOfType:(BlockType)type{
   
    
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.95f];
    switch (type) {
        case Type_I:
            return  [UIColor colorWithRed:255/255.0f green:75/255.0f blue:0/255.0f alpha:1.0f];
            break;
        case Type_O:
            return [UIColor greenColor];
            break;
        case Type_J:
            return [UIColor colorWithRed:255/255.0f green:117/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case Type_L:
            return [UIColor colorWithRed:84/255.0f green:188/255.0f blue:242/255.0f alpha:1.0f];
            break;
        case Type_S:
            return [UIColor orangeColor];
            break;
        case Type_T:
            return [UIColor yellowColor];
            break;
        case Type_Z:
            return [UIColor colorWithRed:255/255.0f green:96/255.0f blue:115/255.0f alpha:1.0f];
            break;
        default:
            return nil;
            break;
    }
}
- (void)drawRect:(CGRect)rect
{
     CGRect rectangle;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(_isTutorial)
    {
        [[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.15f] setStroke];
[[UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:0.9f] setFill];
    }
    else {
        
    [[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:0.9f] setStroke];
    [[Blocks getBlockColorOfType:self.blockType] setFill];
    }
    for (int i = 0; i < NUMBER_OF_BLOCKS; i++) {
         rectangle = CGRectMake(([[subBlocksCenter objectAtIndex:i] CGPointValue].x) * GridSize, ([[subBlocksCenter objectAtIndex:i] CGPointValue].y) * GridSize, GridSize, GridSize);
        CGContextFillRect(context, rectangle);
        CGContextStrokeRect(context, rectangle);
    }
}



-(void)rotateBlock{
    
    if ([[TetrizController sharedInstance] gameStatus]!= GameRunning)
        return;
    
    if (blockRotation != Block_RotatationStoped) {
        if (blockRotation == Block_RotateThrice) {
            blockRotation = Block_Original;
        }
        else{
            blockRotation++;
        }
        
        NSMutableArray *copyArray=[NSMutableArray arrayWithArray:subBlocksCenter];
        //rotate the piece 90 degrees clockwise
        if (blockType == Type_I) {
 
            if (blockRotation%2 == 0) {
                CGPoint newPoint = CGPointMake(0, 0);
                copyArray[1] = [NSValue valueWithCGPoint:newPoint];
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                newPoint = CGPointMake(2, 0);
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                copyArray[2] = [NSValue valueWithCGPoint:newPoint];
               
                newPoint = CGPointMake(3, 0);
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                copyArray[3] = [NSValue valueWithCGPoint:newPoint];
                 for(int i = 1; i < NUMBER_OF_BLOCKS; i++) {
                    int x = [copyArray[i] CGPointValue].x;
                    int y = [copyArray[i] CGPointValue].y;
                    CGPoint newPoint = CGPointMake(x, y);
                    
                    subBlocksCenter[i] = [NSValue valueWithCGPoint:newPoint];
                    
                }

            }
            else{
                CGPoint newPoint = CGPointMake(1, 1);
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                copyArray[1] = [NSValue valueWithCGPoint:newPoint];
                newPoint = CGPointMake(1, 2);
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                copyArray[2] = [NSValue valueWithCGPoint:newPoint];
                newPoint = CGPointMake(1, 3);
                if([self screenBorderCollisionForLocation:newPoint]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }

                copyArray[3] = [NSValue valueWithCGPoint:newPoint];
                
                for(int i = 1; i < NUMBER_OF_BLOCKS; i++) {
                    int x = [copyArray[i] CGPointValue].x;
                    int y = [copyArray[i] CGPointValue].y;
                    CGPoint newPoint = CGPointMake(x, y);
                    
                    subBlocksCenter[i] = [NSValue valueWithCGPoint:newPoint];
                    
                }
            }
        }
        else if (blockType != Type_O) {
            for (int i = 1; i < NUMBER_OF_BLOCKS; i++) {
                int x = [subBlocksCenter[i] CGPointValue].x;
                int y = [subBlocksCenter[i] CGPointValue].y;
                
                //up down left right
                if (x == 1 && y == 0) {
                    x = 2; y = 1;
                    
                }
                else if (x == 2 && y == 1){
                    x = 1;  y = 2;
                                     }
                else if(x == 1 && y == 2){
                    x = 0; y = 1;
                                    }
                else if(x == 0 && y == 1){
                    x = 1; y = 0;
                    
                }
                //for corners
                if (x == 0 && y == 0) {
                    x = 2; y = 0;
                    
                }
                else if (x == 2 && y == 0){
                    x = 2;  y = 2;
                    
                }
                else if(x == 2 && y == 2){
                    x = 0; y = 2;
                                    }
                else if(x == 0 && y == 2){
                    x = 0; y = 0;
                                     }
                
                CGPoint newPoint = CGPointMake(x, y);
                
               
                if([self screenBorderCollisionForLocation:newPoint]||![[TetrizController sharedInstance] canMove]){
                    copyArray=nil;
                    blockRotation--;
                    
                    return;
                    
                    
                }
    
                
                copyArray[i] = [NSValue valueWithCGPoint:newPoint];
            }
            
            for(int i = 1; i < NUMBER_OF_BLOCKS; i++) {
                int x = [copyArray[i] CGPointValue].x;
                int y = [copyArray[i] CGPointValue].y;
                CGPoint newPoint = CGPointMake(x, y);

                subBlocksCenter[i] = [NSValue valueWithCGPoint:newPoint];

            }
        }
        
        [self setNeedsDisplay];
    }



}
- (BOOL)screenBorderCollisionForLocation:(CGPoint)location
{CGPoint newViewCenter = CGPointMake(self.center.x, self.center.y);
    
    BOOL hittingEdgeOfScreen=NO;
    CGFloat i=0.5;
    
    if(self.blockType==Type_I)
        i=1;

            if((newViewCenter.x+location.x*GridSize) <= (GridSize*i) ||
            (newViewCenter.x+location.x *GridSize) > ((10+i) * GridSize))
            
            {
            hittingEdgeOfScreen = YES;
        }
    
    
    
     
    return hittingEdgeOfScreen;
}
@end
