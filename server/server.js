
var config = require("./config/config.js");

require.paths.push(__dirname);
require.paths.push(config.paths.config);
require.paths.push(config.paths.library);
require.paths.push(config.paths.methods);

var net  	 = require("net"),
	sys      = require('sys'),
	common   = require("common.js"),
	Policy   = require("Policy")
	Request  = require("Request.js"),
	Response = require("Response");


var server = net.createServer(function (stream) {
	
    stream.setEncoding("utf8");
		
    stream.on('data', function(data) {	
		if (Policy.isPolicyRequest(data)) {
			Policy.sendPolicy(stream);
			return;
        }

        try {
			var request = new Request(data);
			var method = request.getMethod();
			method.setStream(stream);
			method.exec();
		} catch (e) {
			console.log("Error: ", e.stack);
		}
    });

    stream.on("connect", function () {
		Policy.sendPolicy(stream);
        common.streams.push(stream);
        sys.debug("Connect, clients: " + common.streams.length);
    });
    

    stream.on("end", function () {
		var index = common.streams.indexOf(stream);
		if (index > -1) {
			common.streams.splice(index, 1);
		}
		stream.end();
		
		sys.debug("Disconnect, clients: " + common.streams.length);
    });

	stream.on("error", function(exception) {
		sys.debug('an error occured: ' + exception);
	});  
});

server.listen(config.port, config.ip);
sys.debug('Server running at http://' + config.ip + ':' + config.port + '/');