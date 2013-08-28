//
//  EVLabel.m
//  Evenly
//
//  Created by Justin Brunet on 8/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVLabel.h"

@interface EVLabel ()

@property (nonatomic, readonly) NSDictionary *attributesDictionary;

@end

@implementation EVLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.characterSpacing = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:[self attributesDictionary]];
}

- (CGSize)sizeWithSpacing:(float)spacing {
    return [self.text sizeWithAttributes:@{NSFontAttributeName: self.font,
                                           NSKernAttributeName: @(spacing)}];
}

- (float)neededCharacterSpacing {
    float currentSpacing = 0;
    if (self.numberOfLines == 1) {
        while ([self sizeWithSpacing:currentSpacing].width > self.bounds.size.width) {
            currentSpacing -= 0.1;
        }
    }
    return currentSpacing;
}

- (NSDictionary *)attributesDictionary {
    return @{NSFontAttributeName: self.font,
             NSKernAttributeName: @([self neededCharacterSpacing])};
}

@end
