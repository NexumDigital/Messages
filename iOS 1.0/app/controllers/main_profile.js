var list_rows = [];
var profiles_data = [];

$.main_profile.start = function() {
	$.prev.page = 0;
	$.next.page = 0;
	$.main_profile.fireEvent('orientationChange');
	profileRequest();
	preloadRows(20);
	setSource('following');
};

$.main_profile.responseHandler = function(PATH, RESPONSE) {
	switch(PATH) {
		case 'profiles/twitter':
			var profile_data = RESPONSE['profile_data'];
			if ('' == profile_data['back'])
				$.back.backgroundColor = Alloy.CFG.ui_color;
			else
				$.back.image = profile_data['back'];
			$.profile_info_picture.image = profile_data['picture'];
			$.profile_info_picture_stroke.image = '/profile/stroke.png';
			$.profile_info_username.text = '@' + profile_data['username'];
			$.profile_info_description.text = profile_data['description'];
			$.profile_info_content.opacity = 1;

			$.following.title = shortCount(profile_data['count_following']) + ' Following';
			$.followers.title = shortCount(profile_data['count_followers']) + ' Followers';

			$.status_text.text = '"' + profile_data['status'] + '"';
			$.status_bird.image = '/profile/bird.png';
			break;
		case 'contacts/twitter/following':
		case 'contacts/twitter/followers':
			$.prev.page = RESPONSE['pagination']['prev'];
			$.next.page = RESPONSE['pagination']['next'];
			profiles_data = RESPONSE['profiles_data'];

			$.list_data.height = (profiles_data.length * 60);

			if (!$.main_profile.started_from_the_bottom)
				$.main_scroll.scrollTo(0, 0);

			var i = 0;
			list_rows = [];
			for (i in profiles_data) {
				$.list_data.fireEvent('add_row', {
					i : i
				});
			}
			break;
	}
};

function profileRequest() {
	Ti.App.fireEvent('nexum', {
		action : 'get_request',
		path : 'profiles/twitter',
		params : {
			identifier : $.main_profile.identifier
		}
	});
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
		path : $.main_profile.request_path,
		params : {
			identifier : $.main_profile.identifier,
			query : $.main_profile.request_query,
			page : $.main_profile.request_page
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
	$.main_profile.request_page = 0;
	$.main_profile.started_from_the_bottom = false;

	if (SOURCE != $.main_profile.selected) {
		switch($.main_profile.selected) {
			case 'following':
				$.following.color = $.following.baseColor;
				break;
			case 'followers':
				$.followers.color = $.following.baseColor;
				break;
		}
	}

	switch(SOURCE) {
		case 'following':
			$.main_profile.request_path = 'contacts/twitter/following';
			$.following.color = $.following.selectedColor;
			break;
		case 'followers':
			$.main_profile.request_path = 'contacts/twitter/followers';
			$.followers.color = $.following.selectedColor;
			break;
	}

	$.main_profile.selected = SOURCE;
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

function followingTap() {
	setSource('following');
};

function followersTap() {
	setSource('followers');
};

function prevTap() {
	$.main_profile.request_page = $.prev.page;
	$.main_profile.started_from_the_bottom = true;
	dataRequest();
};

function nextTap() {
	$.main_profile.request_page = $.next.page;
	$.main_profile.started_from_the_bottom = false;
	dataRequest();
};

function shortCount(COUNT) {
	if (1000000 < COUNT) {
		return (COUNT / 1000000).toFixed(1) + 'M';
	} else if (1000 < COUNT) {
		return (COUNT / 1000).toFixed(1) + 'K';
	} else {
		return COUNT;
	}
}

$.main_profile.addEventListener('orientationChange', function(e) {
	$.profile_info.width = Ti.Platform.displayCaps.platformWidth;
	$.back.width = Ti.Platform.displayCaps.platformWidth;
	$.back_overlay.width = Ti.Platform.displayCaps.platformWidth;
});

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

		if ($.main_profile.started_from_the_bottom) {
			$.main_scroll.scrollToBottom();
		}
	}
});
