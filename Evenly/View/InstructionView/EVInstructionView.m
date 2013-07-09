//
//  EVInstructionView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVInstructionView.h"
#import "EVKeyboardTracker.h"
#import <QuartzCore/QuartzCore.h>

#define WHOLE_WIDTH 320
#define BACKGROUND_MARGIN 10
#define INTERNAL_MARGIN 8.0 
#define CORNER_RADIUS 4.0

@interface EVInstructionViewBackground : UIView

@end

@implementation EVInstructionViewBackground

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS] CGPath];
    layer.fillColor = [EV_RGB_ALPHA_COLOR(36, 45, 50, 0.9) CGColor];
    layer.strokeColor = [[UIColor blackColor] CGColor];
    layer.lineWidth = 2.0;
}

@end

@interface EVInstructionView ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *xButton;
@property (nonatomic) NSTimeInterval flashDuration;

- (void)loadBackground;
- (void)loadLabel;
- (void)loadLogo;
- (void)loadXButton;

@end

@implementation EVInstructionView

#pragma mark - Public Interface

- (id)initWithText:(NSString *)text {
    self = [self initWithFrame:CGRectMake(0, 0, WHOLE_WIDTH, 0)];
    if (self) {
        self.text = text;
        [self sizeToFit];
        [self setNeedsLayout];
    }
    return self;
}

- (id)initWithAttributedText:(NSAttributedString *)attributedText {
    self = [self initWithFrame:CGRectMake(0, 0, WHOLE_WIDTH, 0)];
    if (self) {
        self.attributedText = attributedText;
        [self sizeToFit];
        [self setNeedsLayout];
    }
    return self;
}

- (void)setShowingLogo:(BOOL)showingLogo {
    _showingLogo = showingLogo;
    [self sizeToFit];
    [self setNeedsLayout];
}

- (void)showInView:(UIView *)view {
    [self flashInView:view forDuration:0.0];
}

- (void)flashInView:(UIView *)view forDuration:(NSTimeInterval)duration {
    self.flashDuration = duration;
    CGRect viewFrame = view.frame;
    if ([[EVKeyboardTracker sharedTracker] keyboardIsShowing])
        viewFrame.size.height -= [[EVKeyboardTracker sharedTracker] keyboardFrame].size.height;
    self.center = CGPointMake(viewFrame.size.width / 2.0, viewFrame.size.height / 2.0);
    self.alpha = 0.0f;
    [view addSubview:self];
    [self setNeedsLayout];
    
    void (^animations)(void) = ^{
        self.alpha = 1.0f;
    };
    
    void (^completion)(BOOL finished) = NULL;
    if (duration > 0.0)
    {
        completion = ^(BOOL finished) {
                EV_DISPATCH_AFTER(duration, ^{
                    EV_PERFORM_ON_MAIN_QUEUE(^{
                        [self dismiss];
                    });
                });
            };
    }
    
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                     animations:animations
                     completion:completion];
}

#pragma mark - Private Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBackground];
        [self loadLabel];
        [self loadLogo];
        [self loadXButton];
    }
    return self;
}

- (void)loadBackground {
    CGRect backgroundFrame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(BACKGROUND_MARGIN,
                                                                                 BACKGROUND_MARGIN,
                                                                                 BACKGROUND_MARGIN,
                                                                                 BACKGROUND_MARGIN));
    self.backgroundView = [[EVInstructionViewBackground alloc] initWithFrame:backgroundFrame];
    [self addSubview:self.backgroundView];
}

- (void)loadLabel {
    CGRect labelFrame = UIEdgeInsetsInsetRect(self.backgroundView.frame, UIEdgeInsetsMake(INTERNAL_MARGIN,
                                                                                          INTERNAL_MARGIN,
                                                                                          INTERNAL_MARGIN,
                                                                                          INTERNAL_MARGIN));
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [EVFont defaultFontOfSize:15];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 0;
    [self addSubview:self.label];
}

- (void)loadLogo {
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_logo"]];
}

- (void)loadXButton {
    UIImage *image = [UIImage imageNamed:@"x_button.png"];
    self.xButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [self.xButton setImage:image forState:UIControlStateNormal];
    [self.xButton addTarget:self action:@selector(xButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = CGSizeZero;
    CGSize sizeConstraint = CGSizeMake(self.frame.size.width - 2*BACKGROUND_MARGIN - 2*INTERNAL_MARGIN, FLT_MAX);
    if (self.attributedText)
    {
        CGRect boundingRect = [self.attributedText boundingRectWithSize:sizeConstraint                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                                context:nil];
        textSize = boundingRect.size;
    }
    else if (self.text)
    {
        textSize = [self.text sizeWithFont:self.label.font
                         constrainedToSize:sizeConstraint
                             lineBreakMode:self.label.lineBreakMode];
    }
    
    // Add y-margins
    textSize.height += 2*BACKGROUND_MARGIN + 2*INTERNAL_MARGIN;
    
    if (self.showingLogo) {
        textSize.height += self.logoView.frame.size.height + INTERNAL_MARGIN;
    }
    
    textSize.width = WHOLE_WIDTH;
    return textSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(BACKGROUND_MARGIN,
                                                                                    BACKGROUND_MARGIN,
                                                                                    BACKGROUND_MARGIN,
                                                                                    BACKGROUND_MARGIN));
    
    [self.label setAttributedText:self.attributedText];
    if (!EV_IS_EMPTY_STRING(self.text))
        [self.label setText:self.text];
    
    if (self.showingLogo) {
        CGRect logoFrame = self.logoView.frame;
        logoFrame.origin.x = (self.frame.size.width - self.logoView.frame.size.width) / 2.0;
        logoFrame.origin.y = BACKGROUND_MARGIN + INTERNAL_MARGIN;
        self.logoView.frame = logoFrame;
        [self addSubview:self.logoView];
        CGFloat labelY = CGRectGetMaxY(self.logoView.frame) + INTERNAL_MARGIN;
        [self.label setFrame:CGRectMake(BACKGROUND_MARGIN + INTERNAL_MARGIN,
                                        labelY,
                                        self.frame.size.width - 2*BACKGROUND_MARGIN - 2*INTERNAL_MARGIN,
                                        self.frame.size.height - labelY - BACKGROUND_MARGIN - INTERNAL_MARGIN)];
    } else {
        [self.logoView removeFromSuperview];
        [self.label setFrame:CGRectMake(BACKGROUND_MARGIN + INTERNAL_MARGIN,
                                        BACKGROUND_MARGIN + INTERNAL_MARGIN,
                                        self.frame.size.width - 2*BACKGROUND_MARGIN - 2*INTERNAL_MARGIN,
                                        self.frame.size.height - 2*BACKGROUND_MARGIN - 2*INTERNAL_MARGIN)];
    }
    
    if (self.flashDuration == 0.0f) {
        self.xButton.frame = CGRectMake(self.frame.size.width - self.xButton.frame.size.width - 2.0,
                                        0,
                                        self.xButton.frame.size.width,
                                        self.xButton.frame.size.height);
        [self addSubview:self.xButton];
    } else {
        [self.xButton removeFromSuperview];
    }
}

- (void)xButtonPress:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:EV_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         self.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
@end
