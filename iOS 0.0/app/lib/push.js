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
	Ti.App.fireEvent('nexum', {
		action : 'post_request',
		path : 'accounts/device_token',
		params : {
			device_token : e.deviceToken
		}
	});
};

function error(e) {
	alert(e.error);
};

function message(e) {
	Ti.App.fireEvent('ui', {
		action : 'main_container_push_handler',
		data : e.data
	});
};