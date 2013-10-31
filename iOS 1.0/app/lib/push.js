exports.register = function() {
	Ti.Network.registerForPushNotifications({
		types : [Titanium.Network.NOTIFICATION_TYPE_BADGE, Titanium.Network.NOTIFICATION_TYPE_ALERT, Titanium.Network.NOTIFICATION_TYPE_SOUND],
		success : function(e) {
			success(e);
		},
		error : function(e) {
			error(e);
		},
		callback : function(e) {
			message(e);
		}
	});
};

function success(e) {
	alert(e.deviceToken);
};

function error(e) {
	alert(e.error);
};

function message(e) {
	alert(JSON.stringify(e.data));
};