//
//  EVGroupRequestAmountCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestAmountCell.h"

#define DELETE_BUTTON_X_ORIGIN 10
#define OPTION_NAME_FIELD_X_ORIGIN 15.0
#define OPTION_NAME_FIELD_WIDTH 300.0

#define OPTION_AMOUNT_FIELD_X_ORIGIN 40
#define OPTION_AMOUNT_FIELD_WIDTH 90

#define OPTION_AMOUNT_FIELD_RIGHT_MARGIN 5
#define OPTION_FIELD_HEIGHT 25

#define FRIENDS_BUTTON_X_MARGIN 145
#define FRIENDS_BUTTON_WIDTH 130
#define FRIENDS_BUTTON_HEIGHT 35

#define TAPPABLE_BUTTON_WIDTH 44

@interface EVGroupRequestAmountCell ()

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) EVExpansionArrowButton *arrowButton;
@property (nonatomic, strong) UIView *bottomStripe;

@end

@implementation EVGroupRequestAmountCell

+ (CGFloat)standardHeight {
    return 55.0;
}

+ (CGFloat)expandedHeight {
    return 95.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.currencyFormatter = [[EVCurrencyTextFieldFormatter alloc] init];
        [self loadDeleteButton];
        [self loadOptionAmountField];
        [self loadFriendsButton];
        [self loadArrowButton];
        [self loadOptionNameField];
        [self loadBottomStripe];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Keep the arrow on the first line when the cells expand.
    CGPoint center = self.accessoryView.center;
    center.y = [[self class] standardHeight] / 2.0;
    center.x = self.bounds.size.width - self.arrowButton.imageView.image.size.width;
    self.accessoryView.center = center;
    
    self.bottomStripe.frame = [self bottomStripeFrame];
}

#pragma mark - View Loading

- (void)loadDeleteButton {
    UIImage *deleteImage = [UIImage imageNamed:@"xbutton"];
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TAPPABLE_BUTTON_WIDTH, [[self class] standardHeight])];
    
    float topBottomInset = [[self class] standardHeight]/2 - deleteImage.size.height/2;
    [self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(topBottomInset, DELETE_BUTTON_X_ORIGIN, topBottomInset, TAPPABLE_BUTTON_WIDTH - deleteImage.size.width - DELETE_BUTTON_X_ORIGIN)];
    
    self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.deleteButton addTarget:self action:@selector(deleteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
}

- (void)loadOptionAmountField {
    self.optionAmountField = [[EVTextField alloc] initWithFrame:CGRectMake(OPTION_AMOUNT_FIELD_X_ORIGIN,
                                                                           ([[self class] standardHeight] - OPTION_FIELD_HEIGHT) / 2.0,
                                                                           OPTION_AMOUNT_FIELD_WIDTH,
                                                                           OPTION_FIELD_HEIGHT)];
    self.optionAmountField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    self.optionAmountField.textAlignment = NSTextAlignmentCenter;
    self.optionAmountField.placeholder = @"$0.00";
    self.optionAmountField.delegate = self;
    self.optionAmountField.keyboardType = UIKeyboardTypeNumberPad;
    self.optionAmountField.font = [EVFont defaultFontOfSize:20];
    self.optionNameField.next = self.optionAmountField;
    [self.contentView addSubview:self.optionAmountField];
}

- (void)loadFriendsButton {
    self.friendsButton = [[EVGrayButton alloc] initWithFrame:CGRectMake(FRIENDS_BUTTON_X_MARGIN,
                                                                        ([[self class] standardHeight] - FRIENDS_BUTTON_HEIGHT) / 2.0,
                                                                        FRIENDS_BUTTON_WIDTH,
                                                                        FRIENDS_BUTTON_HEIGHT)];
    self.friendsButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.friendsButton addTarget:self action:@selector(friendsButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendsButton.titleLabel setFont:[EVFont blackFontOfSize:12]];
    [self.friendsButton setTitle:@"SELECT FRIENDS" forState:UIControlStateNormal];
    [self.contentView addSubview:self.friendsButton];
}

- (void)loadArrowButton {
    self.arrowButton = [[EVExpansionArrowButton alloc] initWithFrame:CGRectZero];
    self.accessoryView = self.arrowButton;
    [self.arrowButton addTarget:self action:@selector(arrowButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadOptionNameField {
    
    self.optionNameFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              [[self class] standardHeight],
                                                                              self.frame.size.width,
                                                                              [[self class] expandedHeight] - [[self class] standardHeight])];
    self.optionNameFieldBackground.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.optionNameFieldBackground];
    
    UIView *bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.frame.size.width,
                                                                    [EVUtilities scaledDividerHeight])];
    [bottomStripe setBackgroundColor:[EVColor newsfeedStripeColor]];
    bottomStripe.alpha = 0.7;
    [self.optionNameFieldBackground addSubview:bottomStripe];
    
    self.optionNameField = [[EVTextField alloc] initWithFrame:CGRectMake(OPTION_NAME_FIELD_X_ORIGIN,
                                                                         (self.optionNameFieldBackground.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                                           OPTION_NAME_FIELD_WIDTH,
                                                                           OPTION_FIELD_HEIGHT)];
    self.optionNameField.autoresizingMask = UIViewAutoresizingNone;
    self.optionNameField.font = [EVFont defaultFontOfSize:15];
    self.optionNameField.placeholder = @"Describe this payment option.";
    self.optionNameField.delegate = self;
    [self.optionNameFieldBackground addSubview:self.optionNameField];
}

- (void)loadBottomStripe {
    self.bottomStripe = [UIView new];
    [self.bottomStripe setBackgroundColor:[EVColor newsfeedStripeColor]];
    [self addSubview:self.bottomStripe];
}

#pragma mark - View Manipulation

- (void)addTopStripe {
    UIView *topStripe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [EVUtilities scaledDividerHeight])];
    topStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:topStripe];
}

#pragma mark - Button Handling

- (void)deleteButtonPress:(id)sender {
    if (self.handleDeletePress)
        self.handleDeletePress(self);
}

- (void)friendsButtonPress:(id)sender {
    if (self.handleSelectFriendsPress)
        self.handleSelectFriendsPress(self);
}

- (void)arrowButtonPress:(id)sender {
    if (self.handleArrowPress)
        self.handleArrowPress(self);
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.optionAmountField) {
        [self.currencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        [self.optionAmountField setText:self.currencyFormatter.formattedString];
        [self.optionAmountField sendActionsForControlEvents:UIControlEventEditingChanged]; // for rac_textSignal
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(EVTextField *)textField next]) {
        [[(EVTextField *)textField next] becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - First Responder

- (BOOL)isFirstResponder {
    return (self.optionNameField.isFirstResponder || self.optionAmountField.isFirstResponder);
}

- (BOOL)becomeFirstResponder {
    if (self.isFirstResponder)
        return YES;
    return [self.optionAmountField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    BOOL didResign = [self.optionNameField resignFirstResponder];
    didResign |= [self.optionAmountField resignFirstResponder];
    return didResign;
}

#pragma mark - Frames

- (CGRect)bottomStripeFrame {
    return CGRectMake(0,
                      self.frame.size.height - [EVUtilities scaledDividerHeight],
                      self.frame.size.width,
                      [EVUtilities scaledDividerHeight]);
}

@end


@implementation EVGroupRequestAddOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        label.font = [EVFont defaultFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [EVColor darkLabelColor];
        label.text = @"+   Add Option";
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        
    }
    return self;
}

@end
