//
//  ColorPickerView.m
//  Test
//
//  Created by Oscar Del Ben on 8/20/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "ColorPicker.h"
#define kWidth 9
#define kHeight 9

@implementation ColorPicker

+ (NSImage *)imageForLocation:(NSPoint)mouseLocation
{
    CGRect imageRect = CGRectMake(mouseLocation.x - kWidth / 2, mouseLocation.y - kHeight / 2, kWidth, kHeight);
    
    CGImageRef imageRef = CGWindowListCreateImage(imageRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageShouldBeOpaque);
        
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(kWidth, kHeight)];
    
    CGImageRelease(imageRef);
    
    return image;

}

+ (NSImage *)imageAtLocation:(NSPoint)mouseLocation excludeWindowId:(uint32)excludeID
{
    
    CGRect imageRect = CGRectMake(mouseLocation.x - kWidth / 2, mouseLocation.y - kHeight / 2, kWidth, kHeight);
    
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
