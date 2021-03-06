//
//  AppDelegate.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//  https://github.com/soleaf/iHateHex/

#import "AppDelegate.h"
#import "ColorConverter.h"
#import "ColorPicker.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>

@interface AppDelegate () < NSTextFieldDelegate >

// ColorPicker
{
    uint32 windowID; // To exclude this window on screen capture
    DDHotKeyCenter *colorPickerHotkeys; // Shortcut key managing
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
    
    // Fix Window Height
    NSRect newFrame = self.window.frame;
    newFrame.size.height = 350;
    [_window setFrame:newFrame display:YES animate:NO];
    
    // Init RetinaReduceDropView
    // It Need some UI elements and Settings property
    self.ui_retinaReduceDropView.tipLabel = self.ui_retinaReducerTip;
    self.ui_retinaReduceDropView.settingRetinaPngQuality = self.ui_settingRetinaReducerQuality;
    self.ui_retinaReduceDropView.progressbar = self.ui_retinaReducerProgressbar;

    // Load Settings
    [self loadSettings];
 
    // ColorPickerImageView
    self.ui_colorPickerImageView.imageScaling = NSScaleProportionally;
    
    // ColorPickerGridView
    self.ui_colorPickerGrid.image = [NSImage imageNamed:@"pickerGrid.png"];
    
    // Hokey For ScreenColorPicker
    [self registerHotKey];
    
    // Init ScreenColorPicker
    [self stopColorPickerView];
  
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    // Click dock icon to show Window
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

- (void) loadSettings
{
    // Retina Reducer
    self.ui_retinaReducerRevealInFinder.state =
        ([[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeyRetinaRevealInFinder] ? 0: 1) ; // Defualt checked.
    self.ui_retinaReduceDropView.afterRevealInFinder = self.ui_retinaReducerRevealInFinder.state;
    
    // Setting Retina Qual.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeySettingRetianReducerQual]){
        NSInteger quality = [[[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeySettingRetianReducerQual] integerValue];
        [self.ui_settingRetinaReducerQuality selectItemAtIndex:quality];
    }
    
    // ColorPicker
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DefaultUserKeySettingColorPickerAutoCopy]){
        NSInteger autoCopyType = [[[NSUserDefaults standardUserDefaults]
                                   objectForKey:DefaultUserKeySettingColorPickerAutoCopy] integerValue];
        [self.ui_settingColorPickerAutocopy selectItemAtIndex:autoCopyType];
    }
}


#pragma mark - HotKey
- (void)registerHotKey
{
    // CTR + OPTION + CMD + C
    colorPickerHotkeys = [[DDHotKeyCenter alloc] init];
    [colorPickerHotkeys registerHotKeyWithKeyCode:kVK_ANSI_C
                                    modifierFlags:(NSCommandKeyMask | NSAlternateKeyMask | NSControlKeyMask)
                                           target:self
                                           action:@selector(hotKeyCallcolorPickerPick) object:nil];
    
}

- (void) copyToClipboardAt:(NSInteger) colorTextFieldTag
{
    
    // After Picking color through Screen Color Picker
    // Automatically Copy color code to clipboard by setted color code type.
    
    NSString *targetString = nil;
    switch (colorTextFieldTag) {
        case 2:
            targetString = self.ui_hexHexField.stringValue;
            break;
        case 1:
            targetString = self.ui_hexNSColorField.stringValue;
            break;
        case 0:
            targetString = self.ui_hexUIColorField.stringValue;
            break;
        default:
            break;
    }
    
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:targetString  forType:NSStringPboardType];
}

- (void) hotKeyCallcolorPickerPick
{
    [self startColorPickerView];
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
    
    // Option for Reveal in Finder After reducing image.
    
    NSButton *checkButton = (NSButton*) sender;
    self.ui_retinaReduceDropView.afterRevealInFinder = checkButton.state;
    
    if (checkButton.state == 0)
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:DefaultUserKeyRetinaRevealInFinder];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultUserKeyRetinaRevealInFinder];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)clickedSettingQualityPng:(id)sender {
    
    // Option for Retina reducing png quality
    
    NSInteger idx = self.ui_settingRetinaReducerQuality.selectedTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",idx] forKey:DefaultUserKeySettingRetianReducerQual];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)clickedSettingColorPiackerAutoCopy:(id)sender {
    
    // Option for Screen color picker's auto copy
    
    NSInteger idx = self.ui_settingColorPickerAutocopy.selectedTag;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",idx] forKey:DefaultUserKeySettingColorPickerAutoCopy];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)changedSegments:(id)sender {
    
    // Change Tab
    NSSegmentedControl *segmentedCtr = (NSSegmentedControl*)sender;

    [self.tabView selectTabViewItemAtIndex:segmentedCtr.selectedSegment];
    
    /*
     Bellow blocked code is resizeing window by tab content height with animation on changing tab.
     But It have somthing wrong sizing
     So, Window is fixed height.
     */

//    CGFloat height = 350;
//    switch (segmentedCtr.selectedSegment) {
//        case 0:
//            height = 350;
//            break;
//        case 1:
//            height = 320;
//            break;
//        case 2:
//            height = 370;
//            break;
//            
//        default:
//            break;
//    }
//    
//    NSRect newFrame = self.window.frame;
//    newFrame.size.height = height;
//    [self.window setFrame:newFrame display:YES animate:NO];
//    [self.window viewsNeedDisplay];
//
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
    
    // Screen Color Picker Click
    // Copy!
    NSButton *button = (NSButton*)sender;
    [self copyToClipboardAt:button.tag];

}

