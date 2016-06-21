#import <Cordova/CDVPlugin.h>
#import "FacebookPushCampaign.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookPushCampaign

- (void) register:(CDVInvokedUrlCommand *)command
{
    NSLog(@"JP Registering");

    CDVPluginResult* pluginResult = nil;
    NSString* msg = [command.arguments objectAtIndex:0];

    if (msg == nil || [msg length] == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {

        NSString* deviceToken = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];

        NSLog(@"%@", [NSString stringWithFormat:@"JP: APN Device Token=%@", deviceToken]);

        UIAlertView *toast = [
                              [UIAlertView alloc] initWithTitle:@""
                              message:msg
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

@end