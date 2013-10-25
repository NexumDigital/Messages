$.tabs.selected = null;
$.tabs.session = {};

$.tabs.setIdentifier = function(SESSION) {
	$.tabs.session = SESSION;
};

$.tabs.setTab = function(TAB) {
	switch($.tabs.selected) {
		case 'sponsors':
			$.sponsors.image = '/tabs/icon_badge.png';
			break;
		case 'contacts':
			$.contacts.image = '/tabs/icon_contacts.png';
			break;
		case 'messages':
			$.messages.image = '/tabs/icon_bubble.png';
			break;
		case 'profile':
			$.profile.image = '/tabs/icon_card.png';
			break;
	}
	switch(TAB) {
		case 'sponsors':
			$.sponsors.image = '/tabs/icon_badge_tap.png';
			break;
		case 'contacts':
			$.contacts.image = '/tabs/icon_contacts_tap.png';
			break;
		case 'messages':
			$.messages.image = '/tabs/icon_bubble_tap.png';
			break;
		case 'profile':
			$.profile.image = '/tabs/icon_card_tap.png';
			break;
	}
	$.tabs.selected = TAB;
};

function sponsorsTap() {
	Ti.App.fireEvent('navigation', {
		action : 'open_tab',
		title : 'Top Sponsors',
		page : 'sponsors',
		identifier : $.tabs.session['identifier']
	});
};

function contactsTap() {
	Ti.App.fireEvent('navigation', {
		action : 'open_tab',
		title : 'Contacts',
		page : 'contacts',
		identifier : $.tabs.session['identifier']
	});
};

function messagesTap() {
	Ti.App.fireEvent('navigation', {
		action : 'open_tab',
		title : 'Messages',
		page : 'messages',
		identifier : $.tabs.session['identifier']
	});
};

function profileTap() {
	Ti.App.fireEvent('navigation', {
		action : 'open_tab',
		title : $.tabs.session['fullname'],
		page : 'profile',
		identifier : $.tabs.session['identifier']
	});
};

function profileLongpress() {
	Ti.App.fireEvent('sessions', {
		action : 'del_current'
	});
}