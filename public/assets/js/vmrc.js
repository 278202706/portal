/* **********************************************************
 * Copyright (C) 2011 VMware, Inc.
 * All Rights Reserved
 * **********************************************************/

/*
 * vmrc-embed-example.js --
 *
 *      This file implements a set of JavaScript functions which, in
 *      conjunction with the vmrc-embed-example.html sample page,
 *      demonstrate how to the VMRC API to embed a VMware Remote Console in a
 *      web page.
 */

/*
 * Globals
 */

var mimetype = "application/x-vmware-remote-console-2012";
var clsid = "CLSID:4AEA1010-0A0C-405E-9B74-767FC8A998CB";

var isIE = /MSIE (\d+\.\d+);/.test(navigator.userAgent);
var vmrc = null;

/*
 * ----------------------------------------------------------------------------
 * 
 * $get() $getV() --
 * 
 * Helper functions to simply looking up document elements and their values.
 * 
 * Results: Document element, value
 * 
 * ----------------------------------------------------------------------------
 */

function $get(id) {
	return document.getElementById(id);
}

function $getV(id) {
	return $get(id).value;
}

/*
 * ----------------------------------------------------------------------------
 * 
 * log(msg) --
 * 
 * Print message to log box.
 * 
 * Results: None.
 * 
 * Side effects: Appends message text to log box.
 * 
 * ----------------------------------------------------------------------------
 */

function log(text) {
	$get('msgBox').innerHTML += "<br />" + text;
	$get('msgBox').scrollTop = $get('msgBox').scrollHeight;
}

/*
 * ----------------------------------------------------------------------------
 * 
 * attachEventHandler(eventName, handler) --
 * 
 * Wrapper function to hide the browser-specific differences in binding handlers
 * to events.
 * 
 * Results: None
 * 
 * ----------------------------------------------------------------------------
 */

