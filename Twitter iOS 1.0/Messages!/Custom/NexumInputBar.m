//
//  NexumInputBar.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/17/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumInputBar.h"

@implementation NexumInputBar

- (void) initFrame:(BOOL)isPortrait {
    if (self) {
        int screenWidth;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if(isPortrait){
            screenWidth = screenRect.size.width;
        } else {
            screenWidth = screenRect.size.height;
        }
        
        self.backgroundColor = [UIColor C_eaeced];
        
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
        self.backgroundImage.image = [[UIImage imageNamed:@"back_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self addSubview:self.backgroundImage];
        
        self.inputField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, (screenWidth - 75), 35)];
        self.inputField.backgroundColor = [UIColor clearColor];
        [self.inputField setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:self.inputField];
        
        self.inputField.delegate = self;
    }
}

- (void) updateFrame:(BOOL)isPortrait withOrigin:(int)y andAnimation:(BOOL)animation{
    int screenWidth;
    int screenHeight;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if(isPortrait){
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
    } else {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }
    
    CGRect viewFrame = self.frame;
    CGRect backgroundFrame = self.backgroundImage.frame;
    CGRect inputFrame = self.inputField.frame;
   
    
    if(0 == y || screenWidth == y || screenHeight == y){
        viewFrame.origin.y = (screenHeight - viewFrame.size.height);
    } else {
        viewFrame.origin.y = (y - viewFrame.size.height);
    }
    
    viewFrame.size.width = screenWidth;
    backgroundFrame.size.width = screenWidth;
    inputFrame.size.width = (screenWidth - 75);
    
    
    if(animation){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationCurve:7];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    
    self.frame = viewFrame;
    self.backgroundImage.frame = backgroundFrame;
    self.inputField.frame = inputFrame;
    
    
    if(animation){
        [UIView commitAnimations];
    }
    
    self.currentWidth = screenWidth;
    [self updateTextViewHeight:self.inputField WithAnimation:animation];
}

#pragma mark - TextField actions

- (void) textViewDidChange:(UITextView *)textView {
    [self updateTextViewHeight:textView WithAnimation:YES];
}

- (void) updateTextViewHeight:(UITextView *)textView WithAnimation:(BOOL)animation {
    CGSize size = [self.inputField sizeThatFits:CGSizeMake((self.currentWidth - 75), FLT_MAX)];
    int numberOfLines = (size.height - 16)/self.inputField.font.lineHeight;
    
    if(8 < numberOfLines)
        numberOfLines = 8;
    
    int newContentHeight;
    if(1 < numberOfLines)
        newContentHeight = (numberOfLines * self.inputField.font.lineHeight) + 13;
    else
        newContentHeight = 30;
        
    
    CGRect inputFrame = self.inputField.frame;
    
    if(inputFrame.size.height != newContentHeight){
        CGRect barFrame = self.frame;
        CGRect backgroundFrame = self.backgroundImage.frame;
        
        barFrame.origin.y = barFrame.origin.y - ((newContentHeight + 10) - barFrame.size.height);
        barFrame.size.height = newContentHeight + 10;
        
        backgroundFrame.size.height = newContentHeight + 10;
        
        inputFrame.size.height = newContentHeight;
        
        if(animation){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:self.animationDuration];
            [UIView setAnimationCurve:7];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        
        self.frame = barFrame;
        self.backgroundImage.frame = backgroundFrame;
        self.inputField.frame = inputFrame;
        
        if(animation){
            [UIView commitAnimations];
        }
    }
}

@end
