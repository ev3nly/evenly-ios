//
//  EVCreditCard.m
//  Evenly
//
//  Created by Sean Yu on 4/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVCreditCard.h"
#import "EVConstants.h"
#import <Balanced/Balanced.h>
#import <PaymentKit/PKView.h>

@implementation EVCreditCard

static NSDateFormatter *_dateFormatter = nil;
+ (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    }
    return _dateFormatter;
}

- (void)setProperties:(NSDictionary *)properties {
    [super setProperties:properties];
    
    self.lastFour = [properties valueForKey:@"last_four"];
    if ([properties valueForKey:@"brand"] != [NSNull null])
        self.brand = [properties valueForKey:@"brand"];
    self.expirationMonth = [properties valueForKey:@"expiration_month"];
    self.expirationYear = [properties valueForKey:@"expiration_year"];
}

+ (NSString *)controllerName {
    return @"creditcards";
}

- (void)tokenizeWithSuccess:(void(^)(void))success failure:(void(^)(NSError *))failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSString *balancedURL = [[EVNetworkManager sharedInstance] balancedURLStringForServerSelection:[[EVNetworkManager sharedInstance] serverSelection]];
        Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:balancedURL];
        BPCard *card = [[BPCard alloc] initWithNumber:self.number
                                   andExperationMonth:self.expirationMonth
                                    andExperationYear:self.expirationYear
                                      andSecurityCode:self.cvv];
        
        NSError *error;
        NSDictionary *response = [balanced tokenizeCard:card error:&error];
        
        if (!error) {
            self.uri = response[@"uri"];
        }
        else {
            NSLog(@"%@", [error description]);
        }
        
        if (self.uri) {
            if (success)
                success();
        } else {
            error = [NSError errorWithDomain:@"Balanced" code:[response[@"status_code"] intValue] userInfo:response];
            if (failure)
                failure(error);
        }
        
    });
}


- (PKCardType)cardTypeFromBrand:(NSString *)brand {
    if ([[brand lowercaseString] isEqualToString:@"american express"])
        return PKCardTypeAmex;
    if ([[brand lowercaseString] isEqualToString:@"diners club"])
        return PKCardTypeDinersClub;
    if ([[brand lowercaseString] isEqualToString:@"discover"])
        return PKCardTypeDiscover;
    if ([[brand lowercaseString] isEqualToString:@"jcb"])
        return PKCardTypeJCB;
    if ([[brand lowercaseString] isEqualToString:@"mastercard"])
        return PKCardTypeMasterCard;
    if ([[brand lowercaseString] isEqualToString:@"visa"])
        return PKCardTypeVisa;
    return PKCardTypeUnknown;
}

// From PKView's private -(void)setPlaceHolderToCardType
- (UIImage *)brandImage {
    PKCardType cardType      = [self cardTypeFromBrand:self.brand];
    NSString* cardTypeName   = @"placeholder";
    
    switch (cardType) {
        case PKCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case PKCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case PKCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case PKCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case PKCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case PKCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
    
    return [UIImage imageNamed:cardTypeName];
}

- (NSComparisonResult)compareByBrandAndLastFour:(EVCreditCard *)otherCard {
    if ([self.brand isEqualToString:otherCard.brand]) {
        return [self.lastFour caseInsensitiveCompare:otherCard.lastFour];
    }
    return [self.brand caseInsensitiveCompare:otherCard.brand];    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<0x%x> %@ card ending in %@", (int)self, self.brand, self.lastFour];
}

@end
