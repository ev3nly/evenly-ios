//
//  EVRequestInitialView.m
//  Evenly
//
//  Created by Joseph Hankin on 6/18/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVRequestInitialView.h"
#import "EVInstructionView.h"

#define PLACEHOLDER @"Name, email, phone number"

#define REQUEST_SWITCH_HEIGHT 45
#define TOKEN_FIELD_ADJUSTMENT 5
#define LEFT_RIGHT_BUFFER 10
#define TO_FIELD_HEIGHT 35
#define LINE_HEIGHT 40

@interface EVRequestInitialView ()

@property (nonatomic, strong) UIView *requestSwitchBackground;
@property (nonatomic, strong) UIView *upperStripe;
@property (nonatomic, strong) UIView *lowerStripe;
@property (nonatomic) NSInteger recipientCount;
@end

@implementation EVRequestInitialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recipients = [NSMutableArray array];
        
        [self.titleLabel removeFromSuperview];

        [self loadRequestSwitch];
        [self loadToField];
        
        [self setUpReactions];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTokenFieldFrameDidChange:)
                                                     name:JSTokenFieldFrameDidChangeNotification
                                                   object:nil];
        
        [self.toField becomeFirstResponder];
    }
    return self;
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
    [self positionTableView];    
}

#pragma mark - View Loading

- (void)loadRequestSwitch {
    self.requestSwitchBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            self.frame.size.width,
                                                                            REQUEST_SWITCH_HEIGHT)];
    self.requestSwitchBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:self.requestSwitchBackground];
    
    self.requestSwitch = [[EVRequestSwitch alloc] initWithFrame:[self requestSwitchFrame]];
    self.requestSwitch.delegate = self;
    [self.requestSwitchBackground addSubview:self.requestSwitch];

}

- (CGRect)requestSwitchFrame {
    return CGRectMake(10, 7, 300, 35);
}

- (void)switchControl:(EVSwitch *)switchControl willChangeStateTo:(BOOL)onOff animationDuration:(NSTimeInterval)duration {
    if (onOff == YES && self.recipientCount == 0) {
        EVInstructionView *instructionView = [[EVInstructionView alloc] initWithText:[EVStringUtility groupRequestCreationInstructions]];
        [instructionView setShowingLogo:YES];
        [instructionView flashInView:self forDuration:2.5];
    }    
}

- (void)loadToField
{
    self.upperStripe = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                CGRectGetMaxY(self.requestSwitchBackground.frame) + EV_REQUEST_VIEW_LABEL_FIELD_BUFFER,
                                                                self.frame.size.width,
                                                                1)];
    self.upperStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.upperStripe];
    
    CGRect fieldFrame = CGRectMake(LEFT_RIGHT_BUFFER,
                                   CGRectGetMaxY(self.upperStripe.frame) + EV_REQUEST_VIEW_LABEL_FIELD_BUFFER - TOKEN_FIELD_ADJUSTMENT,
                                   self.frame.size.width - 2*LEFT_RIGHT_BUFFER,
                                   TO_FIELD_HEIGHT);
    self.toField = [[JSTokenField alloc] initWithFrame:fieldFrame];
    self.toField.textField.placeholder = PLACEHOLDER;
    self.toField.textField.returnKeyType = UIReturnKeyNext;
    self.toField.backgroundColor = [UIColor clearColor];
    self.toField.textField.font = [EVFont lightExchangeFormFont];
    self.toField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.toField.delegate = self;
    [self addSubview:self.toField];

    self.lowerStripe = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toField.frame) + 1, self.frame.size.width, 1)];
    self.lowerStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.lowerStripe];
}

- (void)positionTableView {
    float tableHeight = self.frame.size.height - CGRectGetMaxY(self.toField.frame);
    CGRect tableFrame =  CGRectMake(0,
                                    CGRectGetMaxY(self.lowerStripe.frame),
                                    self.frame.size.width,
                                    tableHeight);
    DLog(@"Table frame: %@", NSStringFromCGRect(tableFrame));
    [self.autocompleteTableView setFrame:tableFrame];
}

- (void)setUpReactions {
    [RACAble(self.requestSwitch.xPercentage) subscribeNext:^(NSNumber *percentage) {
        // TODO: Something with the flash message?
    }];
    
    // JH: I couldn't figure out a way to do this using ReactiveCocoa, so I just went back
    // to the old-fashioned KVO.  If anybody wants to get modern with this, please feel free.
    [self addObserver:self
           forKeyPath:@"recipientCount"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"recipientCount"])
    {
        int oldCount = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        int newCount = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        if (oldCount == 1 && newCount == 2 && ![self.requestSwitch isOn])
        {
            [self.requestSwitch setOn:YES animated:YES];
            self.didForceSwitchToGroup = YES;
        }
        else if (oldCount == 2 && newCount == 1 && self.didForceSwitchToGroup)
        {
            [self.requestSwitch setOn:NO animated:YES];
            self.didForceSwitchToGroup = NO;
        }
    }
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
        self.toField.textField.placeholder = PLACEHOLDER;
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
        [self positionTableView];
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
    }
    
    // TODO: Support if text is phone number.
}

@end
