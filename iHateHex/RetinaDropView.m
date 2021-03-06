//
//  RetinaDropView.m
//  iHateHex
//
//  Created by soleaf on 1/11/14.
//  Copyright (c) 2014 soleaf. All rights reserved.
//

#import "RetinaDropView.h"
#import "RetinaReducer.h"

@interface RetinaDropView()
{
    BOOL isHighlighted;
}
@property (assign, setter=setHighlighted:) BOOL isHighlighted;

@end

@implementation RetinaDropView
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                       NSColorPboardType, NSFilenamesPboardType, nil]];

        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0; // Why not working??
        
    }
    return self;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    [self setHighlighted:YES];
    return NSDragOperationEvery;
}

-(NSDragOperation) draggingUpdated:(id<NSDraggingInfo>)sender
{
    
    return NSDragOperationEvery;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
    [self setHighlighted:NO];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  {
    
    // Check fileTypes
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *draggedFilePaths = [pboard propertyListForType:NSFilenamesPboardType];
    
    BOOL isAble = YES;
    
    for (NSString *path in draggedFilePaths) {
        
        if ([path rangeOfString:@"png"].location == NSNotFound){
            isAble = NO;
            self.tipLabel.stringValue = @"Only .png files";

            break;
        }
    }
    
    return isAble;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    
    self.tipLabel.stringValue = @"Reduce!";
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *draggedFilePaths = [pboard propertyListForType:NSFilenamesPboardType];
    
    NSImageInterpolation pngQuality = NSImageInterpolationHigh;
    NSInteger settedQuality = self.settingRetinaPngQuality.selectedTag;
    
    switch (settedQuality) {
        case 0:
            pngQuality = NSImageInterpolationHigh;
            break;
        case 1:
            pngQuality = NSImageInterpolationMedium;
            break;
        case 2:
            pngQuality = NSImageInterpolationLow;
            break;
        default:
            break;
    }
    
    [self.progressbar startAnimation:self];
    [self setHighlighted:NO];
    
    RetinaReducer *retinaReducer = [[RetinaReducer alloc] init];
    retinaReducer.pngQuality = settedQuality;
    [retinaReducer reduceFiles:draggedFilePaths andAfeterRevelInFinder:self.afterRevealInFinder complete:^{
        
        [self.progressbar stopAnimation:self];
        
    }];
    
    return YES;
}

- (BOOL)isHighlighted {
    return isHighlighted;
}

- (void)setHighlighted:(BOOL)value {
    isHighlighted = value;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)frame {
    [super drawRect:frame];
    if (isHighlighted) {
        [[NSColor keyboardFocusIndicatorColor] setFill];
        NSRectFill(frame);
        [super drawRect:frame];
    }
    else{
        [[NSColor colorWithCalibratedWhite:0.102 alpha:1.000] setFill];
        NSRectFill(frame);
        [super drawRect:frame];
        
        self.tipLabel.stringValue = @"Drop Retina image files";
    }

}
@end
