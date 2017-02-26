//
//  ViewController.m
//  CallAndNotify
//
//  Created by Peter Sobkowski on 2017-02-26.
//  Copyright © 2017 psobko. All rights reserved.
//

#import "ViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "LocalNotificationController.h"

@interface ViewController ()
    @property (strong, nonatomic) CTCallCenter *callCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (IBAction)call:(id)sender {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                               selector:@selector(applicationWillResignActive:)
                                   name:UIApplicationWillResignActiveNotification object:nil];
//#ifdef useCoreTelephony - for simulator
        _callCenter = [[CTCallCenter alloc] init];
        
        [_callCenter setCallEventHandler: ^(CTCall* call) {
            if ([call.callState isEqualToString: CTCallStateConnected]) {
                NSLog(@"Connected");
            } else if ([call.callState isEqualToString: CTCallStateDialing]) {
                NSLog(@"Dialing");
            } else if ([call.callState isEqualToString: CTCallStateDisconnected]) {
                NSLog(@"Disconnected");
            } else if ([call.callState isEqualToString: CTCallStateIncoming]) {
                NSLog(@"Incoming");
            }
        }];
//#endif
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://4169122675" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    else
    {
        //TODO: show alert that phone calls not available
    }
}
    
- (void)applicationWillResignActive:(UIApplication *)application
{
    //TODO: from here you can listen to appDidEnterForeground to get more precise control for when to show the notification
    UILocalNotification *noti;
    noti = [[LocalNotificationController sharedInstance] scheduleNotificationOn:[NSDate date]
            
                                                                         forKey:@"INFO_KEY"
                                                                       category:@"INFO_CAT"
                                                                      alertBody:@"Whatever text you want"
                                                                    alertAction:nil
                                                                      soundName:nil
                                                                    launchImage:nil
                                                                       userInfo:nil
                                                                     badgeCount:0
                                                                 repeatInterval:0];
        [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
}


@end
