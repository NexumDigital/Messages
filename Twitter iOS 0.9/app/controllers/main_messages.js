var account_data = [];
var profile_data = [];
var messages_data = [];
var table_rows = [];
var prev_sender_id = null;

$.main_messages.start = function() {
	$.message_input.on_focus = false;
	$.messages_table.height = Ti.Platform.displayCaps.platformHeight - 46;
	messagesRequest();
};

$.main_messages.responseHandler = function(PATH, RESPONSE) {
	account_data = RESPONSE['account_data'];
	profile_data = RESPONSE['profile_data'];
	messages_data = RESPONSE['messages_data'];

	var i = 0;
	prev_sender_id = null;
	for (i in messages_data) {
		if (i > (messages_data.length - 20)) {
			messages_data[i]['sequel'] = (prev_sender_id == messages_data[i]['sender_id']) ? true : false;
			$.messages_table.fireEvent('add_row', {
				i : i
			});
			prev_sender_id = messages_data[i]['sender_id'];
		}
	};
};

$.main_messages.pushHandler = function(DATA) {
	messagesRequest();
};

function messagesRequest() {
	Ti.App.fireEvent('nexum', {
		action : 'get_request',
		path : 'messages/twitter',
		params : {
			identifier : $.main_messages.identifier
		}
	});
};

function messageFocus() {
	$.message_input.on_focus = true;

	var keyboard_height = 0;
	if (Ti.Platform.displayCaps.platformHeight > Ti.Platform.displayCaps.platformWidth)
		keyboard_height = 216;
	else
		keyboard_height = 162;

	$.messages_table.height = Ti.Platform.displayCaps.platformHeight - keyboard_height - 46;
	$.message_bar.bottom = keyboard_height;

	$.messages_table.scrollToIndex($.messages_table.data[0].rows.length - 1, {
		animated : false,
		position : Ti.UI.iPhone.TableViewScrollPosition.TOP
	});
};

function messageBlur() {
	$.message_input.on_focus = false;
	$.messages_table.height = Ti.UI.FILL;
	$.message_bar.bottom = 0;
};

function sendTap() {
	var text = $.message_input.value;
	if ('' != text) {
		$.message_input.value = '';

		var new_message = [];
		new_message['identifier'] = $.main_messages.identifier;
		new_message['network'] = account_data['network'];
		new_message['sender_id'] = account_data['identifier'];
		new_message['recipient_id'] = profile_data['network'];
		new_message['created'] = 'now';
		new_message['timeago'] = 'now';
		new_message['text'] = text;
		new_message['sent'] = true;
		new_message['sequel'] = (prev_sender_id == new_message['sender_id']) ? true : false;

		var temp_row = Alloy.createController('row_message').getView();
		temp_row.setData(account_data, profile_data, new_message);
		$.messages_table.appendRow(temp_row);

		$.messages_table.scrollToIndex($.messages_table.data[0].rows.length - 1, {
			animated : false,
			position : Ti.UI.iPhone.TableViewScrollPosition.TOP
		});

		Ti.App.fireEvent('nexum', {
			action : 'post_request',
			path : 'messages/twitter',
			params : {
				identifier : $.main_messages.identifier,
				text : text
			}
		});
	}
};

$.main_messages.addEventListener('orientationChange', function(e) {
	var keyboard_height = 0;
	if ($.message_input.on_focus && Ti.Platform.displayCaps.platformHeight > Ti.Platform.displayCaps.platformWidth)
		keyboard_height = 216;
	else if ($.message_input.on_focus)
		keyboard_height = 162;
		
	$.messages_table.height = Ti.Platform.displayCaps.platformHeight - keyboard_height - 46;
	$.messages_table.scrollToIndex($.messages_table.data[0].rows.length - 1, {
		animated : false,
		position : Ti.UI.iPhone.TableViewScrollPosition.TOP
	});
});

$.messages_table.addEventListener('add_row', function(e) {
	if (undefined == table_rows[e.i])
		table_rows[e.i] = Alloy.createController('row_message').getView();

	table_rows[e.i].setData(account_data, profile_data, messages_data[e.i]);

	if ((messages_data.length - 1) == e.i) {
		var spacer_top = Alloy.createController('row_spacer').getView();
		spacer_top.height = 70;
		$.messages_table.setData([spacer_top].concat(table_rows));
		$.messages_table.scrollToIndex($.messages_table.data[0].rows.length - 1, {
			animated : false,
			position : Ti.UI.iPhone.TableViewScrollPosition.TOP
		});
	}
});
