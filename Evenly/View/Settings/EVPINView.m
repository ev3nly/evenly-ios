//
//  EVPINView.m
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVPINView.h"
#import <QuartzCore/QuartzCore.h>

#define PASSCODE_LENGTH 4
#define SQUARE_SIDE_BUFFER 20
#define SQUARE_SQUARE_BUFFER 10
#define BLACK_DOT_RADIUS 20
#define BLACK_DOT_TAG 9282

@interface EVPINView ()

@property (nonatomic, strong) NSMutableArray *squares;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation EVPINView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSquares];
        [self loadTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *square in self.squares) {
        square.frame = [self squareFrameForIndex:[self.squares indexOfObject:square]];
        [square align];
    }
}

#pragma mark - View Loading

- (void)loadSquares {
    self.squares = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < PASSCODE_LENGTH; i++) {
        UIView *square = [UIView new];
        square.backgroundColor = [UIColor whiteColor];
        square.layer.cornerRadius = 2.0;
        square.layer.borderColor = [EV_RGB_COLOR(220, 220, 220) CGColor];
        square.layer.borderWidth = 1.0;
        [self addSubview:square];
        [self.squares addObject:square];
    }
}

- (void)loadTextField {
    self.textField = [UITextField new];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    [self addSubview:self.textField];
    [self.textField becomeFirstResponder];
}

#pragma mark - Dots

- (void)addDotToView:(UIView *)view {
    if ([view viewWithTag:BLACK_DOT_TAG])
        return;
    UIView *blackDot = [self blackDot];
    blackDot.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    [blackDot align];
    [view addSubview:blackDot];
}

- (void)removeDotFromView:(UIView *)view {
    [view removeAllSubviews];
}

- (UIView *)blackDot {
    UIView *blackDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLACK_DOT_RADIUS, BLACK_DOT_RADIUS)];
    blackDot.backgroundColor = [EVColor darkColor];
    blackDot.layer.cornerRadius = blackDot.bounds.size.height/2;
    blackDot.tag = BLACK_DOT_TAG;
    return blackDot;
}

- (void)reset {
    self.textField.text = nil;
    for (UIView *square in self.squares)
        [self removeDotFromView:square];
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > PASSCODE_LENGTH)
        return NO;
    
    for (int i = 0; i < PASSCODE_LENGTH; i++) {
        UIView *square = self.squares[i];
        if (i < newString.length)
            [self addDotToView:square];
        else
            [self removeDotFromView:square];
    }
    
    if (newString.length == PASSCODE_LENGTH) {
        if (self.handleNewPin)
            self.handleNewPin(newString);
        return NO;
    }
    return YES;
}

#pragma mark - Frames

- (CGRect)squareFrameForIndex:(int)index {
    float totalSquareSpace = self.bounds.size.width - (SQUARE_SIDE_BUFFER*2 + SQUARE_SQUARE_BUFFER*3);
    int singleSquareWidth = totalSquareSpace/4;
    return CGRectMake(SQUARE_SIDE_BUFFER + (singleSquareWidth + SQUARE_SQUARE_BUFFER)*index,
                      0,
                      singleSquareWidth,
                      self.bounds.size.height);
}

@end
