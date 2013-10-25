exports.loadSessions = function() {
	this.pool = JSON.parse(Ti.App.Properties.getString('module.sessions.pool', '{}'));
	this.current = Ti.App.Properties.getInt('module.sessions.current', 0);
}

exports.saveSessions = function() {
	Ti.App.Properties.setString('module.sessions.pool', JSON.stringify(this.pool));
	Ti.App.Properties.setInt('module.sessions.current', this.current);

	this.pool = JSON.parse(Ti.App.Properties.getString('module.sessions.pool', '{}'));
	this.current = Ti.App.Properties.getInt('module.sessions.current', 0);
}

exports.setCurrentSession = function(ID_SESSION, ACCOUNT_DATA) {
	if (undefined === this.pool[ID_SESSION])
		this.pool[ID_SESSION] = {};

	for (var key in ACCOUNT_DATA) {
		this.pool[ID_SESSION][key] = ACCOUNT_DATA[key];
	}

	this.pool[ID_SESSION]['id_session'] = ID_SESSION;
	this.current = ID_SESSION;
	
	this.saveSessions();
}

exports.getCurrent = function() {
	Ti.API.info(JSON.stringify(this.pool[this.current]));
	return this.pool[this.current];
}

exports.delCurrent = function() {
	if(undefined !== this.pool[this.current]){
		this.pool[this.current] = undefined;
		this.saveSessions();
	}
}