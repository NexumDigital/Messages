var list_rows = [];
var threads_data = [];

$.main_threads.start = function() {
	preloadRows(20);
	threadsRequest();
};

$.main_threads.responseHandler = function(PATH, RESPONSE) {
	threads_data = RESPONSE['threads_data'];

	$.list_data.height = (threads_data.length * 60);

	var i = 0;
	list_rows = [];
	for (i in threads_data) {
		$.list_data.fireEvent('add_row', {
			i : i
		});
	}
};

$.main_threads.pushHandler = function(DATA) {
	threadsRequest();
};

function threadsRequest() {
	$.thread_list.removeAllChildren();
	$.loading.height = 50;
	$.loading.show();
	$.list_data.removeAllChildren();

	Ti.App.fireEvent('nexum', {
		action : 'get_request',
		path : 'threads/twitter',
		params : {
			identifier : $.main_threads.identifier
		}
	});
};

function preloadRows(HOW_MANY) {
	var i = list_rows.length;
	do {
		list_rows[i] = Alloy.createController('row_thread').getView();
	} while (HOW_MANY > i++);
};

function listTap(e) {
	if (undefined != e.source.identifier) {
		Ti.App.fireEvent('navigation', {
			action : 'open_container',
			title : e.source.view_title,
			container : 'messages',
			identifier : e.source.identifier
		});
	}
};

$.list_data.addEventListener('add_row', function(e) {
	if (undefined == list_rows[e.i])
		list_rows[e.i] = Alloy.createController('row_thread').getView();

	list_rows[e.i].setData(threads_data[e.i]);
	$.list_data.add(list_rows[e.i]);

	if ((threads_data.length - 1) == e.i) {
		$.thread_list.add($.list_data);

		$.loading.hide();
		$.loading.height = 0;
	}
});
