var exec = require('cordova/exec');

exports.register = function (arg0, success, error) {
  console.log("FacebookPushCampaign.register()", arg0);

  exec(function (token) {
    console.log("FacebookPushCampaign.register -> success", token);
    success && success(token);
  }, function(error) {
    console.error("FacebookPushCampaign.register -> error", error);
    error && error(error)
  }, "FacebookPushCampaign", "register", [arg0]);
};

exports.didReceiveNotification = function (arg0, success, error) {
  console.log("FacebookPushCampaign.didReceiveNotification()", arg0);

  // do some validation - make sure it adheres to the format!
  exec(function (notification) {
    console.log('FacebookPushCampaign.didReceiveNotification -> success', notification);
    success && success(notification);
  }, function (e) {
    console.error('FacebookPushCampaign.didReceiveNotification -> error', e);
    error && error(e);
  }, "FacebookPushCampaign", "didReceiveRemoteNotification", [arg0]);
};
