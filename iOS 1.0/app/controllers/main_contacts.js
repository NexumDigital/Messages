var list_rows = [];
var profiles_data = [];

$.main_contacts.start = function() {
	$.search_input.focused = false;
	$.prev.page = 0;
	$.next.page = 0;
	preloadRows(20);
	setSource('following');
};

$.main_contacts.responseHandler = function(PATH, RESPONSE) {
	$.prev.page = RESPONSE['pagination']['prev'];
	$.next.page = RESPONSE['pagination']['next'];
	profiles_data = RESPONSE['profiles_data'];
	
	$.list_data.height = (profiles_data.length * 60);

	if ($.main_contacts.started_from_the_bottom)
		$.main_scroll.scrollTo(0, 0);

	var i = 0;
	list_rows = [];
	for (i in profiles_data) {
		$.list_data.fireEvent('add_row', {
			i : i
		});
	}
};

function dataRequest() {
	$.profile_list.removeAllChildren();
	$.prev.height = 0;
	$.next.height = 0;
	$.loading.height = 50;
	$.loading.show();
	$.list_data.removeAllChildren();

	Ti.App.fireEvent('nexum', {
		action : 'get_request',
		path : $.main_contacts.request_path,
		params : {
			identifier : $.main_contacts.identifier,
			query : $.main_contacts.request_query,
			page : $.main_contacts.request_page
		}
	});
};

function preloadRows(HOW_MANY) {
	var i = list_rows.length;
	do {
		list_rows[i] = Alloy.createController('row_profile').getView();
	} while (HOW_MANY > i++);
};

function setSource(SOURCE) {
	$.main_contacts.request_page = 0;
	$.main_contacts.started_from_the_bottom = false;

	if (SOURCE != $.main_contacts.selected) {
		switch($.main_contacts.selected) {
			case 'following':
				$.following.color = $.following.baseColor;
				break;
			case 'followers':
				$.followers.color = $.following.baseColor;
				break;
		}
	}

	switch(SOURCE) {
		case 'search':
			$.main_contacts.request_query = ($.search_input.value.replace(/[^a-zA-Z0-9\_]/g, '')).toLowerCase();
			$.main_contacts.request_path = 'contacts/twitter/search';
			break;
		case 'following':
			$.main_contacts.request_path = 'contacts/twitter/following';
			$.following.color = $.following.selectedColor;
			break;
		case 'followers':
			$.main_contacts.request_path = 'contacts/twitter/followers';
			$.followers.color = $.following.selectedColor;
			break;
	}

	$.main_contacts.selected = SOURCE;
	dataRequest();
};

function listTap(e) {
	if (undefined != e.source.identifier) {
		Ti.App.fireEvent('navigation', {
			action : 'open_container',
			title : e.source.view_title,
			container : 'profile',
			identifier : e.source.identifier
		});
	}
};

function searchClear() {
	$.search_input.value = '';
	$.search_input.blur();
};

function searchAction() {
	if ($.search_input.focused) {
		searchClear();
	}
};

function searchFocus() {
	$.search_input.focused = true;
	$.search_action.image = '/contacts/search_cancel.png';
	$.main_scroll.scrollTo(0, 0);
};

function searchBlur() {
	$.search_input.focused = false;
	$.search_action.image = '/contacts/search_magnifier.png';
	if ('search' != $.main_contacts.selected)
		$.main_scroll.scrollTo(0, 49);
};

function searchReturn() {
	var query = ($.search_input.value.replace(/[^a-zA-Z0-9\_]/g, '')).toLowerCase();
	if ('' !== query) {
		setSource('search');
	}
};

function followingTap() {
	searchClear();
	setSource('following');
};

function followersTap() {
	searchClear();
	setSource('followers');
};

function prevTap() {
	$.main_contacts.request_page = $.prev.page;
	$.main_contacts.started_from_the_bottom = true;
	dataRequest();
};

function nextTap() {
	$.main_contacts.request_page = $.next.page;
	$.main_contacts.started_from_the_bottom = false;
	dataRequest();
};

$.list_data.addEventListener('add_row', function(e) {
	if (undefined == list_rows[e.i])
		list_rows[e.i] = Alloy.createController('row_profile').getView();

	list_rows[e.i].setData(profiles_data[e.i]);
	$.list_data.add(list_rows[e.i]);

	if ((profiles_data.length - 1) == e.i) {
		$.profile_list.add($.list_data);

		$.loading.hide();
		$.loading.height = 0;

		if (null != $.prev.page) {
			$.prev.height = 40;
		}
		if (null != $.next.page) {
			$.next.height = 40;
		}

		if ($.main_contacts.started_from_the_bottom) {
			$.main_scroll.scrollToBottom();
		}
	}
});
