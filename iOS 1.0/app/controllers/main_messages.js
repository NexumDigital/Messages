var list_rows = [];
var account_data = [];
var profile_data = [];
var messages_data = [];
var prev_sender_id = null;

$.main_messages.start = function() {
	preloadRows(30);
	messagesRequest();
};

$.main_messages.responseHandler = function(PATH, RESPONSE) {
	account_data = RESPONSE['account_data'];
	profile_data = RESPONSE['profile_data'];
	messages_data = RESPONSE['messages_data'];

	var i = 0;
	list_rows = [];
	prev_sender_id = null;
	for (i in messages_data) {
		if (i > (messages_data.length - 20)) {
			messages_data[i]['sequel'] = (prev_sender_id == messages_data[i]['sender_id']) ? true : false;
			$.list_data.fireEvent('add_row', {
				i : i
			});
			prev_sender_id = messages_data[i]['sender_id'];
		}
	};
};

function messagesRequest() {
	$.message_list.removeAllChildren();
	$.loading.height = 50;
	$.loading.show();
	$.list_data.removeAllChildren();

	Ti.App.fireEvent('nexum', {
		action : 'get_request',
		path : 'messages/twitter',
		params : {
			identifier : $.main_messages.identifier
		}
	});
};

function preloadRows(HOW_MANY) {
	var i = list_rows.length;
	do {
		list_rows[i] = Alloy.createController('row_message').getView();
	} while (HOW_MANY > i++);
};

function listTap(e) {

};

function messageFocus() {
	$.message_input.focused = true;

	var keyboard_height = 0;
	if (Ti.Platform.displayCaps.platformHeight > Ti.Platform.displayCaps.platformWidth)
		keyboard_height = 216;
	else
		keyboard_height = 162;

	$.main_scroll.height = Ti.Platform.displayCaps.platformHeight - keyboard_height;
	$.message_bar.bottom = keyboard_height;

	$.main_scroll.scrollToBottom();
};

function messageBlur() {
	$.message_input.focused = false;
	$.main_scroll.height = Ti.UI.FILL;
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

		messages_data.push(new_message);
		$.list_data.fireEvent('add_row', {
			i : (messages_data.length - 1)
		});
		prev_sender_id = messages_data[(messages_data.length - 1)]['sender_id'];

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
	messagesRequest();
});

$.list_data.addEventListener('add_row', function(e) {
	if (undefined == list_rows[e.i])
		list_rows[e.i] = Alloy.createController('row_message').getView();

	list_rows[e.i].setData(account_data, profile_data, messages_data[e.i]);
	$.list_data.add(list_rows[e.i]);

	if ((messages_data.length - 1) == e.i) {
		$.message_list.add($.list_data);

		$.loading.hide();
		$.loading.height = 0;

		$.list_data.height = Ti.UI.SIZE;

		$.main_scroll.scrollToBottom();
	}
});