function attachEventHandler(eventName, handler) {
	if (isIE) {
		vmrc.attachEvent(eventName, handler);
	} else {
		vmrc[eventName] = handler;
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * addToModeMask() -- addToDeviceMask() --
 * 
 * Invoked by the sample page in response to "+" button clicks. These helpers
 * manage global vars that maintain a mask value.
 * 
 * TODO: this was a quick hack and could be much nicer. Ah well, it works.
 * 
 * Results: None.
 * 
 * Side effects: updates global mask variable hides and removes html elements
 * 
 * ----------------------------------------------------------------------------
 */

var modeMask = {
	id : "modeMask",
	value : 0
};
var deviceMask = {
	id : "deviceMask",
	value : 0
};

function addToMask(mask, val, select, ix, div) {
	var name = select.options[ix].text;
	var id = "Mode_" + name;
	if ($get(id)) {
		return;
	}

	var htm = '<div id="%id" style="padding: 2px; border: 1px solid; background: lightblue">'
			+ '<span '
			+ 'style="cursor: pointer; padding: 0px 2px 0px 2px; '
			+ 'border: 1px dotted black; background: #ef6f71;" '
			+ 'onclick=\'removeFromMask(%mask, %val, "%select", "%id", %ix);\'>'
			+ 'X' + '</span>' + ' %name' + '</div>';
	htm = htm.replace(/%mask/g, mask.id);
	htm = htm.replace(/%val/g, val);
	htm = htm.replace(/%select/g, select.id);
	htm = htm.replace(/%id/g, id);
	htm = htm.replace(/%ix/g, ix);
	htm = htm.replace(/%name/g, name);
	div.innerHTML += htm;

	select.options[ix].style.display = 'none';
	select.selectedIndex = -1;

	mask.value |= val;
}

function removeFromMask(mask, val, selectId, id, ix) {
	var select = $get(selectId);
	var obj = $get(id);
	obj.style.display = 'none';
	obj.id = 'dead';

	mask.value &= ~parseInt(val);

	select.options[ix].style.display = 'block';
	select.selectedIndex = -1;
}

function addToModeMask() {
	var select = $get('VMRC_Mode');
	var ix = select.selectedIndex;
	if (ix == -1) {
		return;
	}
	var val = parseInt(select.value);
	var div = $get('mode_mask');
	addToMask(modeMask, val, select, ix, div);
}

function addToDeviceMask() {
	var select = $get('device_types');
	var ix = select.selectedIndex;
	if (ix == -1) {
		return;
	}
	var name = select.options[ix].text;

	var val = vmrc.DeviceType[name];
	var div = $get('devices_mask');
	addToMask(deviceMask, val, select, ix, div);
}

/*
 * ----------------------------------------------------------------------------
 * 
 * onConnectionStateChangeHandler(cs, host, vmId, userRequested, reason) --
 * onScreenSizeChangeHandler(width, height) -- onFullscreenChangeHandler(fs) --
 * onGrabStateChangeHandler(gs) -- onMessageHandler(type, essage) --
 * onDeviceStateChangeHandler(ds, host, vm, virtualKey, physicalKey, req,
 * reason) -- onVirtualDevicesChangeHandler() --
 * onPhysicalClientDevicesChangeHandler() --
 * 
 * Event handlers for the corresponding VMRC events generated by the plugin.
 * 
 * Results: None.
 * 
 * Side effects: Display log message boxes with specific event details.
 * 
 * ----------------------------------------------------------------------------
 */

function onConnectionStateChangeHandler(cs, host, datacenter, vmId,
		userRequested, reason) {
	// log('onConnectionStateChange - connectionState: ' + cs + ', host: ' +
	// host
	// + ', datacenter: ' + datacenter + ', vmId: ' + vmId
	// + ', userRequested: ' + userRequested + ', reason: ' + reason);
	log('->VMRC连接状态变更！当前状态【' + cs + ', host: ' + host + ', datacenter: '
			+ datacenter + ', vmId: ' + vmId + ', userRequested: '
			+ userRequested + ', reason: ' + reason + '】');
}

function onScreenSizeChangeHandler(width, height) {
	// log('onScreenSizeChange - width: ' + width + ', height: ' + height);
	log('->VMRC窗口状态变更！当前状态【width: ' + width + ', height: ' + height + '】');
}

function onFullscreenChangeHandler(fs) {
	// log('onFullscreenChange - fullscreen: ' + fs);
	log('->VMRC窗口状态变更！当前状态【fullscreen: ' + fs + '】');
}

function onGrabStateChangeHandler(grabState) {
	var grabStateStr = grabState;
	switch (parseInt(grabState)) {
	case vmrc.GrabState.GS_UNGRABBED_HARD:
		grabStateStr = "ungrabbed hard";
		break;
	case vmrc.GrabState.GS_UNGRABBED_SOFT:
		grabStateStr = "ungrabbed soft";
		break;
	case vmrc.GrabState.GS_GRABBED:
		grabStateStr = "grabbed";
		break;
	default:
		log('Could not match grabState: ' + grabState);
		break;
	}
	// log('onGrabStateChange - grabState: ' + grabStateStr);
	log('->VMRC控制焦点状态变更！当前状态【grabState: ' + grabStateStr + '】');
}

function onMessageHandler(msgType, message) {
	log('onMessage - msgType: ' + msgType + ', message: ' + message);
}

function onDeviceStateChangeHandler(deviceState, hostname, datacenter, vmID,
		virtualDeviceKey, physicalClientDeviceKey, userRequested, reason) {
	log('onDeviceStateChange - deviceState: ' + deviceState + ', hostname: '
			+ hostname + ", datacenter: " + datacenter + ', vmID: ' + vmID
			+ ', virtualDeviceKey: ' + virtualDeviceKey
			+ ', physicalClientDeviceKey: ' + physicalClientDeviceKey
			+ ', userRequested: ' + userRequested + ', reason: ' + reason);
}

function onVirtualDevicesChangeHandler() {
	log('onVirtualDevicesChange');
}

function onPhysicalClientDevicesChangeHandler() {
	log('onPhysicalClientDevicesChange');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * createPluginObject(parentId) --
 * 
 * Creates a VMRC plugin object instance and sets its parent id to the specified
 * document element id.
 * 
 * Results: VMRC plugin object instance on success, null on failure.
 * 
 * Side effects: Initializes/loads VMRC native plugin.
 * 
 * 
 * ----------------------------------------------------------------------------
 */

function createPluginObject(parentId) {
	var obj = document.createElement("object");
	obj.setAttribute("id", "vmrc");
	obj.setAttribute("height", "100%");
	obj.setAttribute("width", "100%");
	if (isIE) {
		obj.setAttribute("classid", clsid);
	} else {
		obj.setAttribute("type", mimetype);
	}
	$get(parentId).appendChild(obj);
	return $get('vmrc');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * init() --
 * 
 * Performs post-plugin-loading initialization. Invoked by the web page sample
 * at <body> onload time.
 * 
 * Results: None.
 * 
 * Side effects: Attaches event handlers to corresponding plugin events.
 * Populates vmrc plugin object with friendlier browser-independent constant
 * name/value mappings. Populates sample page form listboxes with corresponding
 * enum names/values.
 * 
 * ----------------------------------------------------------------------------
 */

$(function() {
	vmrc = createPluginObject("pluginPanel");
	if (vmrc == null) {
		return;
	}

	attachEventHandler("onConnectionStateChange",
			onConnectionStateChangeHandler);
	attachEventHandler("onScreenSizeChange", onScreenSizeChangeHandler);
	attachEventHandler("onFullscreenChange", onFullscreenChangeHandler);
	attachEventHandler("onGrabStateChange", onGrabStateChangeHandler);
	attachEventHandler("onMessage", onMessageHandler);
	attachEventHandler("onDeviceStateChange", onDeviceStateChangeHandler);
	attachEventHandler("onVirtualDevicesChange", onVirtualDevicesChangeHandler);
	attachEventHandler("onPhysicalClientDevicesChange",
			onPhysicalClientDevicesChangeHandler);

	var enumDefs = [ 'VMRC_ConnectionState', 'VMRC_DeviceBacking',
			'VMRC_DeviceState', 'VMRC_DeviceType', 'VMRC_GrabState',
			'VMRC_MessageMode', 'VMRC_MessageType', 'VMRC_Mode',
			'VMRC_USBDeviceFamily', 'VMRC_USBDeviceSpeed' ];

	for ( var e in enumDefs) {
		var propertyName = enumDefs[e];
		var keys = new Array();
		var value = "";
		var shortName = propertyName.replace(/VMRC_/g, "");
		var shortKey = "";

		vmrc[shortName] = new Object();

		if (isIE) {
			var vbkeys = new VBArray(vmrc[propertyName].Keys());
			for (k = 0; k <= vbkeys.ubound(1); k++) {
				key = vbkeys.getItem(k);
				keys.push(key);
			}
		} else {
			for ( var k in vmrc[propertyName]) {
				keys.push(k);
			}
		}

		for ( var i = 0; i < keys.length; i++) {
			key = keys[i];
			if (isIE) {
				value = vmrc[propertyName](key);
			} else {
				value = vmrc[propertyName][key];
			}

			shortkey = key.replace(/VMRC_/g, "");
			vmrc[shortName][shortkey] = value;

			if ($get(propertyName)) {
				var opt = new Option(shortkey, value);
				opt.id = shortkey;
				$get(propertyName)[$get(propertyName).length] = opt;
			}
		}
	}

	getVersion();
	isReadyToStart();
	startup();
	connect();
});
/*
 * ----------------------------------------------------------------------------
 * 
 * getVersion() --
 * 
 * Helper functions which map through to corresponding version query functions
 * exported by the plugin.
 * 
 * Results: None.
 * 
 * Side effects: Display result of plugin calls in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function getVersion() {
	// log('getVersion returned "' + vmrc.getVersion() + '"');
	log('->获取版本信息成功！Vcenter服务器版本【' + vmrc.getVersion() + '】');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * isReadyToStart() --
 * 
 * Invoked by the sample page in response to clicking the 'isReadyToStart'
 * button. Checks with the vmrc plugin if it is capable of starting up a new
 * instance of vmrc.
 * 
 * Results: None.
 * 
 * Side effects: Display result of plugin calls in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function isReadyToStart() {
	// log('isReadyToStart returned "' + vmrc.isReadyToStart() + '"');
	log('->VMRC插件启动检测成功！是否可以启动？【' + vmrc.isReadyToStart() + '】');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * startup() --
 * 
 * Invoked by the sample page in response to clicking the 'startup' button.
 * Calls the vmrc.startup() method with the appropriate parameters and displays
 * the result in an log box.
 * 
 * Results: None.
 * 
 * Side effects: Invokes plugin startup() method which executes native code to
 * initialize a VMRC instance and start a peer vmware-vmrc process. Displays
 * results in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function startup() {
	var modes = 6;// = modeMask.value;
	var msgMode = 1;// = parseInt($getV('VMRC_MessageMode'));
	var advancedConfig = '';// = $getV('startup_advanced');
	// var modes = modeMask.value;
	// var msgMode = parseInt($getV('VMRC_MessageMode'));
	// var advancedConfig = $getV('startup_advanced');

	// log('starting VMRC instance: modes: ' + modes + ', messages: ' +
	// msgMode);
	log('->VMRC插件开始启动！【Modes: ' + modes + ', Messages: ' + msgMode + '】');

	if (advancedConfig) {
		// log('VMRC using advanced config "' + advancedConfig + '"');
	}

	try {
		var ret = vmrc.startup(modes, msgMode, advancedConfig);
		log('->VMRC插件启动成功！返回结果【' + ret + '】');
	} catch (err) {
		log('->VMRC插件启动失败！失败原因【 ' + err + '】');
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * shutdown() --
 * 
 * Invoked by the sample page when clicking the 'shutdown' button. Shuts down
 * the vmrc plugin instance.
 * 
 * Results: None.
 * 
 * Side effects: Invokes plugin shutdown() method, stops corresponding
 * vmware-vmrc peer process. Displays results in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function shutdown() {
	try {
		vmrc.shutdown();
	} catch (err) {
		log('shutdown call failed: ' + err.description);
		return;
	}
	log('shutdown call returned successfully');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * connect() --
 * 
 * Invoked by the sample page when clicking the 'connect' button. Initiates VMRC
 * connection with specified parameters.
 * 
 * Results: None.
 * 
 * Side effects: Invokes plugin connect() method, passing in the specified
 * parameters from the sample page. Displays return value in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function connect() {
	var host = $getV('connect_host');
	var thumb = '';// =$getV('connect_thumbprint');
	var allowSSLErrors = true;// =$get('connect_allow_ssl_errors').checked;
	var ticket = $getV('connect_ticket');
	var user = '';// =$getV('connect_username');
	var pass = '';// =$getV('connect_password');
	var vmid = $getV('connect_vmid');
	var datacenter = '';// = $getV('connect_datacenter');
	var vmPath = '';// =$getV('connect_vmpath');

	try {
		var ret = vmrc.connect(host, thumb, allowSSLErrors, ticket, user, pass,
				vmid, datacenter, vmPath);
		log('->VMRC连接成功！');
	} catch (err) {
		alert("->VMRC连接失败！\n失败原因：" + err);
		log('->VMRC连接失败！失败原因【 ' + err + '】');
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * disconnect() --
 * 
 * Invoked by sample page when clicking 'disconnect' button. Passes through to
 * plugin disconnect() method.
 * 
 * Results: Return value of plugin disconnect() call.
 * 
 * Side effects: Invokes plugin disconnect() method, terminates any related
 * connection-specific child processes.
 * 
 * ----------------------------------------------------------------------------
 */

function disconnect() {
	try {
		vmrc.disconnect();
		log('->VMRC断开连接成功！');
	} catch (err) {
		log('->VMRC断开连接失败，失败原因【' + err + '】');
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * getConnectionState() -- getFullscreen() -- screenWidth() -- screenHeight() --
 * getGrabState() --
 * 
 * Simple getter methods to retrieve corresponding state values from plugin
 * object.
 * 
 * Results: Value of requested parameter.
 * 
 * Side effects: None.
 * 
 * ----------------------------------------------------------------------------
 */

function getConnectionState() {
	try {
		var state = vmrc.getConnectionState();
		if (state == vmrc.ConnectionState.CS_CONNECTED) {
			log(state + ' == connected');
		} else if (state == vmrc.ConnectionState.CS_DISCONNECTED) {
			log(state + ' == disconnected');
		} else {
			log("Unknown state: " + state);
		}
		log('getConnectionState returned "' + state + '"');
	} catch (err) {
		log('getConnectionState failed: ' + err);
	}
}

function getFullscreen() {
	try {
		log('getFullscreen returned "' + vmrc.getFullscreen() + '"');
	} catch (err) {
		log('getFullscreen failed: ' + err);
	}
}

function screenWidth() {
	try {
		log('screenWidth returned "' + vmrc.screenWidth() + '"');
	} catch (err) {
		log('screenWidth failed: ' + err);
	}
}

function screenHeight() {
	try {
		log('screenHeight returned "' + vmrc.screenHeight() + '"');
	} catch (err) {
		log('screenHeight failed: ' + err);
	}
}

function getGrabState() {
	try {
		log('getGrabState returned "' + vmrc.getGrabState() + '"');
	} catch (err) {
		log('getGrabState failed: ' + err);
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * sendCAD --
 * 
 * Invoked by the sample page in response to sendCAD button click.
 * 
 * Results: None.
 * 
 * Side effects: Tells the plugin to send a Control-Alt-Delete key sequence to
 * the remote VM. Displays result of plugin sendCAD() invocation in log box.
 * 
 * ----------------------------------------------------------------------------
 */

function sendCAD() {
	try {
		vmrc.sendCAD();
	} catch (err) {
		log('sendCAD call failed: ' + err.description);
		return;
	}
	log('sendCAD call returned successfully');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * setFullscreen() --
 * 
 * Invoked by sample page in response to setFullscreen button click.
 * 
 * Results: None.
 * 
 * Side effects: Instructs the current plugin instance to switch in or out of
 * fullscreen mode.
 * 
 * ----------------------------------------------------------------------------
 */

function setFullscreen() {
	var fs = true;
	// var fs = $get('fs_value').checked;
	try {
		vmrc.setFullscreen(fs);
	} catch (err) {
		// log('setFullscreen call failed: ' + err.description);
		log('->VMRC窗口全屏设置失败！失败原因【 ' + err.description + '】');
		return;
	}
	// log('setFullscreen call returned successfully');
	log('->VMRC窗口全屏设置成功！');

}

/*
 * ----------------------------------------------------------------------------
 * 
 * setScreenSize() --
 * 
 * Invoked by sample page in response to setScreenSize button click.
 * 
 * Results: None.
 * 
 * Side effects: Instructs the current plugin instance to set the resolution of
 * the guest operating system's console.
 * 
 * ----------------------------------------------------------------------------
 */

function setScreenSize() {
	var width = parseInt($getV('screen_width'));
	var height = parseInt($getV('screen_height'));

	try {
		vmrc.setScreenSize(width, height);
	} catch (err) {
		log('setScreenSize call failed: ' + err.description);
		return;
	}
	log('setScreenSize call returned successfully');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * grabInput() -- ungrabInput() --
 * 
 * Invoked by sample page in response to [un]grabInput button click.
 * 
 * Results: None.
 * 
 * Side effects: Instructs the current plugin instance to [un]grab
 * keyboard/mouse input to/from the guest operating system's console.
 * 
 * ----------------------------------------------------------------------------
 */

function grabInput() {
	try {
		vmrc.grabInput();
	} catch (err) {
		log('grabInput call failed: ' + err.description);
		return;
	}
	log('grabInput call returned successfully');
}

function ungrabInput() {
	try {
		vmrc.ungrabInput();
	} catch (err) {
		log('ungrabInput call failed: ' + err.description);
		return;
	}
	log('ungrabInput call returned successfully');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * setInputRelease() --
 * 
 * Invoked by sample page in response to setInputRelease button click.
 * 
 * Results: None.
 * 
 * Side effects: Instructs the current plugin instance [not] to force the
 * release of the keyboard/mouse input from the guest operating system's
 * console.
 * 
 * ----------------------------------------------------------------------------
 */

function setInputRelease() {
	var release = $get('input_value').checked;

	try {
		vmrc.setInputRelease(release);
	} catch (err) {
		log('setInputRelease call failed: ' + err.description);
		return;
	}
	log('setInputRelease call returned successfully');
}

/*
 * ----------------------------------------------------------------------------
 * 
 * getVirtualDevices() -- getVirtualDeviceDetails() --
 * 
 * Invoked by the sample page in response to corresponding button clicks. button
 * click.
 * 
 * Results: None.
 * 
 * Side effects: Displays results of plugin calls with specified parameters in
 * an log box.
 * 
 * ----------------------------------------------------------------------------
 */

function getVirtualDevices() {
	var mask = deviceMask.value;

	try {
		if (isIE) {
			var devices = new VBArray(vmrc.getVirtualDevices(mask)).toArray();
			log('getVirtualDevices returned "' + devices + '"');
		} else {
			log('getVirtualDevices returned "' + vmrc.getVirtualDevices(mask)
					+ '"');
		}
	} catch (err) {
		log('getVirtualDevices failed: ' + err);
	}
}

function getVirtualDeviceDetails() {
	var key = $getV('virtual_device_key');

	try {
		var keys = [ 'key', 'type', 'state', 'connectedByMe', 'name',
				'clientBacking', 'backing', 'backingKey', 'hostName' ];
		var details = vmrc.getVirtualDeviceDetails(key);
		var s = '';
		for ( var i in keys) {
			var prop = keys[i];
			s += prop + ": '" + details[prop] + "'; ";
		}
		log('getVirtualDeviceDetails returned "' + s + '"');
	} catch (err) {
		log('getVirtualDeviceDetails failed: ' + err);
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * getPhysicalClientDevices() -- getPhysicalClientDeviceDetails() --
 * 
 * Invoked by the sample page in response to corresponding button clicks. button
 * click.
 * 
 * Results: None.
 * 
 * Side effects: Displays results of plugin calls with specified parameters in
 * an log box.
 * 
 * ----------------------------------------------------------------------------
 */

function getPhysicalClientDevices() {
	var mask = deviceMask.value;

	try {
		if (isIE) {
			var devices = new VBArray(vmrc.getPhysicalClientDevices(mask))
					.toArray();
			log('getPhysicalClientDevices returned "' + devices + '"');
		} else {
			log('getPhysicalClientDevices returned "'
					+ vmrc.getPhysicalClientDevices(mask) + '"');
		}
	} catch (err) {
		log('getPhysicalClientDevices failed: ' + err);
	}
}

function getPhysicalClientDeviceDetails() {
	var key = $getV('client_device_key');

	try {
		var keys = [ 'key', 'type', 'state', 'connectedByMe', 'name', 'path',
				'usbFamilies', 'usbSharable', 'usbSpeeds' ];
		var details = vmrc.getPhysicalClientDeviceDetails(key);
		var s = '';
		for ( var i in keys) {
			var prop = keys[i];
			s += prop + ": '" + details[prop] + "'; ";
		}
		log('getPhysicalClientDeviceDetails returned "' + s + '"');
	} catch (err) {
		log('getPhysicalClientDeviceDetails failed: ' + err);
	}
}

/*
 * ----------------------------------------------------------------------------
 * 
 * connectDevice() -- disconnectDevice() --
 * 
 * Functions to connect or disconnect a remote device, invoked in response to
 * clicking the corresponding buttons in the sample page.
 * 
 * Results: None.
 * 
 * Side effects: Connect/disconnect remote device.
 * 
 * ----------------------------------------------------------------------------
 */

function connectDevice() {
	var virtualKey = $getV('virtual_device_key');
	var physicalKey = $getV('client_device_key');
	var backing = parseInt($getV('VMRC_DeviceBacking'));

	try {
		vmrc.connectDevice(virtualKey, physicalKey, backing)
		log('connectDevice succeeded');
	} catch (err) {
		log('connectDevice failed: ' + err);
	}
}

function disconnectDevice() {
	var key = $getV('disconnect_dev_key');

	try {
		vmrc.disconnectDevice(key);
		log('disconnectDevice succeeded');
	} catch (err) {
		log('disconnectDevice failed: ' + err);
	}
}
