$.navbar.setNavigation = function(NAVIGATION) {
	$.title.text = NAVIGATION.title;
	switch(NAVIGATION.left) {
		case 'back':
			$.left.action = 'back';
			$.left.backgroundImage = '/navbar/back.png';
			$.left.backgroundSelectedImage = '/navbar/back_tap.png';
			break;
		case '':
			$.left.action = '';
			$.left.backgroundImage = '';
			$.left.backgroundSelectedImage = '';
			break;
	}
};

function leftTap() {
	switch($.left.action) {
		case 'back':
			Ti.App.fireEvent('navigation', {
				action : 'go_back'
			});
			break;
	}
}
