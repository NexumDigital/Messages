exports.openTab = function(TITLE, CONTAINER, IDENTIFIER) {
	this.breadcrumbs = [];
	this.current = null;

	Ti.App.fireEvent('ui', {
		action : 'main_tab_set',
		tab : CONTAINER
	});

	this.openPage(TITLE, CONTAINER, IDENTIFIER);
};

exports.openPage = function(TITLE, CONTAINER, IDENTIFIER) {
	if(null != this.current){
		this.breadcrumbs.push(this.current);
	}
	
	this.current = {};
	this.current['title'] = TITLE;
	this.current['container'] = CONTAINER;
	this.current['identifier'] = IDENTIFIER;

	var left = '';
	if (0 < this.breadcrumbs.length)
		left = 'back';

	Ti.App.fireEvent('ui', {
		action : 'main_new',
		navigation : {
			left : left,
			title : this.current['title']
		},
		container : this.current['container'],
		identifier : this.current['identifier']
	});

	
};

exports.goBack = function() {
	this.current = this.breadcrumbs.pop();

	var left = '';
	if (0 < this.breadcrumbs.length)
		left = 'back';

	Ti.App.fireEvent('ui', {
		action : 'main_new',
		navigation : {
			left : left,
			title : this.current['title']
		},
		container : this.current['container'],
		identifier : this.current['identifier']
	});
};

exports.dataResponse = function(PATH, IDENTIFIER, RESPONSE) {
	var containerPathMapper = {};

	containerPathMapper['contacts'] = {
		'contacts/twitter/search' : true,
		'contacts/twitter/followers' : true,
		'contacts/twitter/following' : true
	};

	containerPathMapper['profile'] = {
		'contacts/twitter/followers' : true,
		'contacts/twitter/following' : true,
		'profiles/twitter' : true
	};

	containerPathMapper['threads'] = {
		'threads/twitter' : true
	};

	if (containerPathMapper[this.current['container']][PATH] && IDENTIFIER == this.current['identifier']) {
		Ti.App.fireEvent('ui', {
			action : 'main_container_response_handler',
			path : PATH,
			response : RESPONSE
		});
	};
};
