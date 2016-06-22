var exec = require('cordova/exec');

exports.register = function(arg0, success, error) {
    console.log("FacebookPushCampaign.register()", arg0);

    exec(success, error, "FacebookPushCampaign", "register", [arg0]);
};

exports.didReceivedNotification = function(arg0, success, error) {
    console.log("FacebookPushCampaign.didReceivedNotification()", arg0);

    exec(success, error, "FacebookPushCampaign", "didReceiveRemoteNotification", [arg0]);
};
