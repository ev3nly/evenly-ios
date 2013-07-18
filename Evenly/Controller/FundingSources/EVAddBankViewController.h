//
//  EVAddBankViewController.h
//  Evenly
//
//  Created by Joseph Hankin on 6/17/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVModalViewController.h"

@interface EVAddBankViewController : EVModalViewController <UITableViewDataSource,
                                                       UITableViewDelegate,
                                                       UITextFieldDelegate,
                                                       UIPickerViewDelegate,
                                                       UIPickerViewDataSource>
@end
