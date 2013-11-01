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

Ti.App.addEventListener('push', function(e) {
    switch(e.action) {
        case 'register':
            Alloy.Globals.push.register();
            break;
    };
});

Ti.App.addEventListener('navigation', function(e) {
    switch(e.action) {
        case 'open_tab':
            Alloy.Globals.navigation.openTab(e.title, e.container, e.identifier);
            Alloy.Globals.m_flurry.logPageView();
            break;
        case 'open_container':
            Alloy.Globals.navigation.openContainer(e.title, e.container, e.identifier);
            Alloy.Globals.m_flurry.logPageView();
            break;
        case 'go_back':
            Alloy.Globals.navigation.goBack();
            Alloy.Globals.m_flurry.logPageView();
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
            Alloy.Globals.ui.mainNew(e.navigation, e.showtabs, e.container, e.identifier);
            break;
        case 'main_tab_set':
            Alloy.Globals.ui.mainTabsSet(e.tab);
            break;
        case 'main_container_response_handler':
            Alloy.Globals.ui.mainContainerResponseHandler(e.path, e.response);
            break;
        case 'main_container_push_handler':
            Alloy.Globals.ui.mainContainerPushHandler(e.data);
            break;
    };
});

Ti.App.addEventListener('m_flurry', function(e) {
    switch(e.action) {
        case 'set_user_id':
            Alloy.Globals.m_flurry.setUserId(e.user_id);
            break;
    };
});

Ti.Gesture.addEventListener('orientationchange', function(e) {
    Alloy.Globals.ui.orientationChange();
});

Ti.App.addEventListener('pause', function(e) {
    Ti.UI.iPhone.appBadge = null;
});

Ti.App.addEventListener('resumed', function(e) {

});

if (Ti.Platform.version < 7) {
    $.index.top = -20;
}
Alloy.Globals.ui.setParent($.index);
Alloy.Globals.sessions.loadSessions();
Alloy.Globals.ui.setSession(Alloy.Globals.sessions.getCurrent());
Alloy.Globals.ui.boot();
$.index.open();
