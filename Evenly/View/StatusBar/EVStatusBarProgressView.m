//
//  EVStatusBarProgressView.m
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVStatusBarProgressView.h"

#define IN_PROGRESS_BACKGROUND_CYCLE_LENGTH 4.0
#define IN_PROGRESS_SPINNER_CYCLE_LENGTH 1.0
#define SPINNER_LABEL_BUFFER 6
#define PROGRESS_LABEL_FONT [EVFont romanFontOfSize:10]
#define CONCLUSION_LABEL_Y_OFFSET 1

@interface EVStatusBarProgressView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *coloredBackgroundImageView;
@property (nonatomic, strong) UIImageView *spinnerView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *conclusionLabel;

@property (nonatomic, strong) NSArray *inProgressViews;

@end

@implementation EVStatusBarProgressView

@synthesize status = _status;

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadBackgroundView];
        [self loadColoredBackgroundImageView];
        [self loadInProgressViews];
        [self loadSpinnerView];
        [self loadProgressLabel];
        [self loadConclusionLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = [self backgroundViewFrame];
    self.coloredBackgroundImageView.frame = [self backgroundViewFrame];
    self.spinnerView.frame = [self spinnerViewFrame];
    self.progressLabel.frame = [self progressLabelFrame];
    self.conclusionLabel.frame = [self conclusionLabelFrame];
}

#pragma mark - View Loading

- (void)loadBackgroundView {
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = [UIColor blackColor];
}

- (void)loadColoredBackgroundImageView {
    UIImage *backgroundImage = [EVImages statusSuccessBackground];
    self.coloredBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.coloredBackgroundImageView.alpha = 0.85;
    [self.backgroundView addSubview:self.coloredBackgroundImageView];
}

- (void)loadInProgressViews {
    UIImageView *imageOne = [[UIImageView alloc] initWithImage:[EVImages statusProgressBackground]];
    UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[EVImages statusProgressBackground]];
    self.inProgressViews = @[imageOne, imageTwo];
}

- (void)loadSpinnerView {
    self.spinnerView = [[UIImageView alloc] initWithImage:[EVImages statusProgressSpinner]];
    [self addSubview:self.spinnerView];
}

- (void)loadProgressLabel {
    self.progressLabel = [UILabel new];
    self.progressLabel.backgroundColor = [UIColor clearColor];
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.font = PROGRESS_LABEL_FONT;
    [self addSubview:self.progressLabel];
}

- (void)loadConclusionLabel {
    self.conclusionLabel = [UILabel new];
    self.conclusionLabel.backgroundColor = [UIColor clearColor];
    self.conclusionLabel.textColor = [UIColor whiteColor];
    self.conclusionLabel.font = PROGRESS_LABEL_FONT;
    [self addSubview:self.conclusionLabel];
}

#pragma mark - Setters and Getters

#define CONCLUSION_BG_TAG 3902

- (void)setStatus:(EVStatusBarStatus)status text:(NSString *)text {
    _status = status;
    
    if (status == EVStatusBarStatusInProgress) {
        self.progressLabel.text = text;
        [self setViewsForInProgress];
    } else {
        self.conclusionLabel.text = text;
        UIImage *backgroundImage = (status == EVStatusBarStatusSuccess) ? [EVImages statusSuccessBackground] : [EVImages statusErrorBackground];
        self.coloredBackgroundImageView.image = backgroundImage;
        [self setViewsForConclusion];
    }
}

- (void)setViewsForInProgress {
    [self removeAllSubviews];
    [self addSubview:[self.inProgressViews objectAtIndex:0]];
    [self addSubview:[self.inProgressViews objectAtIndex:1]];
    [self cycleInProgressViews];
    [self addSubview:self.spinnerView];
    [self spinSpinner];
    [self addSubview:self.progressLabel];
}

- (void)setViewsForConclusion {
    [self addSubview:self.backgroundView];
    [self bringSubviewToFront:self.progressLabel];
    [self addSubview:self.conclusionLabel];
    
    self.backgroundView.alpha = 0;
    self.conclusionLabel.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 1;
                         self.conclusionLabel.alpha = 1;
                         self.progressLabel.alpha = 0;
                         self.spinnerView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.progressLabel removeFromSuperview];
                         self.progressLabel.alpha = 1;
                         [self.spinnerView removeFromSuperview];
                         self.spinnerView.alpha = 1;
                     }];
}

#pragma mark - Animations

- (void)cycleInProgressViews {
    if (self.status != EVStatusBarStatusInProgress)
        return;
    
    UIView *leftView = [self.inProgressViews objectAtIndex:0];
    UIView *rightView = [self.inProgressViews objectAtIndex:1];
    
    CGRect viewFrame = self.bounds;
    rightView.frame = viewFrame;
    viewFrame.origin.x -= viewFrame.size.width;
    leftView.frame = viewFrame;
    viewFrame.origin.x += (2 * viewFrame.size.width);
    
    self.inProgressViews = @[rightView, leftView];
    
    [UIView animateWithDuration:IN_PROGRESS_BACKGROUND_CYCLE_LENGTH
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         leftView.frame = rightView.frame;
                         rightView.frame = viewFrame;
                     } completion:^(BOOL finished) {
                         EV_PERFORM_ON_MAIN_QUEUE(^ (void) {
                             [self cycleInProgressViews];
                         });
                     }];
}

- (void)spinSpinner {
    if (self.status != EVStatusBarStatusInProgress)
        return;
    
    self.spinnerView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:IN_PROGRESS_SPINNER_CYCLE_LENGTH
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.spinnerView.transform = CGAffineTransformMakeRotation(-M_PI);
                     } completion:^(BOOL finished) {
                         [self spinSpinner];
                     }];
}

#pragma mark - Frames

- (CGRect)backgroundViewFrame {
    CGRect backgroundFrame = self.bounds;
    backgroundFrame.size.height += 10;
    return backgroundFrame;
}

- (CGRect)spinnerViewFrame {
    CGSize imageSize = self.spinnerView.image.size;
    return CGRectMake(CGRectGetMidX(self.bounds) - [self spinnerAndLabelWidth]/2,
                      CGRectGetMidY(self.bounds) - imageSize.height/2,
                      imageSize.width,
                      imageSize.height);
}

- (CGRect)progressLabelFrame {
    float textWidth = [self sizeForLabel:self.progressLabel].width;
    return CGRectMake(CGRectGetMaxX(self.spinnerView.frame) + SPINNER_LABEL_BUFFER,
                      0,
                      textWidth,
                      self.bounds.size.height);
}

- (CGRect)conclusionLabelFrame {
    float textWidth = [self sizeForLabel:self.conclusionLabel].width;
    return CGRectMake(CGRectGetMidX(self.bounds) - textWidth/2,
                      CONCLUSION_LABEL_Y_OFFSET,
                      textWidth,
                      self.bounds.size.height);
}

- (float)spinnerAndLabelWidth {
    float textWidth = [self sizeForLabel:self.progressLabel].width;
    return (self.spinnerView.image.size.width + SPINNER_LABEL_BUFFER + textWidth);
}

- (CGSize)sizeForLabel:(UILabel *)label {
    return [label.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: label.font}
                                    context:NULL].size;
}

@end
