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

- (void)drawTextInRect:(CGRect)rect
{
    if (self.characterSpacing)
    {
        // Drawing code
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSelectFont (context, [self.font.fontName cStringUsingEncoding:NSASCIIStringEncoding], self.font.pointSize, kCGEncodingMacRoman);
        CGContextSetCharacterSpacing(context, self.characterSpacing);
        CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
        CGAffineTransform myTextTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f );
        CGContextSetTextMatrix (context, myTextTransform);
        
        CGGlyph glyphs[self.text.length];
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        CTFontGetGlyphsForCharacters(fontRef, (const unichar*)[self.text cStringUsingEncoding:NSUnicodeStringEncoding], glyphs, self.text.length);
        float centeredY = (self.font.pointSize + (self.frame.size.height- self.font.pointSize)/2)-2;
        CGContextShowGlyphsAtPoint(context, rect.origin.x, centeredY, (const CGGlyph *)glyphs, self.text.length);
        CFRelease(fontRef);
    }
    else
    {
        // no character spacing provided so do normal drawing
        [super drawTextInRect:rect];
    }
}   


@end
