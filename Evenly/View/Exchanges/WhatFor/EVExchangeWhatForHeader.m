//
//  EVExchangeWhatForHeader.m
//  Evenly
//
//  Created by Joseph Hankin on 7/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVExchangeWhatForHeader.h"
#import "EVAvatarToken.h"

#define DEFAULT_FRAME CGRectMake(0, 0, 320, 44)
#define X_MARGIN 10.0
#define X_SPACING 6.0

typedef enum {
    EVExchangeWhatForTypePayment,
    EVExchangeWhatForTypeRequest,
    EVExchangeWhatForTypeTip
} EVExchangeWhatForType;

@interface EVExchangeWhatForHeader ()

@property (nonatomic) EVExchangeWhatForType type;
@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSArray *amounts;

@property (nonatomic, strong) UILabel *verbLabel;
@property (nonatomic, strong) EVLabel *amountLabel;
@property (nonatomic, strong) EVAvatarToken *avatarToken;
@property (nonatomic, strong) UIView *bottomStripe;

@end

@implementation EVExchangeWhatForHeader

+ (id)paymentHeaderForPerson:(EVObject <EVExchangeable>*)person amount:(NSDecimalNumber *)amount {
    return [[self alloc] initWithWhatForType:EVExchangeWhatForTypePayment people:@[ person ] amounts:@[ amount ]];
}

+ (id)requestHeaderForPerson:(EVObject <EVExchangeable>*)person amount:(NSDecimalNumber *)amount {
    return [[self alloc] initWithWhatForType:EVExchangeWhatForTypeRequest people:@[ person ] amounts:@[ amount ]];
}

+ (id)groupRequestHeaderForPeople:(NSArray *)people amounts:(NSArray *)amounts {
    return [[self alloc] initWithWhatForType:EVExchangeWhatForTypeRequest people:people amounts:amounts];
}

+ (id)tipHeaderForPerson:(EVObject <EVExchangeable>*)person {
    return [[self alloc] initWithWhatForType:EVExchangeWhatForTypeTip people:@[ person ] amounts:nil];
}

- (id)initWithWhatForType:(EVExchangeWhatForType)type people:(NSArray *)people amounts:(NSArray *)amounts {
    self = [self initWithFrame:DEFAULT_FRAME];
    if (self) {
        self.type = type;
        self.people = people;
        self.amounts = amounts;
        
        [self generateAvatarToken];
        [self generateVerbLabel];
        [self generateAmountLabel];
        [self generateBottomStripe];
        [self setNeedsLayout];
    }
    return self;
}

- (void)generateAvatarToken {
    self.avatarToken = [EVAvatarToken avatarTokenForPeople:self.people];
    [self addSubview:self.avatarToken];
}

- (void)generateVerbLabel {
    NSString *text;
    if (self.type == EVExchangeWhatForTypePayment)
        text = @"Pay";
    else if (self.type == EVExchangeWhatForTypeRequest) {
        text = (self.people.count == 1 ? @"owes me" : @"owe me");
    } else if (self.type == EVExchangeWhatForTypeTip) {
        text = @"Tip";
    }
    
    self.verbLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.verbLabel.font = [EVFont defaultFontOfSize:15];
    self.verbLabel.backgroundColor = [UIColor clearColor];
    self.verbLabel.textColor = [EVColor lightLabelColor];
    self.verbLabel.text = text;
    [self.verbLabel sizeToFit];
    [self addSubview:self.verbLabel];
}

- (void)generateAmountLabel {
    NSString *text = (self.amounts.count == 1 ?
                      [EVStringUtility amountStringForAmount:[self.amounts lastObject]] :
                      [NSString stringWithFormat:@"%d amounts", self.amounts.count]);
    if (self.type == EVExchangeWhatForTypeTip)
        text = @"";
    
    self.amountLabel = [[EVLabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabel.font = [EVFont boldFontOfSize:15];
    self.amountLabel.textColor = [UIColor blackColor];
    self.amountLabel.text = text;
    self.amountLabel.textAlignment = NSTextAlignmentRight;
    self.amountLabel.adjustLetterSpacingToFitWidth = YES;
    [self.amountLabel sizeToFit];    
    [self addSubview:self.amountLabel];
}

- (void)generateBottomStripe {
    self.bottomStripe = [[UIView alloc] initWithFrame:[self bottomStripeFrame]];
    self.bottomStripe.backgroundColor = [EVColor newsfeedStripeColor];
    [self addSubview:self.bottomStripe];
}

- (void)layoutSubviews {
    
    CGFloat tokenMaxWidth = self.frame.size.width - 2*X_MARGIN - self.verbLabel.frame.size.width - self.amountLabel.frame.size.width - 2*X_SPACING;
    [self.avatarToken setMaxWidth:tokenMaxWidth];
    [self.avatarToken sizeToFit];
    [self.avatarToken layoutSubviews];
    
    CGFloat maxX = 0.0;
    if (self.type == EVExchangeWhatForTypePayment || self.type == EVExchangeWhatForTypeTip)
    {
        self.verbLabel.frame = CGRectMake(X_MARGIN,
                                          (self.frame.size.height - self.verbLabel.frame.size.height) / 2.0,
                                          self.verbLabel.frame.size.width,
                                          self.verbLabel.frame.size.height);
        
        self.avatarToken.frame = CGRectMake(CGRectGetMaxX(self.verbLabel.frame) + X_SPACING,
                                            (self.frame.size.height - self.avatarToken.frame.size.height) / 2.0,
                                            self.avatarToken.frame.size.width,
                                            self.avatarToken.frame.size.height);
        maxX = CGRectGetMaxX(self.avatarToken.frame) + X_SPACING;
    }
    else
    {
        self.avatarToken.frame = CGRectMake(X_MARGIN,
                                            (self.frame.size.height - self.avatarToken.frame.size.height) / 2.0,
                                            self.avatarToken.frame.size.width,
                                            self.avatarToken.frame.size.height);
        
        
        
        self.verbLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarToken.frame) + X_SPACING,
                                          (self.frame.size.height - self.verbLabel.frame.size.height) / 2.0,
                                          self.verbLabel.frame.size.width,
                                          self.verbLabel.frame.size.height);
        maxX = CGRectGetMaxX(self.verbLabel.frame) + X_SPACING;
    }
    
    self.amountLabel.frame = CGRectMake(maxX, 0, self.frame.size.width - maxX - X_MARGIN, self.frame.size.height);
    self.bottomStripe.frame = [self bottomStripeFrame];
}

- (CGRect)bottomStripeFrame {
    return CGRectMake(0,
                      self.frame.size.height - [EVUtilities scaledDividerHeight],
                      self.frame.size.width,
                      [EVUtilities scaledDividerHeight]);
}

@end
