var exec = require('cordova/exec');

exports.register = function (arg0, success, error) {
  console.log("FacebookPushCampaign.register()", arg0);

  exec(success, error, "FacebookPushCampaign", "register", [arg0]);
};

exports.didReceivedNotification = function (arg0, success, error) {
  console.log("FacebookPushCampaign.didReceivedNotification()", arg0);

  // do some validation - make sure it adheres to the format!
  exec(function (notification) {
    console.log('FacebookPushCampaign.didReceivedNotification -> success', notification);
    success && success(notification);
  }, function (e) {
    console.error('FacebookPushCampaign.didReceivedNotification -> error', e);
    error && error(e);
  }, "FacebookPushCampaign", "didReceiveRemoteNotification", [arg0]);
};
