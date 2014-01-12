//
//  RetinaReducer.h
//  iHateHex
//
//  Created by soleaf on 1/12/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetinaReducer : NSObject

@property NSImageInterpolation pngQuality;

- (void) reduceFiles:(NSArray*)fileList andAfeterRevelInFinder:(BOOL) isRevealInFinder;

@end
