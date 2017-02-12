//
//  TetrizController.m
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import "TetrizController.h"
static BlockType blocksArray[kNUMBER_OF_ROW][kNUMBER_OF_COLUMN];

float nfmod(float a,float b)
{
    return a - b * floor(a / b);
}
@implementation TetrizController
#pragma mark - Singleton
@synthesize gameStatus = _gameStatus;
@synthesize gameTimer = _gameTimer;
@synthesize delegate = _delegate;
@synthesize showAd;

static TetrizController *sharedInstance = nil;

+ (TetrizController *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}


- (id)init {
    if (self = [super init]) {
        soundSystem=[[SoundSystem alloc] init];
         self.gameSpeed =1.0f;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            GridSize=64;
        else
        {
            if(IS_IPHONE_5)
                GridSize=32;
            else         GridSize=28;
            
            
        }
    }
    return self;
}
#pragma mark - game play
- (void)startGame{
    
        for (int row_index = 0; row_index < kNUMBER_OF_ROW; row_index++) {
         
        for (int column_index = 0; column_index < kNUMBER_OF_COLUMN; column_index++) {
             int type = 0;
            blocksArray[row_index][column_index] = type;
        }
    }
    
     self.gameStatus = GameRunning;
    self.gameLevel = 1;
    self.gameScore = 0;
    self.gameSpeed =1.1f;

    
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.gameSpeed
                                                      target:self
                                                    selector:@selector(moveBlockDown)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [self.delegate refresh];
}
- (void)pauseGame{
     self.gameStatus = GamePaused;
     [self.gameTimer invalidate];
    self.gameTimer = nil;
 }
- (void)resumeGame{
     self.gameStatus = GameRunning;
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.gameSpeed
                                                      target:self
                                                    selector:@selector(moveBlockDown)
                                                    userInfo:nil
                                                     repeats:YES];
    
 }
-(void)speedUp{
    [self.gameTimer invalidate];
    self.gameTimer = nil;
    
    self.gameSpeed-=.05f;

    [self.delegate updateSpeed:self.gameSpeed];
    
    if(self.gameSpeed<.40f)
        
    {
        self.gameSpeed=.40f;
    
    }

    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.gameSpeed
                                                      target:self
                                                    selector:@selector(moveBlockDown)
                                                    userInfo:nil
                                                     repeats:YES];



}

- (BOOL)checkClearLine{
    
    int numberOfClearLine = 0;
     for (int row_index = 0; row_index < kNUMBER_OF_ROW; row_index++) {
         BOOL thislineClear = YES;
        for (int column_index = 0; column_index < kNUMBER_OF_COLUMN; column_index++) {
            if (blocksArray[row_index][column_index] == Type_None) {
                thislineClear = NO;
                break;
            }
        }
        if (thislineClear) {
            numberOfClearLine++;
            
             for (int i = row_index; i > 0; i--) {
                for (int column_index = 0; column_index < kNUMBER_OF_COLUMN; column_index++) {
                    blocksArray[i][column_index] = blocksArray[i - 1][column_index];
                }
            }
        }
    }
    
    if (numberOfClearLine > 0) {
         self.gameScore += numberOfClearLine;
       [self.delegate updateScore:self.gameScore];
        [soundSystem playPointSound];

    }
    else [soundSystem playDropSound];
    
   /*  if (self.gameScore >= self.gameLevel * 2) {
         self.gameLevel++;
         
         
         if(self.gameSpeed>.40f)
             
         {
             [self speedUp];

             
         }

    }*/
    return numberOfClearLine > 0;
}


- (void)gameOver{
    self.gameStatus = GameStopped;
    [self.gameTimer invalidate];
    self.gameTimer = nil;
    [self.delegate gameOver];
    self.gameSpeed =1.1f;
    self.gameScore = 0;
    self.gameLevel = 1;
    [self.delegate updateScore:self.gameScore];

     if([self.delegate respondsToSelector:@selector(removeCurrentBlock)])
        [self.delegate removeCurrentBlock];
    
    
    //initialize bitmap for current stack, number in each grid stands for different type of piece; 0 means the grid is empty
    for (int row_index = 0; row_index < kNUMBER_OF_ROW; row_index++) {
        for (int column_index = 0; column_index < kNUMBER_OF_COLUMN; column_index++) {
            blocksArray[row_index][column_index] = 0;
        }
    }
    
        [self.delegate update];
}
#pragma mark - control of pieces

- (Blocks *)generateBlock{
    self.canMove = YES;
    //generate a random tetris piece
    int randomNumber = arc4random() % 7 +1;
    CGPoint center=CGPointMake(4, 0);;
    if(randomNumber==Type_I)
       center=CGPointMake(1+2+3/4, 0);
    
    self.currentBlock = [[Blocks alloc] initWithBlockType:randomNumber Center:center];
    
    return self.currentBlock;
}


- (void)recordBitmapWithCurrentPiece{
     NSArray *blocks = [self.currentBlock subBlocksCenter];
    for (NSValue *block in blocks) {
        CGPoint blockPoint = [block CGPointValue];
        NSInteger column = (int)(self.currentBlock.mainBlockCenter.x + blockPoint.x) % kNUMBER_OF_COLUMN;
        NSInteger row = (int)(self.currentBlock.mainBlockCenter.y + blockPoint.y);
        [self updateViewAtColumn:(int)column andRow:(int)row withType:self.currentBlock.blockType];
    }
    
    [self.delegate update];
}
- (void)updateViewAtColumn:(int)column andRow: (int)row withType:(BlockType)type{
    blocksArray[row][column] = type;
    //update pieceStackView
    //    [self.delegate recordRectAtx:column andRow:row withType:type];
}

