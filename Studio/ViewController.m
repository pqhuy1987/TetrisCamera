//
//  ViewController.m
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import "ViewController.h"

#define ID_GAMECENTER_SCORE @"Tetromino.World.Score"

#define kControllerMoveSensitivity      40.0f
#define kControllerRotateSensitivity    5.0f
 @interface ViewController (){
    
}
@property (nonatomic, retain) Blocks *movingBlock;
@property (nonatomic, retain) BlocksView *blocksView;
@end

@implementation ViewController
bool _enableGameCenter = NO;

@synthesize movingBlock,bottomView,startButton,scoreLabel,speedLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}

- (void)viewDidLoad
{    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredForground)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        GridSize=64;
    else
    {
         if(IS_IPHONE_5)
        GridSize=32;
         else         GridSize=28;

        
    }
    [self setupBackground];
    [self setupStackView];
     [self setupButton];
    [self setupLabels];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
   

    [self authenticateLocalPlayer];
    [self setupBanner];
    [self START];
 
}
-(void)handleEnteredBackground{
    if ([[TetrizController sharedInstance] gameStatus] == GameRunning) { //pause game
        [[TetrizController sharedInstance] pauseGame];
        
    }
 

}
-(void)handleEnteredForground{
    if ([[TetrizController sharedInstance] gameStatus] == GamePaused) { //pause game
        [self START];
        
    }
#ifndef ANDROID

    [self.captureSession startRunning];

#endif

}
-(void)setupBanner{
#ifndef ANDROID

    self.banner =[[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
   
        [self.banner setFrame:CGRectMake(0,self.view.bounds.size.height, self.view.bounds.size.width, 50)];

    
    [self.view addSubview:self.banner];
    self.banner.hidden =YES;
    
    self.banner.delegate = self;
#endif

    
}
#ifndef ANDROID
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    if (!willLeave)
    {
        if ([[TetrizController sharedInstance] gameStatus] == GameRunning) { //pause game
            [[TetrizController sharedInstance] pauseGame];
            [self.startButton setImage:[UIImage imageNamed:@"media-play.png"] forState:UIControlStateNormal];
        }

    }
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
    
    if([[TetrizController sharedInstance] gameStatus] == GamePaused) { //resume game
        [self.startButton setImage:[UIImage imageNamed:@"media-pause.png"] forState:UIControlStateNormal];
        [[TetrizController sharedInstance] resumeGame];
    }

    
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    banner.hidden = NO;
     [UIView animateWithDuration:0.3f
                          delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
         
                        
                             [self.banner setFrame:CGRectMake(0,self.view.bounds.size.height-60, self.view.bounds.size.width, 50)];

                         
                     }  completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    [UIView animateWithDuration:0.3f
                          delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        
                      
                             [self.banner setFrame:CGRectMake(0,self.view.bounds.size.height, self.view.bounds.size.width, 50)];
                         
                         
                         
                     }  completion:^(BOOL finished){
                         
                         
                                                  banner.hidden = YES;
                         
                         
                     }];
    
    
    
    
    
    
    
    
}
#endif
-(void)shouldDisplayAd{
#ifndef ANDROID

    if(self.banner.frame.origin.y==50&&[[TetrizController sharedInstance] gameStatus]!= GameRunning)
    self.banner.hidden = NO;
    else if(self.banner.frame.origin.y==50&&[[TetrizController sharedInstance] gameStatus]== GameRunning)
self.banner.hidden = YES;
#endif
}


-(void)setupBackground{
#ifndef ANDROID

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
    {
        self.cameraView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];
        
        
    }
    else {
        if(IS_IPHONE_5)
            self.cameraView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];
        else
            self.cameraView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];
        
        
    }
    [self.view addSubview:self.cameraView];
    self.cameraView.backgroundColor=[UIColor whiteColor];
    self.cameraView.alpha=.8;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        [self.captureSession addInput:input];
        [self.captureSession setSessionPreset:@"AVCaptureSessionPresetPhoto"];
        [self.captureSession startRunning];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.cameraView.frame;
        self.previewLayer.backgroundColor=[UIColor whiteColor].CGColor;
        
        [self.cameraView.layer addSublayer:self.previewLayer];
[self.view setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    }
#else
    [self.view setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];

