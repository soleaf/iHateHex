//
//  ColorConverter.m
//  iHateHex
//
//  Created by soleaf on 1/12/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import "ColorConverter.h"

@implementation ColorConverter

+ (NSString *)stringNSColorcodeWithNSColor:(NSColor*)nsColor
{
    return [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%f green:%f blue:%f alpha:%f]",
            nsColor.redComponent,
            nsColor.greenComponent,
            nsColor.blueComponent,
            nsColor.alphaComponent];
}

+ (NSString *)stringUIColorCodeWithNSColor:(NSColor*)nsColor
{
    
    return [NSString stringWithFormat:@"[UIColor colorWithRed:%f green:%f blue:%f alpha:%f]",
            nsColor.redComponent,
            nsColor.greenComponent,
            nsColor.blueComponent,
            nsColor.alphaComponent];
}

+ (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
    
    inColorString = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (NSString*)stringHexcodeWithNSColor:(NSColor*)color
{
    return [NSString stringWithFormat:@"%02X%02X%02X",
            (int) (color.redComponent * 0xFF), (int) (color.greenComponent * 0xFF),
            (int) (color.blueComponent * 0xFF)];
}


+ (NSColor *)colorWithNSColorCodeString:(NSString*)nsColorString
{
    // NSColor code stiring to NSColor Object
    
    nsColorString = [nsColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
    sscanf([nsColorString UTF8String],
#ifdef __x86_64
           "[NSColorcolorWithCalibratedRed:%lfgreen:%lfblue:%lfalpha:%lf]",
#else
           "[NSColorcolorWithCalibratedRed:%fgreen:%fblue:%falpha:%f]",
#endif
           &r, &g, &b, &a);
    
    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
}

+ (NSColor *)colorWithUIColorCodeString:(NSString *)uiColorString
{
    // UIColor code string to NSColor Object
    
    uiColorString = [uiColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
    sscanf([uiColorString UTF8String],
#ifdef __x86_64
           
           "[UIColorcolorWithRed:%lfgreen:%lfblue:%lfalpha:%lf]",
#else
           "[UIColorcolorWithRed:%fgreen:%fblue:%falpha:%f]",
#endif
           &r, &g, &b, &a);
    
    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
}

@end
