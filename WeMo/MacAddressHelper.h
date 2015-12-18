//
//  MacAddressHelper.h
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MacAddressHelper : NSObject
+ (NSString *)macAddressForIPAddress:(NSString *)ipAddress;

@end
