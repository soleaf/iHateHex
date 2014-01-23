//
//  ColorPickerImageView.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 23..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//

#import "ColorPickerImageView.h"

@implementation ColorPickerImageView


-(void)drawRect:(NSRect)rect
{
    [[NSGraphicsContext currentContext]
     setImageInterpolation:NSImageInterpolationNone];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    
    [super drawRect:rect];
}

@end
