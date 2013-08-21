//
//  EVSettingsViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/3/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

typedef enum {
    EVSettingsSectionMain,
    EVSettingsSectionLegal,
    EVSettingsSectionLogout,
    EVSettingsSectionCOUNT
} EVSettingsSection;

typedef enum {
    EVSettingsMainRowFacebook,
    EVSettingsMainRowNotifications,
    EVSettingsMainRowChangePasscode,
    EVSettingsMainRowCOUNT
} EVSettingsMainRow;

typedef enum {
    EVSettingsLegalRowTermsAndConditions,
    EVSettingsLegalRowPrivacyPolicy,
    EVSettingsLegalRowCOUNT
} EVSettingsLegalRow;

@interface EVSettingsViewController : EVViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end
