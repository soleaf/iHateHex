//
//  main.m
//  iHateHex
//
//  Created by soleaf on 14. 1. 10..
//  Copyright (c) 2014년 soleaf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#include <ApplicationServices/ApplicationServices.h>

int main(int argc, const char * argv[])
{
    
//    void CGSSetConnectionProperty(int, int, CFStringRef, CFBooleanRef);
//    int _CGSDefaultConnection();
//    CFStringRef propertyString;
//    
//    // Hack to make background cursor setting work
//    propertyString = CFStringCreateWithCString(NULL, "SetsCursorInBackground", kCFStringEncodingUTF8);
//    CGSSetConnectionProperty(_CGSDefaultConnection(), _CGSDefaultConnection(), propertyString, kCFBooleanTrue);
//    CFRelease(propertyString);
//    // Hide the cursor and wait
//    CGDisplayHideCursor(kCGDirectMainDisplay);
//    
    return NSApplicationMain(argc, argv);
}
