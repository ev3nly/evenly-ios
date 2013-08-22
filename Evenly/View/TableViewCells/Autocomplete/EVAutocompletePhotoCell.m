//
//  EVAutocompletePhotoCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/1/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVAutocompletePhotoCell.h"

#define LABEL_MARGIN 10.0

@implementation EVAutocompletePhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[EVAvatarView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.height, self.contentView.frame.size.height)];
        self.avatarView.cornerRadius = 0.0;
        [self.contentView addSubview:self.avatarView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + LABEL_MARGIN,
                                                               0,
                                                               self.contentView.frame.size.width - CGRectGetMaxX(self.avatarView.frame) - 2*LABEL_MARGIN,
                                                               self.contentView.frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor darkLabelColor];
        self.label.font = [EVFont blackFontOfSize:15];
        self.label.adjustsLetterSpacingToFitWidth = YES;
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        self.label.autoresizingMask = EV_AUTORESIZE_TO_FIT;
        [self.contentView addSubview:self.label];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = CGRectMake(0, 0, self.contentView.frame.size.height, self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
