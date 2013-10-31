$.row_message.setData = function(ACCOUNT_DATA, PROFILE_DATA, MESSAGE_DATA) {
	$.row_message.identifier = MESSAGE_DATA['identifier'];
	$.message.text = MESSAGE_DATA['text'];
	$.timeago.text = MESSAGE_DATA['timeago'];

	var max_width = Ti.Platform.displayCaps.platformWidth - 110;
	var bubble_width = $.bubble.toImage().width;

	if (max_width < bubble_width) {
		$.bubble.width = max_width;
		bubble_width = max_width;
	}

	if (MESSAGE_DATA['sent']) {
		if (MESSAGE_DATA['sequel']) {
			$.picture.height = 0;
		} else {
			$.picture.image = ACCOUNT_DATA['picture'];
			$.picture.right = 5;
			$.point.image = '/messages/blueright.png';
			$.point.right = 36;
		}
		$.bubble.backgroundColor = '#45d5ff';
		$.bubble.right = 47;
		$.timeago.right = bubble_width + 46;
		$.timeago.textAlign = 'right';
	} else {
		if (MESSAGE_DATA['sequel']) {
			$.picture.height = 0;
		} else {
			$.picture.image = PROFILE_DATA['picture'];
			$.picture.left = 5;
			$.point.image = '/messages/whiteleft.png';
			$.point.left = 36;
		}
		$.bubble.backgroundColor = '#ffffff';
		$.bubble.left = 47;
		$.timeago.left = bubble_width + 46;
		$.timeago.textAlign = 'left';
	}
};