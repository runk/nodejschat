
var common  = require("common.js");
var sys     = require("sys");

function Request(data) {
	this.setData(data);
}

Request.prototype.data          = new Object();
Request.prototype.action 	   	= '';
Request.prototype.params        = new Object();
Request.prototype.setData 		= function(data) {

	// remove \0 
  	data = data.substring(0, data.lastIndexOf('\0'));
	sys.debug('Received data: ' + data);

	// parse request
    this.data    = JSON.parse(data);
	this.action  = this.data.action;
	this.params  = this.data.params;
	//sys.debug('Action: ' + this.action);
}
Request.prototype.getMethod = function() {
	var method = require(__dirname + '/../methods/' + this.action + '.js');
	method.setRequest(this);
	return method;
}

module.exports = Request;
