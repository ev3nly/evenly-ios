//
//  EVDashboardNoOneJoinedCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/24/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVDashboardNoOneJoinedCell.h"

#define Y_MARGIN 10.0
#define LABEL_MARGIN 40.0
#define LABEL_HEIGHT 50.0

@implementation EVDashboardNoOneJoinedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.position = EVGroupedTableViewCellPositionBottom;
        
        self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Request-Invite-Friends-Banner"]];
        self.iconImageView.frame = CGRectMake((self.contentView.frame.size.width - self.iconImageView.frame.size.width) / 2.0,
                                          2*Y_MARGIN,
                                          self.iconImageView.frame.size.width,
                                          self.iconImageView.frame.size.height);
        self.iconImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.iconImageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN,
                                                               CGRectGetMaxY(self.iconImageView.frame) + Y_MARGIN,
                                                               self.contentView.frame.size.width - 2*LABEL_MARGIN,
                                                               LABEL_HEIGHT)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [EVColor lightLabelColor];
        self.label.font = [EVFont defaultFontOfSize:15];
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.label.numberOfLines = 2;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"No one has joined yet, but that's okay. :)";
        [self.contentView addSubview:self.label];       
    }
    return self;
}

- (void)setInviteButton:(EVBlueButton *)inviteButton {
    [_inviteButton removeFromSuperview];
    _inviteButton = inviteButton;
    self.inviteButton.frame = CGRectMake(10.0,
                                         CGRectGetMaxY(self.label.frame) + Y_MARGIN,
                                         self.contentView.frame.size.width - 20.0,
                                         44.0);
    [self.contentView addSubview:self.inviteButton];
    DLog(@"Where we at? MAX Y: %.1f", CGRectGetMaxY(self.inviteButton.frame));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
