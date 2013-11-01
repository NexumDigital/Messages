$.row_profile.setData = function(PROFILE_DATA) {
	$.row_profile.action = 'profile';
	$.row_profile.identifier = PROFILE_DATA['identifier'];
	$.row_profile.view_title = PROFILE_DATA['fullname'];
	$.button.identifier = PROFILE_DATA['identifier'];
	$.button.view_title = PROFILE_DATA['username'];
	$.picture.image = PROFILE_DATA['picture'];
	$.fullname.text = PROFILE_DATA['fullname'];
	$.username.text = '@' + PROFILE_DATA['username'];
	if (PROFILE_DATA['follower']) {
		$.button.action = 'chat';
		$.button.backgroundImage = '/rows/chat.png';
		$.button.backgroundSelectedImage = '/rows/chat_tap.png';
	} else {
		$.button.action = 'invite';
		$.button.backgroundImage = '/rows/invite.png';
		$.button.backgroundSelectedImage = '/rows/invite_tap.png';
	}
};
