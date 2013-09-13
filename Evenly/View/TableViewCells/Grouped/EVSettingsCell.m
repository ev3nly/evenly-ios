//
//  EVSettingsCell.m
//  Evenly
//
//  Created by Joseph Hankin on 7/22/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVSettingsCell.h"

#define EV_SETTINGS_ROW_TOP_MARGIN 12.0
#define EV_SETTINGS_ROW_SIDE_MARGIN ([EVUtilities userHasIOS7] ? 20 : 10)
#define EV_SETTINGS_DISCLOSURE_RIGHT_MARGIN 20
#define EV_SETTINGS_ICON_LABEL_BUFFER 10

@interface EVSettingsCell ()

@property (nonatomic, strong) UIImageView *disclosureArrow;

@end

@implementation EVSettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithImage:[EVImages lockIcon]];
        [self.contentView addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor newsfeedNounColor];
        self.label.font = [EVFont blackFontOfSize:15];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
        
        self.disclosureArrow = [[UIImageView alloc] initWithImage:[EVImages dashboardDisclosureArrow]];
        [self addSubview:self.disclosureArrow];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = [self iconViewFrame];
    self.label.frame = [self labelFrame];
    self.disclosureArrow.frame = [self disclosureArrowFrame];
}

- (CGRect)iconViewFrame {
    return CGRectMake(EV_SETTINGS_ROW_SIDE_MARGIN,
                      (self.contentView.frame.size.height - self.iconView.image.size.height) / 2.0,
                      self.iconView.image.size.width,
                      self.iconView.image.size.height);
}

- (CGRect)labelFrame {
    float iconBuffer = self.iconView.image ? EV_SETTINGS_ICON_LABEL_BUFFER : 0;
    float xOrigin = (CGRectGetMaxX(self.iconView.frame) + iconBuffer);
    return CGRectMake(xOrigin,
                      EV_SETTINGS_ROW_TOP_MARGIN,
                      self.frame.size.width - EV_SETTINGS_ROW_SIDE_MARGIN - xOrigin,
                      (self.frame.size.height - 2*EV_SETTINGS_ROW_TOP_MARGIN));
}

- (CGRect)disclosureArrowFrame {
    return CGRectMake(self.bounds.size.width - self.disclosureArrow.image.size.width - EV_SETTINGS_DISCLOSURE_RIGHT_MARGIN,
                      CGRectGetMidY(self.bounds) - self.disclosureArrow.image.size.height/2,
                      self.disclosureArrow.bounds.size.width,
                      self.disclosureArrow.bounds.size.height);
}

@end
