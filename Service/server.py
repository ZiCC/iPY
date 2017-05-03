
import tornado.httpserver
import tornado.ioloop
import tornado.options

from application import application
from tornado.options import define, options

define('port', default=8000, help='run on the given port', type=int)

def main():
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)

    print "running"

    tornado.ioloop.IOLoop.instance().start()

if __name__ == '__main__':
    main()