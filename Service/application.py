

import tornado.web
from handlers.index import IndexHandler


application = tornado.web.Application(
    [(r'/', IndexHandler )],
)