#endif

 }
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupStackView
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    self.blocksView  = [[BlocksView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];
 
}
else
{
    if(IS_IPHONE_5)

    self.blocksView  = [[BlocksView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];
    
    else
        
        self.blocksView  = [[BlocksView alloc] initWithFrame:CGRectMake(0, 0, GridSize * kNUMBER_OF_COLUMN, GridSize * kNUMBER_OF_ROW)];

}
        UISwipeGestureRecognizer *downGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeDown:)];
    downGesture.direction=UISwipeGestureRecognizerDirectionDown;
    [self.blocksView addGestureRecognizer:downGesture];
    [self.view addSubview:self.blocksView];
 
}
-(void)setupButton{
    
    startButton=[[UIButton alloc] initWithFrame:CGRectMake(32,64, 32 ,32 )];
    [startButton setImage:[UIImage imageNamed:@"media-play.png"]    forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGameClickeed:) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:startButton ];
}
 - (void)update{
    if ([[TetrizController sharedInstance] gameStatus] == GameStopped) {
        movingBlock = nil;
    }

    [self.blocksView setNeedsDisplay];
}
- (void)refresh
{
    [self.blocksView setNeedsDisplay];
}

- (void)dropNewBlock{
    movingBlock = [[TetrizController sharedInstance] generateBlock];
    [self.view addSubview:movingBlock];
    
}


- (void)removeCurrentBlock{
    [movingBlock removeFromSuperview];
    movingBlock = nil;

}
- (void)leftClicked:(id)sender{
    [[TetrizController sharedInstance] moveBlockLeft];
}


- (void)rightClicked:(id)sender{
    [[TetrizController sharedInstance] moveBlockRight];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[TetrizController sharedInstance] gameStatus]!= GameRunning)
        return;
    _touchDistanceMoved = 0.0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint previous, now;
    CGFloat xDiff, yDiff;
    static CGFloat xDistanceMoved = 0.0;
    static CGFloat yDistanceMoved = 0.0;
    
    previous = [touch previousLocationInView:self.view];
    now = [touch locationInView:self.view];
    xDiff = now.x - previous.x;
    yDiff = now.y - previous.y;
    _touchDistanceMoved += fabsf(xDiff) + fabsf(yDiff);
    
    // Change in X direction?
    if ((xDistanceMoved > 0 && xDiff < 0) || (xDistanceMoved < 0 && xDiff > 0))
        xDistanceMoved = xDiff;
    else
        xDistanceMoved += xDiff;
    
    // Change in Y direction?
    if ((yDistanceMoved > 0 && yDiff < 0) || (yDistanceMoved < 0 && yDiff > 0))
        yDistanceMoved = yDiff;
    else
        yDistanceMoved += yDiff;
    
    if (fabsf(xDistanceMoved) >= kControllerMoveSensitivity) {
        if (xDistanceMoved < 0.0) {
            [self leftClicked:nil];
        } else if (xDistanceMoved > 0.0) {
            [self rightClicked:nil];
        }
        
        xDistanceMoved = 0.0;
    }
    
    }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchDistanceMoved <= kControllerRotateSensitivity) {
        [[TetrizController sharedInstance] rotateBlock];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    
    
    return YES;
}

- (IBAction)respondToSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if ([[TetrizController sharedInstance] gameStatus]== GameRunning) {
        [[TetrizController sharedInstance] dropPiece];
    }
}
- (IBAction)startGameClickeed:(id)sender{
     if ([[TetrizController sharedInstance] gameStatus] == GameRunning) { //pause game
        [[TetrizController sharedInstance] pauseGame];
        [self.startButton setImage:[UIImage imageNamed:@"media-play.png"] forState:UIControlStateNormal];
         
    }
    else if([[TetrizController sharedInstance] gameStatus] == GameStopped) { //start game
        [[TetrizController sharedInstance] setDelegate:self];
        [[TetrizController sharedInstance] startGame];
 
        [self.startButton setImage:[UIImage imageNamed:@"media-pause.png"] forState:UIControlStateNormal];
        movingBlock = [[TetrizController sharedInstance] generateBlock];
        [self.view addSubview:movingBlock];
    }
    else if([[TetrizController sharedInstance] gameStatus] == GamePaused) { //resume game
        [self.startButton setImage:[UIImage imageNamed:@"media-pause.png"] forState:UIControlStateNormal];
        [[TetrizController sharedInstance] resumeGame];
    }
    
}

- (IBAction)stopGame:(id)sender{
     [self.startButton setImage:[UIImage imageNamed:@"media-play.png"] forState:UIControlStateNormal];
    
    [self removeCurrentBlock];
    
    [[TetrizController sharedInstance] gameOver];
}


- (void)updateScore:(int)newScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", newScore];
}


- (void)updateSpeed:(float)newSpeed{
    if(newSpeed>.40f)
    self.speedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Speed Increased!",nil)];
    
    else self.speedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Max Speed!",nil)];
    
     self.speedLabel.alpha = 0.0;
    [self.view bringSubviewToFront:self.speedLabel];
    [UIView animateWithDuration:4.0 animations:^{
        self.speedLabel.hidden = NO;
       self.speedLabel.alpha = 1.0;
    } completion:^(BOOL finished){
        self.speedLabel.alpha = 0.0;
        self.speedLabel.hidden = YES;
    }];
}


