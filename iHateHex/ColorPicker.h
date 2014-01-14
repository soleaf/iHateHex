//
//  ColorPickerView.h
//  Test
//
//  Created by Oscar Del Ben on 8/20/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorPicker : NSObject

+ (NSImage *)imageAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID;
+ (NSColor *)colorAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID;

@end
