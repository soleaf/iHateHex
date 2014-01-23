//
//  ColorPickerView.h
//  Test
//
//  Created by Oscar Del Ben on 8/20/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

/*
 
 This Class's origin made by DibiStore.
 I Modifed it to exclude specific Window with excludeID(Window ID property)
 
 Modified by Soleaf(soleaf@gmail.com)
 https://github.com/soleaf/iHateHex/
 
 */

#import <Cocoa/Cocoa.h>

@interface ColorPicker : NSObject


/*
 
 Capture ScreenImage on mouseLocation.
 ImageSize in Implementation file. It's capturingWith, capturingHeight
 
 */
+ (NSImage *)imageAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID;


/*

 Capture NSColor on mouseLocation.
 This method's capturing image code almost same with capturing screen image method above.
 But added picking color
 */
+ (NSColor *)colorAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID;

@end
