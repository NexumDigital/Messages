$.login.requestLogin = function() {
	showWebview();

	$.twitter.url = Alloy.CFG.nx_endpoint + 'sessions/twitter';
	$.twitter.height = Ti.Platform.displayCaps.platformHeight - 20 - 46;
};

function hideWebview() {
	$.webview.touchEnabled = false;
	$.webview.opacity = 0;
}

function showWebview() {
	$.webview.touchEnabled = true;
	$.webview.opacity = 1;
}

function signinTap() {
	$.login.requestLogin();
}

function closeTap() {
	hideWebview();
}

$.login.addEventListener('orientationChange', function(e) {
	$.twitter.height = Ti.Platform.displayCaps.platformHeight - 20 - 46;
});

$.webview.addEventListener('load', function(e) {
	if (undefined !== e.source.url) {
		var invalid = [''];

		var url = e.source.url;
		var url_vars = {};
		var url_parts = url.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m, key, value) {
			url_vars[key] = value;
		});

		if (-1 != url.indexOf(Alloy.CFG.tw_callback)) {
			hideWebview();

			Ti.App.fireEvent('nexum', {
				action : 'post_request',
				path : 'sessions/twitter',
				params : {
					oauth_token : url_vars['oauth_token'],
					oauth_verifier : url_vars['oauth_verifier'],
					uiid : Ti.Platform.id,
					client : Ti.App.id,
					version : Ti.App.version
				}
			});
		} else if (-1 !== invalid.indexOf(url)) {
			$.login.requestLogin();
		}
	}
});
