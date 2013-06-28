//
//  EVGroupRequestEditAmountView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestEditAmountCell.h"
#import "EVGroupRequestTier.h"

#define DELETE_BUTTON_X_ORIGIN 10
#define OPTION_NAME_FIELD_X_ORIGIN 35
#define OPTION_NAME_FIELD_WIDTH 180

#define OPTION_AMOUNT_FIELD_WIDTH 60
#define OPTION_AMOUNT_FIELD_RIGHT_MARGIN 10
#define OPTION_FIELD_HEIGHT 20

#define FONT_SIZE 14

NSString *const EVGroupRequestEditAmountCellBeganEditing = @"EVGroupRequestEditAmountCellBeganEditing";

@implementation EVGroupRequestEditAmountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.currencyFormatter = [[EVCurrencyTextFieldFormatter alloc] init];
        [self loadDeleteButton];
        [self loadOptionNameField];
        [self loadOptionAmountField];
        self.editable = YES;
    }
    return self;
}

- (void)setTier:(EVGroupRequestTier *)tier {
    _tier = tier;
    self.optionNameField.text = tier.name;
    self.optionAmountField.text = [EVStringUtility amountStringForAmount:tier.price];
}

- (void)loadDeleteButton {
    UIImage *deleteImage = [UIImage imageNamed:@"Request-Multi-Remove"];
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(DELETE_BUTTON_X_ORIGIN,
                                                                   (self.contentView.frame.size.height - deleteImage.size.height) / 2.0,
                                                                   deleteImage.size.width,
                                                                   deleteImage.size.height)];
    self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
}

- (void)loadOptionNameField {
    self.optionNameField = [[EVTextField alloc] initWithFrame:CGRectMake(OPTION_NAME_FIELD_X_ORIGIN,
                                                                         (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                                         OPTION_NAME_FIELD_WIDTH,
                                                                         OPTION_FIELD_HEIGHT)];
    self.optionNameField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.optionNameField.font = [EVFont defaultFontOfSize:FONT_SIZE];
    self.optionNameField.placeholder = @"Option";
    self.optionNameField.delegate = self;
    [self.contentView addSubview:self.optionNameField];
}

- (void)loadOptionAmountField {
    self.optionAmountField = [[EVTextField alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - OPTION_AMOUNT_FIELD_WIDTH - OPTION_AMOUNT_FIELD_RIGHT_MARGIN),
                                                                           (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                                           OPTION_AMOUNT_FIELD_WIDTH,
                                                                           OPTION_FIELD_HEIGHT)];
    self.optionAmountField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.optionAmountField.textAlignment = NSTextAlignmentRight;
    self.optionAmountField.placeholder = @"$0.00";
    self.optionAmountField.delegate = self;
    self.optionAmountField.keyboardType = UIKeyboardTypeNumberPad;
    self.optionAmountField.font = [EVFont defaultFontOfSize:FONT_SIZE];
    self.optionNameField.next = self.optionAmountField;
    [self.contentView addSubview:self.optionAmountField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    EV_DISPATCH_AFTER(0.2, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EVGroupRequestEditAmountCellBeganEditing object:self];
    });    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.handleTextChange)
        self.handleTextChange((EVTextField *)textField);
    return YES;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.editable) {
        [self.deleteButton removeFromSuperview];
        self.optionNameField.textColor = [EVColor lightLabelColor];
        self.optionAmountField.textColor = [EVColor lightLabelColor];
        self.optionNameField.frame = CGRectMake(DELETE_BUTTON_X_ORIGIN,
                                                (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                OPTION_NAME_FIELD_WIDTH,
                                                OPTION_FIELD_HEIGHT + self.deleteButton.frame.size.width);
    } else {
        self.optionNameField.textColor = [UIColor blackColor];
        self.optionAmountField.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.deleteButton];
        UIImage *deleteImage = [self.deleteButton imageForState:UIControlStateNormal];
        self.deleteButton.frame = CGRectMake(DELETE_BUTTON_X_ORIGIN,
                                             (self.contentView.frame.size.height - deleteImage.size.height) / 2.0,
                                             deleteImage.size.width,
                                             deleteImage.size.height);
        self.optionNameField.frame = CGRectMake(OPTION_NAME_FIELD_X_ORIGIN,
                                                (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                                OPTION_NAME_FIELD_WIDTH,
                                                OPTION_FIELD_HEIGHT);
        
    }
    self.optionAmountField.frame = CGRectMake(self.contentView.frame.size.width - OPTION_AMOUNT_FIELD_WIDTH - OPTION_AMOUNT_FIELD_RIGHT_MARGIN,
                                              (self.contentView.frame.size.height - OPTION_FIELD_HEIGHT) / 2.0,
                                              OPTION_AMOUNT_FIELD_WIDTH,
                                              OPTION_FIELD_HEIGHT);
    self.optionNameField.enabled = self.editable;
    self.optionAmountField.enabled = self.editable;
}

@end

@implementation EVGroupRequestEditAddOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.position = EVGroupedTableViewCellPositionBottom;
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        label.font = [EVFont defaultFontOfSize:FONT_SIZE];
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
