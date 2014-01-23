//
//  ColorPickerView.m
//  Test
//
//  Created by Oscar Del Ben on 8/20/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "ColorPicker.h"
#define capturingWith   9
#define capturingHeight 9

@implementation ColorPicker


+ (NSImage *)imageAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID
{
    
    CGRect imageRect = CGRectMake(mouseLocation.x - capturingWith / 2,
                                  mouseLocation.y - capturingHeight / 2,
                                  capturingWith,
                                  capturingHeight);
    
    CFArrayRef windowIDList = CGWindowListCreate(kCGWindowListOptionOnScreenBelowWindow,excludeID);
    CGImageRef imageRef = CGWindowListCreateImageFromArray(imageRect,windowIDList, kCGWindowImageBestResolution);
    
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    
    CGImageRelease(imageRef);
    
    return image;
}

+ (NSColor *)colorAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID
{   
    CGRect imageRect = CGRectMake(mouseLocation.x, mouseLocation.y, 1, 1);
    
    CFArrayRef windowIDList = CGWindowListCreate(kCGWindowListOptionOnScreenBelowWindow,excludeID);
    CGImageRef imageRef = CGWindowListCreateImageFromArray(imageRect,windowIDList, kCGWindowImageBestResolution);
    
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);

    return [bitmapRep colorAtX:0 y:0];
}

@end
