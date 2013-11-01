exports.setParent = function(PARENT_WINDOW) {
	this.parent = PARENT_WINDOW;
};

exports.setSession = function(SESSION) {
	this.session = SESSION;
};

exports.loginCheck = function() {
	if (undefined === this.session) {
		this.loginOpen();
	} else {
		this.loginClose();
		this.main.tabs.setSession(this.session);
		Ti.App.fireEvent('nexum', {
			action : 'post_request',
			path : 'sessions',
			params : {
				id_session : this.session['id_session'],
				uiid : Ti.Platform.id
			}
		});
		Ti.App.fireEvent('nexum', {
			action : 'post_request',
			path : 'workers/01',
			params : {}
		});
		Ti.App.fireEvent('push', {
			action : 'register'
		});
	}
};

exports.loginOpen = function() {
	if (null === this.login) {
		this.login = Alloy.createController('login').getView();
		this.parent.add(this.login);
	}
};

exports.loginClose = function() {
	if (null !== this.login) {
		this.parent.remove(this.login);
		this.login = null;
	}
};

exports.mainTabsSet = function(TAB) {
	this.main.tabs.setTab(TAB);
};

exports.mainNew = function(NAVIGATION, SHOWTABS, CONTAINER, IDENTIFIER) {
	if (null !== this.main.container) {
		this.main.remove(this.main.container);
		this.main.container = null;
	}

	this.main.navbar.setNavigation(NAVIGATION);

	if (SHOWTABS)
		this.main.tabs.opacity = 1;
	else
		this.main.tabs.opacity = 0;

	this.main.container = Alloy.createController('main_' + CONTAINER).getView();
	this.main.container.identifier = IDENTIFIER;
	this.main.add(this.main.container);
	this.main.container.start();
};

exports.mainContainerResponseHandler = function(PATH, RESPONSE) {
	this.main.container.responseHandler(PATH, RESPONSE);
};

exports.mainContainerPushHandler = function(DATA) {
	this.main.container.pushHandler(DATA);
};

exports.orientationChange = function() {
	if (null !== this.login)
		this.login.fireEvent('orientationChange');

	if (null !== this.main.container)
		this.main.container.fireEvent('orientationChange');
};

exports.boot = function() {
	this.main = null;
	this.login = null;

	this.main = Alloy.createController('main').getView();
	this.main.navbar = Alloy.createController('navbar').getView();
	this.main.tabs = Alloy.createController('tabs').getView();
	this.main.container = null;
	this.main.add(this.main.navbar);
	this.main.add(this.main.tabs);
	this.parent.add(this.main);

	this.loginCheck();
};
