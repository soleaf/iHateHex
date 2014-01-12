//
//  ColorConverter.h
//  iHateHex
//
//  Created by soleaf on 1/12/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorConverter : NSObject

+ (NSString *)stringNSColorcodeWithNSColor:(NSColor*)nsColor;
+ (NSString *)stringUIColorCodeWithNSColor:(NSColor*)nsColor;

+ (NSColor*)colorWithHexColorString:(NSString*)inColorString;
+ (NSString*)stringHexcodeWithNSColor:(NSColor*)color;

+ (NSColor *)colorWithNSColorCodeString:(NSString*)nsColorString;
+ (NSColor *)colorWithUIColorCodeString:(NSString *)uiColorString;


@end
