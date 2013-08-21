//
//  IVApplicationErrorHandler.h
//  IvyPrototype
//
//  Created by Sean Yu on 4/10/13.
//  Copyright (c) 2013 Joseph Hankin. All rights reserved.
//

/*
 Subclass of EVErrorHandler.
 Used to execute UI and app dependent logic, as to remove those dependencies
 from the Model and Networking code
 */

#import "EVErrorHandler.h"

@interface EVAppErrorHandler : EVErrorHandler

@end
