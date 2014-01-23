//
//  ColorConverter.h
//  iHateHex
//
//  Created by soleaf on 1/12/14.
//  Copyright (c) 2014년 soleaf. All rights reserved.
//  https://github.com/soleaf/iHateHex/

#import <Foundation/Foundation.h>

/*
 
 ColorConverter is 3way Color Converting by color code string.
 You must any color convert to NSColor, And NSColor conver to any color code you want.
 
 - Color code strings is ignoing case.
 - Trimed
 - Hex color code don't care it have '#'
 
 */

@interface ColorConverter : NSObject

// AnyColor -> NSColor
+ (NSColor *)colorWithHexColorString:(NSString*)inColorString;
+ (NSColor *)colorWithNSColorCodeString:(NSString*)nsColorString;
+ (NSColor *)colorWithUIColorCodeString:(NSString *)uiColorString;

// NSColor -> 3way color codes
+ (NSString *)stringNSColorcodeWithNSColor:(NSColor*)nsColor;
+ (NSString *)stringUIColorCodeWithNSColor:(NSColor*)nsColor;
+ (NSString*)stringHexcodeWithNSColor:(NSColor*)color;

@end
