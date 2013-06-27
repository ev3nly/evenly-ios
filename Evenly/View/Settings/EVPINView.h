//
//  EVPINView.h
//  Evenly
//
//  Created by Justin Brunet on 6/26/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVPINView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) void (^handleNewPin)(NSString *pin);

- (void)reset;

@end
