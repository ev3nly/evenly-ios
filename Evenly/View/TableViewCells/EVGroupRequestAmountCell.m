//
//  EVGroupRequestAmountCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/19/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestAmountCell.h"

#define DELETE_BUTTON_X_ORIGIN 10
#define OPTION_NAME_FIELD_X_ORIGIN 35
#define OPTION_NAME_FIELD_WIDTH 180

#define OPTION_AMOUNT_FIELD_X_ORIGIN 40
#define OPTION_AMOUNT_FIELD_WIDTH 90

#define OPTION_AMOUNT_FIELD_RIGHT_MARGIN 5
#define OPTION_FIELD_HEIGHT 25

#define FRIENDS_BUTTON_X_MARGIN 135
#define FRIENDS_BUTTON_WIDTH 130
#define FRIENDS_BUTTON_HEIGHT 35

@implementation EVGroupRequestAmountCell

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
        
        UIView *bottomStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        self.frame.size.height - 1,
                                                                        self.frame.size.width,
                                                                        1)];
        [bottomStripe setBackgroundColor:[EVColor newsfeedStripeColor]];
        [bottomStripe setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:bottomStripe];
    }
    return self;
}

- (void)loadDeleteButton {
    UIImage *deleteImage = [UIImage imageNamed:@"xbutton"];
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(DELETE_BUTTON_X_ORIGIN,
                                                                   (self.contentView.frame.size.height - deleteImage.size.height) / 2.0,
                                                                   deleteImage.size.width,
                                                                   deleteImage.size.height)];
    self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
}

- (void)loadOptionAmountField {
    self.optionAmountField = [[EVTextField alloc] initWithFrame:CGRectMake(OPTION_AMOUNT_FIELD_X_ORIGIN,
                                                                           (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                                           OPTION_AMOUNT_FIELD_WIDTH,
                                                                           OPTION_FIELD_HEIGHT)];
    self.optionAmountField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
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
                                                                        (self.contentView.frame.size.height - FRIENDS_BUTTON_HEIGHT) / 2.0,
                                                                        FRIENDS_BUTTON_WIDTH,
                                                                        FRIENDS_BUTTON_HEIGHT)];
    self.friendsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.friendsButton.titleLabel setFont:[EVFont blackFontOfSize:12]];
    [self.friendsButton setTitle:@"SELECT FRIENDS" forState:UIControlStateNormal];
    [self.contentView addSubview:self.friendsButton];
}

- (void)loadArrowButton {
    self.arrowButton = [[EVExpansionArrowButton alloc] initWithFrame:CGRectZero];
    self.accessoryView = self.arrowButton;
}

- (void)loadOptionNameField {
//    self.optionNameField = [[EVTextField alloc] initWithFrame:CGRectMake(OPTION_NAME_FIELD_X_ORIGIN,
//                                                                           (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
//                                                                           OPTION_NAME_FIELD_WIDTH,
//                                                                           OPTION_FIELD_HEIGHT)];
//    self.optionNameField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//    self.optionNameField.font = [EVFont defaultFontOfSize:24];
//    self.optionNameField.placeholder = @"Add a title...";
//    self.optionNameField.delegate = self;
//    [self addSubview:self.optionNameField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    return [self.optionNameField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    BOOL didResign = [self.optionNameField resignFirstResponder];
    didResign |= [self.optionAmountField resignFirstResponder];
    return didResign;
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
