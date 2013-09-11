//
//  EVAutocompleteEmailCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompleteEmailCell.h"

#define TOP_BOTTOM_MARGINS 5
#define LABEL_MARGIN 10

@implementation EVAutocompleteEmailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[EVLabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN,
                                                                   0,
                                                                   self.contentView.frame.size.width - 2*LABEL_MARGIN,
                                                                   self.contentView.frame.size.height / 2.0)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [EVColor darkLabelColor];
        self.nameLabel.font = [EVFont blackFontOfSize:15];
        self.nameLabel.adjustLetterSpacingToFitWidth = YES;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.nameLabel];
        
        self.emailLabel = [[EVLabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN,
                                                                    CGRectGetMaxY(self.nameLabel.frame),
                                                                    self.contentView.frame.size.width - 2*LABEL_MARGIN,
                                                                    self.contentView.frame.size.height - CGRectGetMaxY(self.nameLabel.frame))];
        self.emailLabel.backgroundColor = [UIColor clearColor];
        self.emailLabel.textColor = [EVColor lightLabelColor];
        self.emailLabel.font = [EVFont defaultFontOfSize:15];
        self.emailLabel.adjustLetterSpacingToFitWidth = YES;
        self.emailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.emailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
