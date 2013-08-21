//
//  EVWalletNotification.m
//  Evenly
//
//  Created by Joseph Hankin on 8/2/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVWalletNotification.h"

@implementation EVWalletNotification

+ (instancetype)unconfirmedNotification {
    return [[EVUnconfirmedWalletNotification alloc] init];
}

- (NSAttributedString *)attributedText {
    CGFloat fontSize = 15;
    NSDictionary *nounAttributes = @{ NSFontAttributeName : [EVFont boldFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : [EVColor newsfeedNounColor] };
    NSDictionary *copyAttributes = @{ NSFontAttributeName : [EVFont defaultFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : [EVColor newsfeedTextColor] };
    
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", self.headline]
                                                                attributes:nounAttributes];
    NSAttributedString *description = [[NSAttributedString alloc] initWithString:self.bodyText
                                                                      attributes:copyAttributes];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:title];
    [attrString appendAttributedString:description];
    return (NSAttributedString *)attrString;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        EVWalletNotification *note = (EVWalletNotification *)object;
        return EV_STRINGS_EQUAL_OR_NIL(self.headline, note.headline) && EV_STRINGS_EQUAL_OR_NIL(self.bodyText, note.bodyText);
    }
    return NO;
}

- (NSUInteger)hash {
    return [NSStringFromClass([self class]) hash] + 7 * [self.headline hash] + 11 * [self.bodyText hash];
}

@end

@implementation EVUnconfirmedWalletNotification

- (NSString *)headline {
    return @"Finish setting up your Evenly account";
}

- (NSString *)bodyText {
    return [NSString stringWithFormat:@"Follow these steps, and you'll be ready to go in no time!"];
}

- (UIImage *)avatar {
    return [UIImage imageNamed:@"evenly_lock_confirmation"];
}

@end