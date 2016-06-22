#import <Cordova/CDVPlugin.h>
#import "FacebookPushCampaign.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBNotifications/FBNotifications.h>

@implementation FacebookPushCampaign

//
// Decodes an NSString containing hex encoded bytes into an NSData object
// src: http://stackoverflow.com/a/14248343/2093626
//
- (NSData *)stringToHexData: (NSString *) str
{
    double len = [str length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};

    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }

    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

- (void) register:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* msg = [command.arguments objectAtIndex:0];

    if (msg == nil || [msg length] == 0) {
        NSLog(@"FacebookPushCampaign: Register Failed");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {

        NSData* deviceToken = [self stringToHexData:msg];
        [FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];

        NSLog(@"FacebookPushCampaign: Register Succedeed. Token = %@", deviceToken);

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsString:msg];
    }

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void) didReceiveRemoteNotification:(CDVInvokedUrlCommand *)command
{
    NSDictionary* notification = [command.arguments objectAtIndex:0];

    if (notification == nil) {
        NSLog(@"FacebookPushCampaign didReceiveRemoteNotification Failed");

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    } else {
        NSLog(@"FacebookPushCampaign didReceiveRemoteNotification %@", notification);

        [FBSDKAppEvents logPushNotificationOpen:notification];

        // needs to clean up by calling UIBackgroundFetchResult somehow, like in their example

        FacebookPushCampaign* __weak weakSelf = self;
        FBNotificationsManager *notificationsManager = [FBNotificationsManager sharedManager];
        [notificationsManager presentPushCardForRemoteNotificationPayload:notification
                                                       fromViewController:nil
                                                               completion:^(FBNCardViewController * _Nullable viewController, NSError * _Nullable error) {
                                                                   if (error) {
                                                                       CDVPluginResult* pluginResultERROR = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                                                                       [weakSelf.commandDelegate sendPluginResult:pluginResultERROR
                                                                                                   callbackId:command.callbackId];
                                                                   } else {
                                                                       CDVPluginResult* pluginResultOK = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                                                       [weakSelf.commandDelegate sendPluginResult:pluginResultOK
                                                                                                       callbackId:command.callbackId];
                                                                   }
                                                               }];
    }
}

@end