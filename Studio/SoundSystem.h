//
//  SoundController.h
//  Pong
//
//  Created by Nicholas Kostelnik on 03/04/2010.
//  Copyright 2010 Black Art Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface SoundSystem : NSObject {
	
	SystemSoundID hit;
	SystemSoundID bounce;
	SystemSoundID score;

}

- (void)cacheSounds;
- (void)playRotateSound;
- (void)playMoveSound;
- (void)playDropSound;
- (void)playFallSound;
- (void)playPointSound;

@end
