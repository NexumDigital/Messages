exports.openTab = function(TITLE, PAGE, IDENTIFIER) {
	this.breadcrumbs = [];

	if (undefined === this.current) {
		this.current = {};
	}

	Ti.App.fireEvent('ui', {
		action : 'main_tab_set',
		tab : PAGE
	});

	this.openPage(TITLE, PAGE, IDENTIFIER);
};

exports.openPage = function(TITLE, PAGE, IDENTIFIER) {
	this.current = {};
	this.current['title'] = TITLE;
	this.current['page'] = PAGE;
	this.current['identifier'] = IDENTIFIER;

	Ti.App.fireEvent('ui', {
		action : 'main_new',
		title : TITLE,
		page : PAGE,
		identifier : IDENTIFIER
	});

	this.breadcrumbs.push(this.current);
};

exports.dataResponse = function(PATH, IDENTIFIER, RESPONSE) {
	var pagePathMapper = {};

	pagePathMapper['contacts'] = {
		'contacts/twitter/search' : true,
		'contacts/twitter/followers' : true,
		'contacts/twitter/following' : true
	};

	pagePathMapper['profile'] = {
		'contacts/twitter/followers' : true,
		'contacts/twitter/following' : true,
		'profiles/twitter' : true
	};

	if (pagePathMapper[this.current['page']][PATH] && IDENTIFIER == this.current['identifier']) {
		Ti.App.fireEvent('ui', {
			action : 'main_page_response_handler',
			path : PATH,
			response : RESPONSE
		});
	};
};
