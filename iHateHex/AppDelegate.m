//
//  AppDelegate.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorConverter.h"
#import "ColorPicker.h"

@interface AppDelegate () < NSTextFieldDelegate >

// ColorPicker
{
    uint32 windowID;
    
}
@property (retain) NSTimer *updateTimer;
@property (assign) BOOL updateMouseLocation;
@property (assign) NSPoint mouseLocation;
@end

@implementation AppDelegate

@synthesize updateTimer;
@synthesize updateMouseLocation;
@synthesize mouseLocation;

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    NSRect newFrame = self.window.frame;
    newFrame.size.height = 275;
    [_window setFrame:newFrame display:YES animate:NO];
    
    self.ui_retinaReduceDropView.tipLabel = self.ui_retinaReducerTip;
    self.ui_retinaReduceDropView.settingRetinaPngQuality = self.ui_settingRetinaReducerQuality;
    
    self.ui_retinaReducerRevealInFinder.state =
        ([[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeyRetinaRevealInFinder] ? 0: 1) ; // Defualt checked.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeySettingRetianReducerQual]){
        NSInteger quality = [[[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeySettingRetianReducerQual] integerValue];
        [self.ui_settingRetinaReducerQuality selectItemAtIndex:quality];
    }
 
    // ColorPicker
    [self startGetMouseLocation];
    self.ui_colorPickerImageView.imageScaling = NSScaleProportionally;
    
    // GetCurrentWIndowId
    NSArray *windowList = (__bridge NSArray *)CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    for (NSDictionary *info in windowList) {
        if ([[info objectForKey:(NSString *)kCGWindowOwnerName] isEqualToString:@"iHateHex"] && ![[info objectForKey:(NSString *)kCGWindowName] isEqualToString:@""]) {
            NSInteger exId = [[info objectForKey:(NSString *)kCGWindowNumber] integerValue];
            windowID = (uint32) exId;
        }
    }
    
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    [self.window makeKeyAndOrderFront:self];
    return NO;
}


#pragma mark - Functions




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
        newColor = [ColorConverter colorWithHexColorString:textField.stringValue];
        textField.stringValue = [textField.stringValue stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    else if (textField == self.ui_hexNSColorField)
        newColor = [ColorConverter colorWithNSColorCodeString:self.ui_hexNSColorField.stringValue];
    else if (textField == self.ui_hexUIColorField)
        newColor = [ColorConverter colorWithUIColorCodeString:self.ui_hexUIColorField.stringValue];
    
    // Apply New Color to controls
    self.ui_hexColPicker.color = newColor;
    if (textField != self.ui_hexHexField)
        self.ui_hexHexField.stringValue = [ColorConverter stringHexcodeWithNSColor:newColor];
    if (textField != self.ui_hexNSColorField)
        self.ui_hexNSColorField.stringValue = [ColorConverter stringNSColorcodeWithNSColor:newColor];
    if (textField != self.ui_hexUIColorField)
        self.ui_hexUIColorField.stringValue = [ColorConverter stringUIColorCodeWithNSColor:newColor];
    
}


#pragma mark - Events
- (IBAction)clickedReducerRevealInFinder:(id)sender {
    
    NSButton *checkButton = (NSButton*) sender;
    self.ui_retinaReduceDropView.afterRevealInFinder = checkButton.state;
    
    if (checkButton.state == 0)
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:DefaultUserKeyRetinaRevealInFinder];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultUserKeyRetinaRevealInFinder];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)clickedSettingQualityPng:(id)sender {
    
    NSInteger idx = self.ui_settingRetinaReducerQuality.selectedTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",idx] forKey:DefaultUserKeySettingRetianReducerQual];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (IBAction)changedSegments:(id)sender {
    
    // Change Tab
    NSSegmentedControl *segmentedCtr = (NSSegmentedControl*)sender;
    [self.tabView selectTabViewItemAtIndex:segmentedCtr.selectedSegment];
    
    CGFloat height = 200;
    switch (segmentedCtr.selectedSegment) {
        case 0:
            height = 275;
            break;
        case 1:
            height = 320;
            break;
            
        default:
            break;
    }
    
    NSRect newFrame = self.window.frame;
    newFrame.size.height = height;
    [_window setFrame:newFrame display:YES animate:YES];
    
//
//    NSRect newFrame = self.window.frame;
//    NSView *selectedTabView = (NSView*) [self.tabView tabViewItemAtIndex:segmentedCtr.selectedSegment].view;
//    
//    // Calculating Max y
//    CGFloat subViewMaxYH = 0;
//    for (NSView *subView in selectedTabView.subviews) {
//        
//        CGFloat currentSubViewYH = subView.frame.origin.y + subView.frame.size.height;
//        if (currentSubViewYH > subViewMaxYH)
//            subViewMaxYH = currentSubViewYH;
//        
//        NSLog(@"subViewMaxY :%f",subViewMaxYH);
//        
//    }
//    
//    newFrame.size.height = self.tabView.frame.origin.y + subViewMaxYH;
//    [_window setFrame:newFrame display:YES animate:YES];
    
}


- (IBAction)changedHexColorPicker:(id)sender {
    
    // Find New Color
    NSColor *newColor = self.ui_hexColPicker.color;
    
    // Apply New Color to controls
    self.ui_hexHexField.stringValue     = [ColorConverter stringHexcodeWithNSColor:newColor];
    self.ui_hexNSColorField.stringValue = [ColorConverter stringNSColorcodeWithNSColor:newColor];
    self.ui_hexUIColorField.stringValue = [ColorConverter stringUIColorCodeWithNSColor:newColor];
    
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

#pragma mark - ColorPicker
- (void)startCaptureScreen
{
    // Start mouse capturing
    [self startGetMouseLocation];
    [self.colorPickerCursorView setLevel: NSPopUpMenuWindowLevel];
    
    // HideMouseCursor
    [NSCursor hide];
}

#pragma mark - MouseLocation
- (void)startGetMouseLocation
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(geMouseLocationTick) userInfo:nil repeats:YES];
}

- (void)stopGetMouseLocation
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)geMouseLocationTick
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        mouseLocation = [NSEvent mouseLocation];
        NSScreen *principalScreen = [[NSScreen screens] objectAtIndex:0];
        mouseLocation = NSMakePoint(mouseLocation.x, principalScreen.frame.size.height - mouseLocation.y);
        NSImage *iamage = [ColorPicker imageAtLocation:mouseLocation excludeWindowId:windowID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            
            self.ui_colorPickerImageView.image = iamage;
            self.ui_colorPickerImageView.image.size = CGSizeMake(500, 500);
            
            //    CGRect cursorViewNewFrame = self.colorPickerCursorView.frame;
            //    cursorViewNewFrame.origin.x = mouseLocation.x;
            //    cursorViewNewFrame.origin.y = mouseLocation.y;
            //    NSLog(@"%f %f - %f %f", cursorViewNewFrame.origin.x, cursorViewNewFrame.origin.y, mouseLocation.x, mouseLocation.y);
            //    [self.colorPickerCursorView setFrame:cursorViewNewFrame display:YES];
            //
            NSPoint p = [NSEvent mouseLocation];
            //
            NSRect f = [self.colorPickerCursorView frame];
            //    if (!NSPointInRect(p, f)) {
            p.x -= f.size.width / 2.0;
            p.y -= f.size.height / 2.0;
            [self.colorPickerCursorView setFrameOrigin:p];
            NSLog(@"%s Moved window to (%.1f, %1.f)", __PRETTY_FUNCTION__, p.x, p.y);
            //    }
        });
    });
    

}



@end
