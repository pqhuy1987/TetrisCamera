//
//  BlocksView.h
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Blocks.h"
#import "TetrizController.h"
@interface BlocksView : UIView{
    int GridSize;

}
@property (nonatomic, assign) BlockType currentBlockType;

@end
