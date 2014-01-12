//
//  RetinaDropView.h
//  iHateHex
//
//  Created by soleaf on 1/11/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RetinaDropView : NSView <NSDraggingDestination>
@property NSTextField *tipLabel;
@property BOOL afterRevealInFinder;

@end
