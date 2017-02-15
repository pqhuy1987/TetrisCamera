//
//  TutorialView.m
//  Tetriz
//
//  Created by YAZ on 3/5/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import "TutorialView.h"

@implementation TutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.alpha=0.95;
        
        leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, self.frame.size.height)];
        rightView=[[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, self.frame.size.height)];
        leftView.backgroundColor=[UIColor blackColor];
        rightView.backgroundColor=[UIColor whiteColor];
        [self addSubview:leftView];
        [self addSubview:rightView];
        blockLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        blockLabel.textAlignment=NSTextAlignmentCenter;
        blockLabel.text=NSLocalizedString(@"Tap The Block To Rotate",nil);
        blockLabel.font=[UIFont fontWithName:@"AvenirNextCondensed-Bold" size:28];
        blockLabel.textColor=[UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [self addSubview:blockLabel ];
        leftLabel=[[UILabel alloc] initWithFrame:CGRectMake(1, self.frame.size.height/2-100, 158, 200)];
        rightLabel=[[UILabel alloc] initWithFrame:CGRectMake(1, self.frame.size.height/2-100, 158, 200)];
 leftLabel.font=rightLabel.font=[UIFont fontWithName:@"AvenirNextCondensed-Bold" size:28];
                                leftLabel.textColor=[UIColor colorWithRed:1.0  green:1.0 blue:1.0 alpha:1.0];
                                 leftLabel.textAlignment=NSTextAlignmentCenter;
                                leftLabel.text=NSLocalizedString(@"Tap On The Left Side Of The Screen To Move The Block Left", nil);
        rightLabel.textColor=[UIColor colorWithRed:0.0  green:0.0 blue:0.0 alpha:1.0];
        leftLabel.numberOfLines=0;
        rightLabel.numberOfLines=0;

        rightLabel.textAlignment=NSTextAlignmentCenter;
         rightLabel.text=        NSLocalizedString(@"Tap On The Right Side Of The Screen To Move The Block Right", nil);
 
        [leftView addSubview:leftLabel];
        [rightView addSubview:rightLabel];
        block=[[Blocks alloc] initWithBlockType:Type_Z Center:CGPointMake(0, 0)];
        [block setFrame:CGRectMake(block.frame.origin.x-16, 64, block.frame.size.width, block.frame.size.height)];
        block.isTutorial=YES;
        [self addSubview:block];
        swipeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+120, 320, 32)];
        swipeLabel.textAlignment=NSTextAlignmentCenter;
        swipeLabel.text=NSLocalizedString(@"Swipe Down Anywhere For Hard Fall",nil);
        swipeLabel.font=[UIFont fontWithName:@"AvenirNextCondensed-Bold" size:20];
        swipeLabel.textColor=[UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [self addSubview:swipeLabel ];

        beginLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+150, 320, 32)];
        beginLabel.textAlignment=NSTextAlignmentCenter;
        beginLabel.text=NSLocalizedString(@"Tap To Begin!!",nil);
        beginLabel.font=[UIFont fontWithName:@"AvenirNextCondensed-Bold" size:15];
        beginLabel.textColor=[UIColor colorWithRed:0/255.0f green:150/255.0f blue:0/255.0f alpha:1.0f];
        [self addSubview:beginLabel ];
        

        
        
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

@end
