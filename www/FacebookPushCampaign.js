var exec = require('cordova/exec');

exports.register = function(arg0, success, error) {
    exec(success, error, "FacebookPushCampaign", "register", [arg0]);
};
