//
//  SoundController.m
//  Pong
//
//  Created by Nicholas Kostelnik on 03/04/2010.
//  Copyright 2010 Black Art Studios. All rights reserved.
//

#import "SoundSystem.h"

@implementation SoundSystem

- (id)init {
    self = [super init];
    
    if (self != nil){
        
        [self cacheSounds];
    }
	return self;
}

- (void)playSound:(NSString*)soundFile {
#ifndef ANDROID

	CFStringRef prefix = CFStringCreateWithCString(kCFAllocatorDefault, [soundFile cStringUsingEncoding:NSASCIIStringEncoding], kCFStringEncodingUTF8);
	CFStringRef postfix = CFStringCreateWithCString(kCFAllocatorDefault, "wav", kCFStringEncodingUTF8);
	
	CFURLRef url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), prefix, postfix, NULL);
	
	CFRelease(prefix);
	CFRelease(postfix);
	
	SystemSoundID sound;
	AudioServicesCreateSystemSoundID(url, &sound);
	CFRelease(url);
	
	AudioServicesPlaySystemSound(sound);
#endif
}

- (void)playBlankSound {
	[self playSound:@"blank"];
}
-(void)playMoveSound{
	[self playSound:@"bounce"];


}
- (void)playDropSound {
	[self playSound:@"fall"];
}
- (void)playPointSound {
	[self playSound:@"lineClear"];
}
- (void)cacheSounds {	
	/*AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("hit"), CFSTR("wav"), NULL), &hit);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("bounce"), CFSTR("wav"), NULL), &bounce);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("score"), CFSTR("wav"), NULL), &score);
*/	[self playBlankSound];	
}

- (void)playHitSound {
	[self playSound:@"hit"];
	//AudioServicesPlaySystemSound(hit);
}

- (void)playBounceSound {
	[self playSound:@"bounce"];
	//AudioServicesPlaySystemSound(bounce);
}

- (void)playScoreSound {
	[self playSound:@"score"];
	//AudioServicesPlaySystemSound(score);
}

@end
