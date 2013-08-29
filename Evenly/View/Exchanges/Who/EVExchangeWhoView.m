//
//  EVExchangeWhoView.m
//  Evenly
//
//  Created by Joseph Hankin on 7/6/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhoView.h"

#define TOKEN_FIELD_ADJUSTMENT 9
#define LEFT_RIGHT_BUFFER 10
#define TO_FIELD_HEIGHT 40
#define LINE_HEIGHT 40

NSString *const EVExchangeWhoViewAddedTokenFromReturnPressNotification = @"EVExchangeWhoViewAddedTokenFromReturnPressNotification";

@implementation EVExchangeWhoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recipients = [NSMutableArray array];
        
        [self.titleLabel removeFromSuperview];
        
        [self loadToField];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTokenFieldFrameDidChange:)
                                                     name:JSTokenFieldFrameDidChangeNotification
                                                   object:nil];
        
        [self.toField becomeFirstResponder];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addContact:(EVObject<EVExchangeable> *)contact {
    if (![[self recipients] containsObject:contact])
    {
        [self.toField addTokenWithTitle:contact.name representedObject:contact];
    }
    self.toField.textField.text = nil;
}

- (void)setAutocompleteTableView:(UITableView *)autocompleteTableView {
    if (_autocompleteTableView) {
        [_autocompleteTableView removeFromSuperview];
        _autocompleteTableView = nil;
    }
    _autocompleteTableView = autocompleteTableView;
    [self addSubview:_autocompleteTableView];
    [self.autocompleteTableView setFrame:[self tableViewFrame]];
}

- (void)loadToField
{
    self.upperStripe = [[UIView alloc] initWithFrame:[self upperStripeFrame]];
    self.upperStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.upperStripe];
    
    self.toField = [[JSTokenField alloc] initWithFrame:[self toFieldFrame]];
    self.toField.textField.placeholder = [EVStringUtility toFieldPlaceholder];
    self.toField.textField.returnKeyType = UIReturnKeyNext;
    self.toField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.toField.backgroundColor = [UIColor whiteColor];
    self.toField.textField.font = [EVFont lightExchangeFormFont];
    self.toField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.toField.delegate = self;
    [self addSubview:self.toField];
    
    self.lowerStripe = [[UIView alloc] initWithFrame:[self lowerStripeFrame]];
    self.lowerStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.lowerStripe];
}

- (CGRect)upperStripeFrame {
    return CGRectMake(0,
                      0,
                      self.frame.size.width,
                      [EVUtilities scaledDividerHeight]);
}

- (CGRect)toFieldFrame {
    return CGRectMake(LEFT_RIGHT_BUFFER,
                      CGRectGetMaxY(self.upperStripe.frame) + EV_REQUEST_VIEW_LABEL_FIELD_BUFFER - TOKEN_FIELD_ADJUSTMENT,
                      self.frame.size.width - 2*LEFT_RIGHT_BUFFER,
                      TO_FIELD_HEIGHT);
}

- (CGRect)lowerStripeFrame {
    return CGRectMake(0, CGRectGetMaxY(self.toField.frame) + [EVUtilities scaledDividerHeight], self.frame.size.width, [EVUtilities scaledDividerHeight]);
}

- (CGRect)tableViewFrame {
    float tableHeight = self.frame.size.height - CGRectGetMaxY(self.toField.frame);
    CGRect tableFrame =  CGRectMake(0,
                                    CGRectGetMaxY(self.lowerStripe.frame),
                                    self.frame.size.width,
                                    tableHeight);
    return tableFrame;
}

- (void)layoutSubviews {
    [self.upperStripe setFrame:[self upperStripeFrame]];
//    [self.toField setFrame:[self toFieldFrame]];
    [self.lowerStripe setFrame:[self lowerStripeFrame]];
    
    [self.autocompleteTableView setFrame:[self tableViewFrame]];
}

#pragma mark - First Responder

- (BOOL)isFirstResponder {
    return self.toField.textField.isFirstResponder;
}

- (BOOL)becomeFirstResponder {
    return [self.toField.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.toField.textField resignFirstResponder];
}

#pragma mark - JSTokenFieldDelegate

- (void)tokenFieldDidEndEditing:(JSTokenField *)tokenField {
    [self addTokenFromField:tokenField];
    
}

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    [self.recipients addObject:obj];
    self.recipientCount = [self.recipients count];
    if (self.recipientCount > 0) {
        self.toField.textField.placeholder = nil;
    }
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj {
    [self.recipients removeObject:obj];
    self.recipientCount = [self.recipients count];
    if (self.recipientCount == 0) {
        self.toField.textField.placeholder = [EVStringUtility toFieldPlaceholder];
    }
    DLog(@"Deleted token < %@ : %@ >\n%@", title, obj, self.recipients);
}

- (BOOL)tokenField:(JSTokenField *)tokenField shouldRemoveToken:(NSString *)title representedObject:(id)obj {
    return YES;
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    [self addTokenFromField:tokenField];
    return NO;
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:self.toField])
	{
        [self.lowerStripe setFrame:CGRectMake(0, CGRectGetMaxY(self.toField.frame) + 2.0, self.frame.size.width, 1)];
        [self.autocompleteTableView setFrame:[self tableViewFrame]];
	}
}

- (void)addTokenFromField:(JSTokenField *)tokenField {
    NSString *text = tokenField.textField.text;
    if ([text isEmail]) {
        EVContact *contact = [EVContact new];
        [contact setEmail:text];
        [contact setName:text];
        [self addContact:contact];
        tokenField.textField.text = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:EVExchangeWhoViewAddedTokenFromReturnPressNotification
                                                            object:self];
    }
    // TODO: Support if text is phone number.
}


@end
