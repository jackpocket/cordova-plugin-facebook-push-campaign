var exec = require('cordova/exec');

exports.register = function (arg0, success, error) {
  console.log("FacebookPushCampaign.register()", arg0);

  exec(success, error, "FacebookPushCampaign", "register", [arg0]);
};

exports.didReceivedNotification = function (arg0, success, error) {
  console.log("FacebookPushCampaign.didReceivedNotification()", arg0);

  // do some validation - make sure it adheres to the format!

  exec(function () {
    console.log('FacebookPushCampaign.didReceivedNotification -> success');
    success && success();
  }, function () {
    console.log('FacebookPushCampaign.didReceivedNotification -> error');

    error && error();
  }, "FacebookPushCampaign", "didReceiveRemoteNotification", [arg0]);
};
