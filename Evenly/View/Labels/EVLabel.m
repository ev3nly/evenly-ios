//
//  EVLabel.m
//  Evenly
//
//  Created by Justin Brunet on 8/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLabel.h"

#define MINIMUM_SPACING -1.0

@interface EVLabel ()

@property (nonatomic, readonly) NSDictionary *attributesDictionary;

@end

@implementation EVLabel

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.characterSpacing = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.text)
        self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:[self attributesDictionary]];
}

#pragma mark - Spacing

- (float)neededCharacterSpacing {
    float currentSpacing = 0;
    if (self.numberOfLines == 1) {
        while ([self sizeWithSpacing:currentSpacing].width > self.bounds.size.width && currentSpacing > MINIMUM_SPACING) {
            currentSpacing -= 0.1;
        }
    }
    return currentSpacing;
}

- (CGSize)sizeWithSpacing:(float)spacing {
    return [self.text _safeSizeWithAttributes:@{NSFontAttributeName: self.font,
                                                NSKernAttributeName: @(spacing)}];
}

#pragma mark - Dictionary

- (NSDictionary *)attributesDictionary {
    float spacing = self.characterSpacing;
    if (self.adjustLetterSpacingToFitWidth)
        spacing = [self neededCharacterSpacing];
    return @{NSFontAttributeName: self.font,
             NSKernAttributeName: @(spacing)};
}

@end
