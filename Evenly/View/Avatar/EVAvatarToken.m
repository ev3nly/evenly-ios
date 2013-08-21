//
//  EVAvatarToken.m
//  Evenly
//
//  Created by Joseph Hankin on 7/7/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAvatarToken.h"
#import "EVAvatarView.h"
#import "JSTokenButton.h"

#define SPACING 6.0
#define MAX_AVATARS 3

#define EV_AVATAR_TOKEN_MAX_WIDTH 190.0

@interface EVAvatarToken ()

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSMutableArray *avatarViews;
@property (nonatomic, strong) JSTokenButton *token;

@end

@implementation EVAvatarToken

+ (id)avatarTokenForPerson:(EVObject <EVExchangeable>*)person {
    return [self avatarTokenForPeople:@[ person ]];
}

+ (id)avatarTokenForPeople:(NSArray *)people {
    EVAvatarToken *avatarToken = [[self alloc] initWithFrame:CGRectZero];
    [avatarToken setPeople:people];
    [avatarToken setNeedsLayout];
    return avatarToken;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarViews = [NSMutableArray array];
        self.maxWidth = EV_AVATAR_TOKEN_MAX_WIDTH;
    }
    return self;
}

- (void)setPeople:(NSArray *)people {
    _people = people;
    
    [self.token removeFromSuperview];
    self.token = nil;
    [self.avatarViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.avatarViews removeAllObjects];
    
    [self generateToken];
    [self generateAvatars];
    [self sizeToFit];
}

- (void)generateToken {
    if ([self.people count] == 0) {
        self.token = [JSTokenButton tokenWithString:@"Multiple people" representedObject:nil];
    } else if ([self.people count] == 1) {
        self.token = [JSTokenButton tokenWithString:[[self.people lastObject] name] representedObject:nil];
    } else {
        self.token = [JSTokenButton tokenWithString:[NSString stringWithFormat:@"%d people", [self.people count]]
                                  representedObject:nil];
    }
}

- (void)generateAvatars {
    EVAvatarView *avatarView;
    for (int i=0; i<MIN(self.people.count, MAX_AVATARS); i++) {
        avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(0, 0, [self avatarWidth], self.token.frame.size.height)];
        [avatarView setAvatarOwner:[self.people objectAtIndex:i]];
        [self.avatarViews addObject:avatarView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self addSubview:self.token];
    [self.token setOrigin:CGPointZero];
    
    
    if (self.token.frame.size.width + SPACING + [self avatarWidth] > self.maxWidth)
    {
        [self.token setSize:CGSizeMake(self.maxWidth - SPACING - [self avatarWidth], self.token.frame.size.height)];
    }
    
    CGFloat x = CGRectGetMaxX(self.token.frame) + SPACING;
    for (EVAvatarView *avatarView in self.avatarViews) {
        [self addSubview:avatarView];
        [avatarView setOrigin:CGPointMake(x, 0)];
        x += avatarView.frame.size.width + SPACING;
        if (x + [self avatarWidth] > self.maxWidth)
            break;
    }
}

- (CGFloat)avatarWidth {
    return self.token.frame.size.height;
}

- (void)setMaxWidth:(CGFloat)maxWidth {
    _maxWidth = maxWidth;
    [self setNeedsLayout];
}

- (CGFloat)totalWidth {
    CGFloat calculatedWidth = self.token.frame.size.width + MIN(self.avatarViews.count, MAX_AVATARS) * (SPACING + [self avatarWidth]);
    return MIN(calculatedWidth, self.maxWidth);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([self totalWidth], self.token.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
