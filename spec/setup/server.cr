app_server = AppServer.new

spawn { app_server.listen }

Spec.after_suite { app_server.close }