- (IBAction)clickedFeedBack:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/soleaf/iHateHex"]];
    
}

- (IBAction)clickedHomepage:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.mintcode.org"]];
    
}

- (IBAction)clickedColorCodeTextField:(id)sender
{
    NSTextField *textField = sender;
    [textField selectText:textField.stringValue];
    
}


#pragma mark - ColorConvert


#pragma mark - ColorPicker

- (void) getMyWindowID
{
    /*
     Get Current Window ID
     It need to capturing screenshot image without this window
     */
    
    NSArray *windowList = (__bridge NSArray *)CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    for (NSDictionary *info in windowList) {
        
        if ([[info objectForKey:(NSString *)kCGWindowOwnerName] isEqualToString:self.window.title]
            && [[info objectForKey:(NSString *)kCGWindowName] isEqualToString:self.colorPickerCursorView.title]) {
            
            NSInteger exId = [[info objectForKey:(NSString *)kCGWindowNumber] integerValue];
            windowID = (uint32) exId;

        }
        
    }
    
    
}

- (void)startColorPickerView
{
    
    // Register ESC hot key to Cancel picker
    [colorPickerHotkeys registerHotKeyWithKeyCode:kVK_Escape
                                        modifierFlags:0
                                               target:self
                                                action:@selector(stopColorPickerView) object:nil];
    
    // Show
    self.colorPickerCursorView.alphaValue = .0;
    [self.colorPickerCursorView makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];

    [self getMyWindowID];
    
    // Start mouse capturing
    [self startGetMouseLocation];
    [self.colorPickerCursorView setLevel: NSPopUpMenuWindowLevel];
    
    // HideMouseCursor
    [NSCursor hide];
    CGDisplayHideCursor(kCGDirectMainDisplay);
    
}

- (void)stopColorPickerView
{
    [colorPickerHotkeys unregisterHotKeysWithTarget:self action:@selector(stopColorPickerView)];
    
    [self stopGetMouseLocation];
    [self.colorPickerCursorView orderOut:self];
    
    CGDisplayShowCursor(kCGDirectMainDisplay);
    [NSCursor unhide];
}

- (IBAction)clickedColorPickerView:(id)sender {
    
    self.ui_hexColPicker.color = [ColorPicker colorAtLocation:mouseLocation excludeWindowId:windowID];
    [self changedHexColorPicker:self.ui_hexColPicker];
    
    [self stopColorPickerView];
    
    // Copy to clipboard
    NSInteger copyType = self.ui_settingColorPickerAutocopy.selectedTag;
    [self copyToClipboardAt:copyType];
    
}

- (IBAction)clikedStartColorPickerView:(id)sender {
    
    [self startColorPickerView];
    
}

- (IBAction)clickedCancelColorPickerView:(id)sender {
    
    [self stopColorPickerView];
    
}

#pragma mark - MouseLocation
- (void)startGetMouseLocation
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f
                                                        target:self
                                                      selector:@selector(geMouseLocationTick)
                                                      userInfo:nil
                                                       repeats:YES];
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
        NSImage *image = [ColorPicker imageAtLocation:mouseLocation excludeWindowId:windowID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.colorPickerCursorView.alphaValue = 1.;
            self.ui_colorPickerImageView.image = image;
            self.ui_colorPickerImageView.image.size = CGSizeMake(500, 500);
            
            // Move Window
            NSPoint p = [NSEvent mouseLocation];
            NSRect f = [self.colorPickerCursorView frame];
            p.x -= f.size.width / 2.0;
            p.y -= f.size.height / 2.0;
            [self.colorPickerCursorView setFrameOrigin:p];

            // Sampling Color
            [self.ui_colorPickerSampleView setBackground:
             [ColorPicker colorAtLocation:mouseLocation excludeWindowId:windowID]];
        });
    });
    

}


@end
