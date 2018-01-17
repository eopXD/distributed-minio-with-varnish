#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and http://varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

import directors;

# Default backend definition. Set this to point to your content server.
#backend default {
#    .host = "127.0.0.1";
#    .port = "8080";
#}

backend server1 {
	.host="SERVER1_IP";
	.port="SERVER1_PORT";
	.probe = {
		.interval=5s;
		.timeout=1s;
		.window = 5;
		.threshold = 3;
		.expected_response=403;
	}
}
backend server2 {
	.host="SERVER2_IP";
	.port="SERVER2_PORT";
	.probe = {
		.interval=5s;
		.timeout=2s;
		.window = 5;
		.threshold = 3;
		.expected_response=403;
#		.request = 
#			"HEAD /minio/login HTTP/1.1"
#			"Host: 10.0.2.13:9000"
#			"User-Agent: Mozilla/6.0";
	}
}
backend server3 {
	.host="SERVER3_IP";
	.port="SERVER3_PORT";
	.probe = {
		.interval=5s;
		.timeout=5s;
		.window = 5;
		.threshold = 3;
		.expected_response=403;
#		.request = 
#			"HEAD /minio/login HTTP/1.1"
#			"Host: 10.0.2.14:9000"
#			"User-Agent: Mozilla/6.0";
	}
}

sub vcl_init {
	new foo=directors.random();
	foo.add_backend(server1,6);
	foo.add_backend(server2,2);
	foo.add_backend(server3,2);
	
	new bar=directors.round_robin();
	bar.add_backend(server1);
	bar.add_backend(server2);
	bar.add_backend(server3);

}
sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
#	set req.backend_hint=foo.backend();
#	set req.backend_hint=bar.backend();
}
sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
