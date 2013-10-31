exports.getRequest = function(PATH, PARAMS) {
	httpGet(PATH, PARAMS);
};

exports.postRequest = function(PATH, PARAMS) {
	httpPost(PATH, PARAMS);
};

function httpGet(PATH, PARAMS) {
	var httpClient = Ti.Network.createHTTPClient();
	var params = '?';

	httpClient.onload = function(e) {
		Ti.API.info(this.responseText);
		httpGettHandler(PATH, PARAMS, JSON.parse(this.responseText));
	};

	httpClient.timeout = Alloy.CFG.nx_timeout;

	httpClient.onerror = function(e) {
		httpErrorHandler('GET', PATH, PARAMS, this.responseText);
	};

	for (var key in PARAMS) {
		params += '&' + key + '=' + PARAMS[key];
	}

	httpClient.open('GET', Alloy.CFG.nx_endpoint + PATH + params);

	httpClient.send();
};

function httpPost(PATH, PARAMS) {
	var httpClient = Ti.Network.createHTTPClient();

	httpClient.onload = function(e) {
		httpPostHandler(PATH, PARAMS, JSON.parse(this.responseText));
	};

	httpClient.timeout = Alloy.CFG.nx_timeout;

	httpClient.onerror = function(e) {
		httpErrorHandler('POST', PATH, PARAMS, this.responseText);
	};

	httpClient.open('POST', Alloy.CFG.nx_endpoint + PATH);

	httpClient.send(PARAMS);
};

function httpGettHandler(PATH, PARAMS, RESPONSE) {
	if (RESPONSE['success']) {
		switch(PATH) {
			default :
				Ti.App.fireEvent('navigation', {
					action : 'data_response',
					path : PATH,
					identifier : PARAMS['identifier'],
					response : RESPONSE
				});
				break;
		}
	} else {
		switch(PATH) {
			default:
				alert('[ERROR] ' + RESPONSE['message']);
				break;
		}
	}

	Ti.API.info('Path: ' + PATH);
	Ti.API.info('Params: ' + PARAMS);
	Ti.API.info('Response: ' + RESPONSE);
};

function httpPostHandler(PATH, PARAMS, RESPONSE) {
	if (RESPONSE['success']) {
		switch(PATH) {
			case 'messages/twitter':
				break;
			case 'sessions':
				Ti.App.fireEvent('navigation', {
					action : 'open_tab',
					title : 'Inbox',
					container : 'threads',
					identifier : RESPONSE['account_data']['identifier']
				});
				break;
			case 'sessions/twitter':
				Ti.App.fireEvent('sessions', {
					action : 'set_current',
					id_session : RESPONSE['id_session'],
					account_data : RESPONSE['account_data']
				});
				break;
			default:
				alert(RESPONSE['message']);
				break;
		}
	} else {
		switch(PATH) {
			case 'sessions':
				Ti.App.fireEvent('sessions', {
					action : 'del_current'
				});
				break;
			default:
				alert('[ERROR] ' + RESPONSE['message']);
				break;
		}
	}

	Ti.API.info('Path: ' + PATH);
	Ti.API.info('Params: ' + PARAMS);
	Ti.API.info('Response: ' + RESPONSE);
};

function httpErrorHandler(METHOD, PATH, PARAMS, RESPONSE) {
	Ti.API.info('Method: ' + METHOD);
	Ti.API.info('Path: ' + PATH);
	Ti.API.info('Params: ' + JSON.stringify(PARAMS));
	Ti.API.info('Response: ' + RESPONSE);
};