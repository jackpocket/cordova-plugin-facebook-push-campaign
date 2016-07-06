# cordova-plugin-facebook-push-campaign

The phonegap wrapper around the new Facebook Push Notifications/In-App Notifications platform.
This is just an addon to the[`cordova-plugin-facebook4`](https://github.com/jeduan/cordova-plugin-facebook4/) so please follow the steps found on their page on how ton install and use it.

**Note: Facebook's platform is still in Beta so be mindful before using it in production.*

### Dependencies 

- Facebook IOS SDK v4.13.0 and up. Currently [`cordova-plugin-facebook4`](https://github.com/jeduan/cordova-plugin-facebook4/) supports v4.11.0, therefore you have to use our fork [`https://github.com/jackpocket/cordova-plugin-facebook4.git`](https://github.com/jackpocket/cordova-plugin-facebook4.git) uses the latest version

- A Push Notifications Plugin such as [`phonegap-plugin-push`](https://github.com/phonegap/phonegap-plugin-push). Please follow the steps on their page on how to install and work with Push Notifications.


### Installation

```
# install cordova-plugin-facebook4
cordova plugin add https://github.com/jackpocket/cordova-plugin-facebook4.git --variable APP_ID="{your app id}" --variable APP_NAME="{you app name}"

# install cordova-plugin-facebook-push-campaign
cordova plugin add https://github.com/jackpocket/cordova-plugin-facebook-push-campaign.git
```

### Usage

```
// wait for device to be ready
window.document.addEventListener('deviceready', function() {
 
  // initiate the push plugin. 
  // For more info on this see https://github.com/jackpocket/cordova-plugin-facebook-push-campaign.git
  pushPlugin
    .init({
      ios: {
        badge:      'true',
        sound:      'true',
        alert:      'true',
        clearBadge: 'true',
      }
    })
    // wait for the plugin to register the Push Token 
    .on('registration', function(pushToken) {
      // grab the token and pass it to Facebook
      cordova.plugins.FacebookPushCampaign.register(pushToken);
    });
});

```
