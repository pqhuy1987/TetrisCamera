//
//  ViewController.h
//  Tetriz
//
//  Created by YAZ on 3/1/14.
//  Copyright (c) 2014 Haris Rafiq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrizController.h"
#import "TutorialView.h"
#ifndef ANDROID
#import <GameKit/GameKit.h>
#import "DoAlertView.h"
#import "iAd/iAd.h"
 #endif
#ifndef ANDROID
@interface ViewController : UIViewController<TetrizControllerDelegate,GKGameCenterControllerDelegate,ADBannerViewDelegate>{
    int GridSize;
     TutorialView *tutorialView;
@private
    CGFloat _touchDistanceMoved;
}

@property (strong, nonatomic)   DoAlertView                 *vAlert;
@property (strong, nonatomic) ADBannerView *banner;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
#else
@interface ViewController : UIViewController<TetrizControllerDelegate>{
    int GridSize;
    TutorialView *tutorialView;
@private
    CGFloat _touchDistanceMoved;
}
#endif

@property (nonatomic, retain) UILabel *speedLabel;
@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UIButton *startButton;
 @property (nonatomic, retain) UILabel *gameStatusLabel;

@property (nonatomic, retain) UIView *cameraView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIView *topView;

 @end
