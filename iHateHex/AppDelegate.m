//
//  AppDelegate.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () < NSTextFieldDelegate >

@end

@implementation AppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
   
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

#pragma mark - Window

- (void)controlTextDidChange:(NSNotification *)notification {
    
    NSTextField *textField = [notification object];
    
    // Check invalids
    if (textField.stringValue.length < 6){
        
        self.ui_hexColPicker.color = [NSColor blackColor];
        if (textField != self.ui_hexHexField)
            self.ui_hexHexField.stringValue = @"";
        if (textField != self.ui_hexNSColorField)
            self.ui_hexNSColorField.stringValue = @"";
        if (textField != self.ui_hexUIColorField)
            self.ui_hexUIColorField.stringValue = @"";
    
        
        return;
    }
    
    // Find New Color
    NSColor *newColor = nil;
    if (textField == self.ui_hexHexField){
        newColor = [self colorWithHexColorString:textField.stringValue];
        textField.stringValue = [textField.stringValue stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    else if (textField == self.ui_hexNSColorField)
        newColor = [self colorWithNSColorCodeString:self.ui_hexNSColorField.stringValue];
    else if (textField == self.ui_hexUIColorField)
        newColor = [self colorWithUIColorCodeString:self.ui_hexUIColorField.stringValue];
    
    // Apply New Color to controls
    self.ui_hexColPicker.color = newColor;
    if (textField != self.ui_hexHexField)
        self.ui_hexHexField.stringValue = [self stringHexcodeWithNSColor:newColor];
    if (textField != self.ui_hexNSColorField)
        self.ui_hexNSColorField.stringValue = [self stringNSColorcodeWithNSColor:newColor];
    if (textField != self.ui_hexUIColorField)
        self.ui_hexUIColorField.stringValue = [self stringUIColorCodeWithNSColor:newColor];
    
}


#pragma mark - Events

- (IBAction)changedSegments:(id)sender {
    
    NSSegmentedControl *segmentedCtr = (NSSegmentedControl*)sender;
    [self.tabView selectTabViewItemAtIndex:segmentedCtr.selectedSegment];
    
}


- (IBAction)changedHexColorPicker:(id)sender {
    
    // Find New Color
    NSColor *newColor = self.ui_hexColPicker.color;
    
    // Apply New Color to controls
    self.ui_hexHexField.stringValue     = [self stringHexcodeWithNSColor:newColor];
    self.ui_hexNSColorField.stringValue = [self stringNSColorcodeWithNSColor:newColor];
    self.ui_hexUIColorField.stringValue = [self stringUIColorCodeWithNSColor:newColor];
    
}


- (IBAction)clickedCopyButton:(id)sender {
    
    // Copy to clipboard
    
    NSButton *button = (NSButton*)sender;
    NSString *targetString = nil;
    
    switch (button.tag) {
        case 0:
            targetString = self.ui_hexHexField.stringValue;
            break;
        case 1:
            targetString = self.ui_hexUIColorField.stringValue;
            break;
        case 2:
            targetString = self.ui_hexNSColorField.stringValue;
            break;
        default:
            break;
    }
    
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:targetString  forType:NSStringPboardType];
    
}


#pragma mark - ColorConvert

- (NSString *)stringNSColorcodeWithNSColor:(NSColor*)nsColor
{
    return [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%f green:%f blue:%f alpha:%f]",
            nsColor.redComponent,
            nsColor.greenComponent,
            nsColor.blueComponent,
            nsColor.alphaComponent];
}

- (NSString *)stringUIColorCodeWithNSColor:(NSColor*)nsColor
{

    return [NSString stringWithFormat:@"[UIColor colorWithRed:%f green:%f blue:%f alpha:%f]",
            nsColor.redComponent,
            nsColor.greenComponent,
            nsColor.blueComponent,
            nsColor.alphaComponent];
}

- (NSColor*)colorWithHexColorString:(NSString*)inColorString
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

- (NSString*)stringHexcodeWithNSColor:(NSColor*)color
{
    return [NSString stringWithFormat:@"%02X%02X%02X",
            (int) (color.redComponent * 0xFF), (int) (color.greenComponent * 0xFF),
            (int) (color.blueComponent * 0xFF)];
}


- (NSColor *)colorWithNSColorCodeString:(NSString*)nsColorString
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

- (NSColor *)colorWithUIColorCodeString:(NSString *)uiColorString
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
