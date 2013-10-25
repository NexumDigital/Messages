$.row_profile.setData = function(PROFILE_DATA) {
	$.row_profile.identifier = PROFILE_DATA['identifier'];
	$.row_profile.view_title = PROFILE_DATA['fullname'];
	$.picture.image = PROFILE_DATA['picture'];
	$.fullname.text = PROFILE_DATA['fullname'];
	$.username.text = '@'+PROFILE_DATA['username'];
};