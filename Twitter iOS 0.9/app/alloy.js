Alloy.Globals.navigation = require('navigation');
Alloy.Globals.nexum = require('nexum');
Alloy.Globals.push = require('push');
Alloy.Globals.sessions = require('sessions');
Alloy.Globals.ui = require('ui');

Alloy.Globals.m_flurry = require("com.onecowstanding.flurry");
Alloy.Globals.m_flurry.appVersion = Ti.App.version;
Alloy.Globals.m_flurry.sessionReportsOnPauseEnabled = true;
Alloy.Globals.m_flurry.sessionReportsOnCloseEnabled = true;
Alloy.Globals.m_flurry.startSession(Alloy.CFG.fl_key);