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
    NSLog(@"JP Registering");

    CDVPluginResult* pluginResult = nil;
    NSString* msg = [command.arguments objectAtIndex:0];

    if (msg == nil || [msg length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {

        NSData* deviceToken = [self stringToHexData:msg];
        [FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];

        NSLog(@"%@", [NSString stringWithFormat:@"JP: APN Device Token =%@", msg]);
        NSLog(@"%@", [NSString stringWithFormat:@"JP: APN Device Token As Data =%@", deviceToken]);

        UIAlertView *toast = [
                              [UIAlertView alloc] initWithTitle:@""
                              message:[NSString stringWithFormat:@"Device token is: %@", deviceToken]
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:nil, nil];

        [toast show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           [toast dismissWithClickedButtonIndex:0 animated:YES];
                       });

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                         messageAsString:msg];
    }

    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void) didReceiveRemoteNotification:(CDVInvokedUrlCommand *)command
{
    NSLog(@"JP didReceiveRemoteNotification");

    CDVPluginResult* pluginResult = nil;
    NSDictionary* msg = [command.arguments objectAtIndex:0];

    NSLog(@"JP msg=%@", msg);

    FacebookPushCampaign* __weak weakSelf = self;
    if (msg == nil) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    } else {
        FBNotificationsManager *notificationsManager = [FBNotificationsManager sharedManager];
        [notificationsManager presentPushCardForRemoteNotificationPayload:msg
                                                       fromViewController:nil
                                                               completion:^(FBNCardViewController * _Nullable viewController, NSError * _Nullable error) {
                                                                   if (error) {
                                                                       NSLog(@"JP error");

                                                                       CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                                                                       [weakSelf.commandDelegate sendPluginResult:pluginResult
                                                                                                   callbackId:command.callbackId];
                                                                   } else {
                                                                       NSLog(@"JP success");

                                                                       CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                                                       [weakSelf.commandDelegate sendPluginResult:pluginResult
                                                                                                       callbackId:command.callbackId];
                                                                   }
                                                               }];
    }
}

@end