//  LocalNotificationController.m


#import "LocalNotificationController.h"

@interface LocalNotificationController ()

@property (strong, nonatomic) NSMutableDictionary *notificationHandlers;

@end


@implementation LocalNotificationController

NSString * const NotificationTypeKey = @"NotificationTypeKey";

#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static LocalNotificationController * singletonInstance = nil;
    if (!singletonInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singletonInstance = [[super allocWithZone:NULL] init];
            //init array of notificaitons
        });
    }
    return singletonInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Private


-(UILocalNotification *)notificationOn:(NSDate *)fireDate
                                forKey:(NSString *)key
                              category:(NSString *)category
                             alertBody:(NSString *)alertBody
                           alertAction:(NSString *)alertAction
                             soundName:(NSString *)soundName
                           launchImage:(NSString *)launchImage
                              userInfo:(NSDictionary *)userInfo
                            badgeCount:(NSUInteger)badgeCount
                        repeatInterval:(NSCalendarUnit)repeatInterval
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    if (!notification) //User has denied requirement
    {
        return nil;
    }
    
    notification.fireDate = fireDate;
    notification.category = category;
    notification.alertBody = alertBody;
    notification.alertAction = alertAction;
    notification.soundName = soundName ?: UILocalNotificationDefaultSoundName;
    notification.alertLaunchImage = launchImage;
    
    NSMutableDictionary *updatedUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    updatedUserInfo[NotificationTypeKey] = key;
    notification.userInfo = updatedUserInfo;
    
    if(badgeCount > 0)
    {
        notification.applicationIconBadgeNumber = badgeCount;
    }
    
    //TODO: Only set for repated?
    notification.repeatInterval = repeatInterval;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    return notification;

}

#pragma mark - Scheduling

- (UILocalNotification *)scheduleNotificationOn:(NSDate *)fireDate
                                         forKey:(NSString *)key
                                       category:(NSString *)category
                                      alertBody:(NSString *)alertBody
                                    alertAction:(NSString *)alertAction
                                      soundName:(NSString *)soundName
                                    launchImage:(NSString *)launchImage
                                       userInfo:(NSDictionary *)userInfo
                                     badgeCount:(NSUInteger)badgeCount
                                 repeatInterval:(NSCalendarUnit)repeatInterval
{
    UILocalNotification *notification = [self notificationOn:fireDate
                                                      forKey:key
                                                    category:category
                                                   alertBody:alertBody
                                                 alertAction:alertAction
                                                   soundName:soundName
                                                 launchImage:launchImage
                                                    userInfo:userInfo
                                                  badgeCount:badgeCount
                                              repeatInterval:repeatInterval];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    return notification;
}

-(void)scheduleNotifications:(NSArray <UILocalNotification *> *)notifications
{
    [[UIApplication sharedApplication] setScheduledLocalNotifications:notifications];

}

#pragma mark - Canceling

- (void)cancelNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)cancelNotificationWithKey:(NSString * _Nonnull)notificationKey
{
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if([obj.userInfo[NotificationTypeKey] isEqualToString:notificationKey])
        {
            [self cancelNotification:obj];
            *stop = YES;
            return;
        }
    }];
}

- (void)cancelNotificationWithCategory:(NSString * _Nonnull)notificationCategory
{
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj.category isEqualToString:notificationCategory])
        {
            [self cancelNotification:obj];
        }
    }];
}

- (void)cancelNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

#pragma mark - Clearing

-(void)clearAllNotifications
{
    NSArray *activeNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    for (UILocalNotification *notification in activeNotifications)
    {
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)clearNotification:(UILocalNotification *)notification
{
    NSArray *activeNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    for (UILocalNotification *notification in activeNotifications)
    {
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    //need array of notificaitons
}

#pragma mark - Accessors

-(NSArray *)notifications
{
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

#pragma mark - Handling

-(void)handleLocalNotification:(UILocalNotification *)notification
{
}

@end
