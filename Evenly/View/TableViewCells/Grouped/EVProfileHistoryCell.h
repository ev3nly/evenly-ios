//
//  EVProfileHistoryCell.h
//  Evenly
//
//  Created by Justin Brunet on 6/21/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupedTableViewCell.h"
#import "EVStory.h"

#import <FormatterKit/TTTTimeIntervalFormatter.h>

@interface EVProfileHistoryCell : EVGroupedTableViewCell

+ (CGFloat)cellHeight;
+ (TTTTimeIntervalFormatter *)timeIntervalFormatter;

@property (nonatomic, weak) EVStory *story;

@end
