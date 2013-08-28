//
//  EVSpreadLabel.m
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//
//  Adapted from https://gist.github.com/symorium/3858953
//  Many thanks to symorium, https://github.com/symorium

#import "EVSpreadLabel.h"
#import <CoreText/CoreText.h>

@implementation EVSpreadLabel

- (void)setText:(NSString *)text {
    [super setText:text];
    
    self.attributedText = [[NSAttributedString alloc] initWithString:text
                                                          attributes:@{NSKernAttributeName: @(self.characterSpacing)}];
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing {
    _characterSpacing = characterSpacing;
    
    if (self.text)
        self.attributedText = [[NSAttributedString alloc] initWithString:self.text
                                                              attributes:@{NSKernAttributeName: @(self.characterSpacing)}];
}

@end
