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
			action : 'post_sessions',
			id_session : this.session['id_session'],
			uiid : Ti.Platform.id
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

exports.mainNew = function(TITLE, PAGE, IDENTIFIER) {
	if (null !== this.main.page) {
		this.main.remove(this.main.page);
		this.main.page = null;
	}

	this.main.navbar.setTitle(TITLE);

	this.main.page = Alloy.createController('main_' + PAGE).getView();
	this.main.page.identifier = IDENTIFIER;
	this.main.add(this.main.page);
	this.main.page.start();
};

exports.mainPageResponseHandler = function(PATH, RESPONSE) {
	this.main.page.responseHandler(PATH, RESPONSE);
};

exports.orientationChange = function() {
	if (null !== this.login)
		this.login.fireEvent('orientationChange');
		
	if (null !== this.main.page)
		this.main.page.fireEvent('orientationChange');
};

exports.boot = function() {
	this.accounts = null;
	this.main = null;
	this.login = null;

	this.accounts = Alloy.createController('accounts').getView();
	this.parent.add(this.accounts);

	this.main = Alloy.createController('main').getView();
	this.main.navbar = Alloy.createController('navbar').getView();
	this.main.tabs = Alloy.createController('tabs').getView();
	this.main.page = null;
	this.main.add(this.main.navbar);
	this.main.add(this.main.tabs);
	this.parent.add(this.main);

	this.loginCheck();
};
