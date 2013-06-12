//
//  EVNetworkSelectorCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/12/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EVNetworkSelectorCellTypeCurrentSelection,
    EVNetworkSelectorCellTypeNetwork,
    EVNetworkSelectorCellTypeFriends,
    EVNetworkSelectorCellTypePrivate
} EVNetworkSelectorCellType;

@interface EVNetworkSelectorCell : UIView

@property (nonatomic, assign) EVNetworkSelectorCellType type;

- (id)initWithFrame:(CGRect)frame andType:(EVNetworkSelectorCellType)type;

@end
