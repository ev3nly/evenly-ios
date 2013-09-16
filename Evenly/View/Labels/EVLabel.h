//
//  EVLabel.h
//  Evenly
//
//  Created by Justin Brunet on 8/27/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * NOTE: Don't set attributedText on this label -- its inner workings use that property to 
 * make the spacing effect work with non-attributed text.  If you are going to set an attributed 
 * string on a label, just use a regular UILabel.
 */
@interface EVLabel : UILabel

@property (nonatomic, assign) float characterSpacing;
@property (nonatomic, assign) BOOL adjustLetterSpacingToFitWidth;

@end
