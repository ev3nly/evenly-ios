//
//  EVPlaceholderTextView.h
//  Evenly
//
//  Created by Jason George on StackOverflow.
//  http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
//  Adapted as necessary by Joseph Hankin.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVPlaceholderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
