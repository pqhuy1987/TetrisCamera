//
//  MKRandoms.h
//  MKKit
//
//  Created by Matthew King on 1/17/10.
//  Copyright 2010-2011 Matt King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKObject.h"

/**
 *  @brief Preforms tasks with random numbers
 *
 *  The MKRandoms object preforms methods that return random values.  It can work with arrays
 *  or just integes to get random values.
 */
@interface MKRandoms : MKObject

//////////////////////////////////
/** @name Randoms with Arrays */

/** 
 *  Returns a random object from a given array.
 *  @param anArray Array of objects to select from.
 *  @param repeat Set to `YES` if an object can be select more than one time, `NO` if it cannot.
 *  @return id One of the objects selected from the array.
 */
- (id)randomFromArray:(NSArray *)anArray repeat:(BOOL)repeat;

/** 
 *  Returns an array resorted in a random order.
 *  @param anArray The array to resort in a random order.
 *  @return NSArray from the original array with a randomized order.
 */
- (NSArray *)randomArrayWithArray:(NSArray *)anArray;

//////////////////////////////////
/** @name Randoms with Integers */

/** 
 *  Returns and random integer between 0 and a given number.
 *  @param number The highest return value.
 *  @return int A random number between 0 and number parameter.
 */
- (int)randomNumberOutOf:(int)number;

@end
