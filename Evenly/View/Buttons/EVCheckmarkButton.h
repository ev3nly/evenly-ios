//
//  EVCheckmarkButton.h
//  Evenly
//
//  Created by Justin Brunet on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCheckmarkButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSString *text;

- (id)initWithText:(NSString *)text;

@end
