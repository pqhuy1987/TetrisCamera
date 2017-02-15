//
//  TetrizController.h
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
#import "BlocksView.h"
#import <AVFoundation/AVFoundation.h>
 #import "SoundSystem.h"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height >= 568.0f)
#define kNUMBER_OF_ROW 15
#define kNUMBER_OF_COLUMN 10
typedef enum{
    GameStopped,
    GameRunning,
    GamePaused
} GameStatus;
@protocol TetrizControllerDelegate <NSObject>

- (void)dropNewBlock;
- (void)removeCurrentBlock;
- (void)update;
- (void)refresh;

- (void)updateScore:(int)newScore;
- (void)updateSpeed:(float)newSpeed;
- (void)gameOver;
@end
@interface TetrizController : NSObject{

    SoundSystem *soundSystem;
    int GridSize;
 }
@property (nonatomic, assign) id<TetrizControllerDelegate> delegate;
 @property (nonatomic, assign) int gameScore;
@property (nonatomic, assign) int gameLevel;
@property (nonatomic, assign) BOOL showAd;

@property (nonatomic, assign) float gameSpeed;
@property (nonatomic, retain) Blocks *currentBlock;
@property (nonatomic, assign) GameStatus gameStatus;

@property (nonatomic, retain) NSTimer *gameTimer;
 
@property (nonatomic,assign) BOOL canMove;
- (BlockType)getTypeAtRow:(int)row andColumn:(int)column;

+(TetrizController *)sharedInstance;
 - (Blocks *)generateBlock;
- (void)startGame;
- (void)pauseGame;
- (void)resumeGame;
- (void)gameOver;
- (void)moveBlockLeft;
- (void)moveBlockRight;
- (BOOL)moveBlockDown;
- (void)dropPiece;
- (void)rotateBlock;
@end