- (BOOL)moveBlockDown {
    
    CGPoint newViewCenter = CGPointMake(self.currentBlock.center.x, self.currentBlock.center.y + GridSize);
    CGPoint newLogicalCenter = CGPointMake(self.currentBlock.mainBlockCenter.x, self.currentBlock.mainBlockCenter.y + 1);
    
    
    NSArray *blocks = [self.currentBlock subBlocksCenter];
    BOOL hittingAPiece = NO;
    BOOL hittingTheFloor = NO;
    
    for (NSValue *block in blocks) {
        CGPoint blockPoint = [block CGPointValue];
        if (blocksArray[(int)(newLogicalCenter.y+blockPoint.y)][(int)(newLogicalCenter.x+blockPoint.x)%kNUMBER_OF_COLUMN] != Type_None
            ) {
            hittingAPiece = YES;
        }
        if ((newLogicalCenter.y + blockPoint.y) > kNUMBER_OF_ROW - 1) {
            hittingTheFloor = YES;
        }
    }
    
    if (self.canMove) {
        if (hittingAPiece || hittingTheFloor) {
            //stop moving pieces
            self.canMove = NO;
            self.currentBlock.blockRotation = Block_RotatationStoped;
            [self recordBitmapWithCurrentPiece];
             if([self.delegate respondsToSelector:@selector(removeCurrentBlock)])
                [self.delegate removeCurrentBlock];
            
            //check whether we can clear a line
            [self checkClearLine];
            
            //check whether it's game over
            if (self.currentBlock.frame.origin.y == 0) {
                [self gameOver];
            }
            else{
                //drop a new piece
                if([self.delegate respondsToSelector:@selector(dropNewBlock)])
                    [self.delegate dropNewBlock];
            }
        }
        else{
            self.currentBlock.center = newViewCenter;
            self.currentBlock.mainBlockCenter = newLogicalCenter;
        }
    }
    
    [self.delegate update];
    
    return hittingAPiece || hittingTheFloor;
}


- (void)moveBlockLeft{
    CGPoint newViewCenter = CGPointMake(self.currentBlock.center.x - GridSize, self.currentBlock.center.y);
    CGPoint newLogicalCenter = CGPointMake(self.currentBlock.mainBlockCenter.x - 1, self.currentBlock.mainBlockCenter.y);
    
    
    if (![self screenBorderCollisionForLocation:newViewCenter] && self.canMove&&![self checkForOtherCollision:newLogicalCenter]) {
        [soundSystem playMoveSound];

        self.currentBlock.center = newViewCenter;
        self.currentBlock.mainBlockCenter = newLogicalCenter;
        
        //        NSLog(@"Current piece column  : %f", self.currentPieceView.pieceCenter.x);
    }
}

- (void)moveBlockRight{
    CGPoint newViewCenter = CGPointMake(self.currentBlock.center.x + GridSize, self.currentBlock.center.y);
    CGPoint newLogicalCenter = CGPointMake(self.currentBlock.mainBlockCenter.x + 1, self.currentBlock.mainBlockCenter.y);
    
    
    
    if (![self screenBorderCollisionForLocation:newViewCenter]   && self.canMove&&![self checkForOtherCollision:newLogicalCenter]) {
        [soundSystem playMoveSound];
        self.currentBlock.center = newViewCenter;
        self.currentBlock.mainBlockCenter = newLogicalCenter;
        
         //        NSLog(@"Current piece column : %f", self.currentPieceView.pieceCenter.x);
    }
}
- (void)rotateBlock
{
    
    [self.currentBlock rotateBlock];
    
    }

- (void)dropPiece
{
    while (![self moveBlockDown] && self.canMove) {
        continue;
    }
}
-(BOOL)checkForOtherCollision:(CGPoint )location{

    NSArray *blocks = [self.currentBlock subBlocksCenter];
    BOOL hittingAPiece = NO;
    for (NSValue *block in blocks) {
        CGPoint blockPoint = [block CGPointValue];
        CGFloat i=0.5;
        
        if(self.currentBlock.blockType==Type_I)
            i=1;
        
        if (blocksArray[(int)(location.y+blockPoint.y)][(int)(location.x+blockPoint.x)%kNUMBER_OF_COLUMN] != Type_None
            ) {
            hittingAPiece = YES;
        }
        
        
    }
    return hittingAPiece;

}
- (BOOL)screenBorderCollisionForLocation:(CGPoint)location
{
    
    NSArray *blocks = [self.currentBlock subBlocksCenter];
    BOOL hittingEdgeOfScreen = NO;
    for (NSValue *block in blocks) {
        CGPoint blockPoint = [block CGPointValue];
        CGFloat i=0.5;
        
        if(self.currentBlock.blockType==Type_I)
            i=1;
        
        if (
            (location.x + blockPoint.x*GridSize) <= (GridSize*i) ||
            (location.x + blockPoint.x*GridSize) > ((kNUMBER_OF_COLUMN+i) * GridSize)) {
            hittingEdgeOfScreen = YES;
        }
        
        
    }
    return hittingEdgeOfScreen;
}
- (BlockType)getTypeAtRow:(int)row andColumn:(int)column{
    return blocksArray[row][column];
}
@end
