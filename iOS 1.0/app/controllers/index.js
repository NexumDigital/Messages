Alloy.Globals.ui.setParent($.index);

Alloy.Globals.sessions.loadSessions();
Alloy.Globals.ui.setSession(Alloy.Globals.sessions.getCurrent());

Ti.App.addEventListener('sessions', function(e) {
	switch(e.action) {
		case 'set_current':
			Alloy.Globals.sessions.setCurrentSession(e.id_session, e.account_data);
			Alloy.Globals.ui.setSession(Alloy.Globals.sessions.getCurrent());
			Alloy.Globals.ui.loginCheck();
			break;
		case 'del_current':
			Alloy.Globals.sessions.delCurrent();
			Alloy.Globals.ui.setSession(Alloy.Globals.sessions.getCurrent());
			Alloy.Globals.ui.loginCheck();
			break;
	};
});

Ti.App.addEventListener('nexum', function(e) {
	switch(e.action) {
		case 'get_request':
			Alloy.Globals.nexum.getRequest(e.path, e.params);
			break;
		case 'post_request':
			Alloy.Globals.nexum.postRequest(e.path, e.params);
			break;
	};
});

Ti.App.addEventListener('navigation', function(e) {
	switch(e.action) {
		case 'open_tab':
			Alloy.Globals.navigation.openTab(e.title, e.page, e.identifier);
			break;
		case 'open_page':
			Alloy.Globals.navigation.openPage(e.title, e.page, e.identifier);
			break;
		case 'data_response':
			Alloy.Globals.navigation.dataResponse(e.path, e.identifier, e.response);
			break;
	};
});

Ti.App.addEventListener('ui', function(e) {
	switch(e.action) {
		case 'login_check':
			Alloy.Globals.ui.loginCheck();
			break;
		case 'main_new':
			Alloy.Globals.ui.mainNew(e.title, e.page, e.identifier);
			break;
		case 'main_tab_set':
			Alloy.Globals.ui.mainTabsSet(e.tab);
			break;
		case 'main_page_response_handler':
			Alloy.Globals.ui.mainPageResponseHandler(e.path, e.response);
			break;
	};
});

Ti.Gesture.addEventListener('orientationchange', function(e) {
	Alloy.Globals.ui.orientationChange();
});

Alloy.Globals.ui.boot();

$.index.open();
