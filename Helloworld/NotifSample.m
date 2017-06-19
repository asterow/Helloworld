//
//  NotifSample.m
//  Helloworld
//
//  Created by frederic.THEAULT on 14/06/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

#import "NotifSample.h"

#import <Foundation/Foundation.h>

#import <UserNotifications/UserNotifications.h>
//#import <UIKit/UIKit.h>


@implementation NotifSample

//- (id) init {
//    
//    //        [self sayHi];
//    return self;
//}

- (void) sayHi {
    
    printf("Hello Objective C !!!");
}

- (void) requestPushPermission {
    
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
   
}

- (void) setCustomActions {
    
    UNNotificationCategory* generalCategory = [UNNotificationCategory
                                               categoryWithIdentifier:@"GENERAL"
                                               actions:@[]
                                               intentIdentifiers:@[]
                                               options:UNNotificationCategoryOptionCustomDismissAction];
    
    // Create the custom actions for expired timer notifications.
    UNNotificationAction* snoozeAction = [UNNotificationAction
                                          actionWithIdentifier:@"SNOOZE_ACTION"
                                          title:@"Snooze"
                                          options:UNNotificationActionOptionNone];
    
    UNNotificationAction* stopAction = [UNNotificationAction
                                        actionWithIdentifier:@"STOP_ACTION"
                                        title:@"Stop"
                                        options:UNNotificationActionOptionForeground];
    
    // Create the category with the custom actions.
    UNNotificationCategory* expiredCategory = [UNNotificationCategory
                                               categoryWithIdentifier:@"TIMER_EXPIRED"
                                               actions:@[snoozeAction, stopAction]
                                               intentIdentifiers:@[]
                                               options:UNNotificationCategoryOptionNone];
    
    UNNotificationAction* contact = [UNNotificationAction
                                          actionWithIdentifier:@"CONTACT_ACTION"
                                          title:@"Contacter"
                                          options:UNNotificationActionOptionNone];
    
    UNNotificationAction* details = [UNNotificationAction
                                        actionWithIdentifier:@"DETAIL_ACTION"
                                        title:@"Voir le programme"
                                        options:UNNotificationActionOptionForeground];
    
    // Create the category with the custom actions.
    UNNotificationCategory* limmoCategory = [UNNotificationCategory
                                               categoryWithIdentifier:@"LIMMO_CATEGORY"
                                               actions:@[contact, details]
                                               intentIdentifiers:@[]
                                               options:UNNotificationCategoryOptionNone];
    
    // Register the notification categories.
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObjects:generalCategory, expiredCategory, limmoCategory, nil]];

}



// ...

@end
