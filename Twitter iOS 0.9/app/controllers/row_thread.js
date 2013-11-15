$.row_thread.setData = function(THREAD_DATA) {
	if (THREAD_DATA['opened'])
		$.indicator.backgroundColor = '#ededea';
	else
		$.indicator.backgroundColor = '#45d5ff';
		
	$.row_thread.identifier = THREAD_DATA['identifier'];
	$.row_thread.view_title = THREAD_DATA['title'];
	$.picture.image = THREAD_DATA['picture'];
	$.title.text = THREAD_DATA['title'];
	$.preview.text = THREAD_DATA['preview'];
	$.timeago.text = THREAD_DATA['timeago'];
};