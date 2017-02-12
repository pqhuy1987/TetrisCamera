//
//  TutorialView.h
//  Tetriz
//
//  Created by YAZ on 3/5/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Blocks.h"
@interface TutorialView : UIView
{
    UIView *leftView;
    UIView *rightView;
    UILabel *leftLabel;
    UILabel *rightLabel;
    UILabel *blockLabel;
    UILabel *swipeLabel;
    UILabel *beginLabel;

    Blocks *block;
}
@end
