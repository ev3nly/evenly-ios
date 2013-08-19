//
//  EVPINSettingsViewController.h
//  Evenly
//
//  Created by Justin Brunet on 8/16/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVViewController.h"

typedef enum {
    EVPINSettingEnable,
    EVPINSettingChange,
    EVPINSettingCOUNT
} EVPINSetting;

@interface EVPINSettingsViewController : EVViewController <UITableViewDataSource, UITableViewDelegate>

@end