- (void)gameOver
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *value;
    value = [ud objectForKey:ID_GAMECENTER_SCORE];
    int lastGameScore=0;
    if (value) {
        lastGameScore=value.intValue;
    }
    if ([[TetrizController sharedInstance] gameScore]>lastGameScore) {
        [ud setObject:[NSString stringWithFormat:@"%i",[[TetrizController sharedInstance] gameScore]] forKey:ID_GAMECENTER_SCORE];
        [self reportScore:ID_GAMECENTER_SCORE hiScore:[[TetrizController sharedInstance] gameScore]];
   
        lastGameScore=[[TetrizController sharedInstance] gameScore];
    }

    
    
    [self.startButton setImage:[UIImage imageNamed:@"media-play.png"] forState:UIControlStateNormal];
    [self showAlert:NSLocalizedString(@"Game Over",nil) score:[[TetrizController sharedInstance] gameScore] best:lastGameScore];
   

}
- (void)START
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *value;
    value = [ud objectForKey:ID_GAMECENTER_SCORE];
    int lastGameScore=0;
    if (value) {
        lastGameScore=value.intValue;
    }
    if ([[TetrizController sharedInstance] gameScore]>lastGameScore) {
        [ud setObject:[NSString stringWithFormat:@"%i",[[TetrizController sharedInstance] gameScore]] forKey:ID_GAMECENTER_SCORE];
        [self reportScore:ID_GAMECENTER_SCORE hiScore:[[TetrizController sharedInstance] gameScore]];
        
        lastGameScore=[[TetrizController sharedInstance] gameScore];
    }
    
    
    
    [self.startButton setImage:[UIImage imageNamed:@"media-play.png"] forState:UIControlStateNormal];
    [self showAlert:@"MINOES WORLD" score:[[TetrizController sharedInstance] gameScore] best:lastGameScore];
    
    
}
-(void)setUpTutorialView{

    tutorialView=[[TutorialView alloc] initWithFrame:self.view.frame];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGameClickeed:)];
    [tutorialView addGestureRecognizer:tap];
    [self.view addSubview:tutorialView];


}
-(void)setupLabels{
    scoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 64, self.view.frame.size.width/2, 32)];

    scoreLabel.backgroundColor=[UIColor clearColor];
    scoreLabel.textColor=[UIColor colorWithRed:1.0  green:1.0 blue:1.0 alpha:1.0];
    scoreLabel.font = [UIFont fontWithName:@"Marker Felt" size:32];
    scoreLabel.textAlignment=NSTextAlignmentCenter;
    scoreLabel.text=@"0";
    [self.view addSubview:scoreLabel ];

    speedLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 64, 95, 32)];
    
    speedLabel.backgroundColor=[UIColor clearColor];
    speedLabel.textColor=[UIColor colorWithRed:1.0  green:0.0 blue:0.0 alpha:1.0];
    speedLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:12];
    speedLabel.textAlignment=NSTextAlignmentCenter;
    speedLabel.text=@"0";
    
    [self.view addSubview:speedLabel ];
    speedLabel.hidden=YES;
}
- (void)authenticateLocalPlayer
{
#ifndef ANDROID
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    if ([localPlayer isAuthenticated] == NO) {
        localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                            NSError *error) {
            if (error) {
                _enableGameCenter = NO;
            }else{
                _enableGameCenter = YES;
                if(viewController) {
                    [self presentViewController:viewController animated:YES completion:nil];
                }
            }
        };
    }else{
        _enableGameCenter = YES;
    }
#endif
}
#ifndef ANDROID
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#endif
- (void)reportScore : (NSString*)identifier hiScore:(int64_t)score;
{
#ifndef ANDROID
    GKScore *scoreBoard = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    scoreBoard.value = score;
    [GKScore reportScores:@[scoreBoard] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"ERROR");        }
    }];
#endif
}
-(void)showGameCenter
{
    #ifndef ANDROID
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gameCenterViewController.leaderboardIdentifier = ID_GAMECENTER_SCORE;
    gameCenterViewController.gameCenterDelegate = self;
    [self presentViewController:gameCenterViewController animated:YES completion:nil];
#endif
}

-(void)showAlert:(NSString *)Title score:(int)s best:(int)b{
#ifndef ANDROID
 _vAlert = [[DoAlertView alloc] init];
    _vAlert.nAnimationType = 0;

    _vAlert.dRound = 2.0;

    _vAlert.bDestructive = NO;
    [_vAlert doYesNo:Title
                body:[NSString stringWithFormat:@"%@:%i    %@:%i",NSLocalizedString(@"Score",nil),s,NSLocalizedString(@"Best",nil),b]
                 yes:^(DoAlertView *alertView) {
                     
                     [self startGameClickeed:nil];
                     
                 } no:^(DoAlertView *alertView) {
                     
                     [self showGameCenter];
                 }];
    _vAlert = nil;
#endif

}

@end
