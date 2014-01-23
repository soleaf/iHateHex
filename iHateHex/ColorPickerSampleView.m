//
//  ColorPickerSampleView.m
//  iHateHex
//
//  Created by soleaf on 1/20/14.
//  Copyright (c) 2014년 soleaf. All rights reserved.
//  https://github.com/soleaf/iHateHex/

#import "ColorPickerSampleView.h"

@interface ColorPickerSampleView ()
{
    NSColor *background;
}

@end

@implementation ColorPickerSampleView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
    
        self.layer = _layer;
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = [NSColor blackColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    [background set];
    NSRectFill([self bounds]);

}

-(void)setBackground:(NSColor *)aColor
{
    if([background isEqual:aColor]) return;
    background = aColor;
    
    //This is the most crucial thing you're missing: make the view redraw itself
    [self setNeedsDisplay:YES];
}

@end
