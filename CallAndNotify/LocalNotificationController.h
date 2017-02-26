//  LocalNotificationController.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const NotificationTypeKey;

@interface LocalNotificationController : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *notifications;

+ (instancetype)sharedInstance;

- (UILocalNotification *)scheduleNotificationOn:(NSDate *)fireDate
                                         forKey:(NSString *)key
                                       category:(NSString *)category
                                      alertBody:(NSString *)alertBody
                                    alertAction:(NSString *)alertAction
                                      soundName:(NSString *)soundName
                                    launchImage:(NSString *)launchImage
                                       userInfo:(NSDictionary *)userInfo
                                     badgeCount:(NSUInteger)badgeCount
                                 repeatInterval:(NSCalendarUnit)repeatInterval;

- (void)scheduleNotifications:(NSArray <UILocalNotification *> *)notifications;

- (void)cancelNotifications;
- (void)cancelNotificationWithKey:(NSString * _Nonnull)notificationKey;
- (void)cancelNotificationWithCategory:(NSString * _Nonnull)notificationCategory;


-(void)clearAllNotifications;
-(void)clearNotification:(UILocalNotification  * _Nullable )notification;

-(void)handleLocalNotification:(UILocalNotification  * _Nonnull )notification;



@end
