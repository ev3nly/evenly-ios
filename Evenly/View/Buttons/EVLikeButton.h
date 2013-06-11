//
//  EVLikeButton.h
//  Evenly
//
//  Created by Joseph Hankin on 6/11/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVLikeButton : UIButton

@property (nonatomic, strong) UIImageView *likeIcon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat spacing;

@end
