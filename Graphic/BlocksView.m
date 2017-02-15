//
//  BlocksView.m
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import "BlocksView.h"

@implementation BlocksView

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
            
            
        }
        [self setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.1f]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < kNUMBER_OF_ROW; i++) {
        for (int j = 0; j < kNUMBER_OF_COLUMN; j++) {
            
            BlockType type = [[TetrizController alloc] getTypeAtRow:i andColumn:j];
            CGRect rectangle = CGRectMake(j * GridSize, i * GridSize, GridSize, GridSize);
            
            if (type != Type_None) {
                UIColor *color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
                CGContextSetAlpha(context, 1);
                CGContextSetFillColorWithColor(context, color.CGColor);
                CGContextFillRect(context, rectangle);
            }
            
            CGContextSetAlpha(context, 1.0);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f].CGColor);
            CGContextStrokeRect(context, rectangle);
            
            if (i == kNUMBER_OF_ROW - 1) {
              //  NSString *columnNumber = [NSString stringWithFormat:@"%d", [[GameController shareManager] columnForScreenColumn:j]];
                //[columnNumber drawInRect:rectangle withFont:[UIFont systemFontOfSize:14]];
                
            }
        }
    }
    
}

@end
