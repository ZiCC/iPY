#coding=utf-8
#!/usr/bin/env python

import tornado.web
import methods.readdb as mrd

class IndexHandler(tornado.web.RequestHandler):
    def post(self):
        '''
        头部注意添加#coding=utf-8  申明编码格式，不然中文会报错
        self.get_argument()函数  接受客户端post过来的函数 按字段名取值，ps：也可以试试全取
        '''

        print 'get post username = ' + self.get_argument('username', 'ServerDef')
        print 'get post password = ' + self.get_argument('password', 'ServerDef')

        username = self.get_argument("username")
        password = self.get_argument("password")
        user_infos = mrd.select_table(table="users", column="*", condition="username", value=username)

        #self.write为回调函数，返回客户端数据，须为字典
        response = {'message':'Welcome ~'}
        errorRes = {"message":'Fuck u.'}
        if user_infos:
            db_pwd = user_infos[0][2]
            if db_pwd == password:
                self.write(response)
            else:
                self.write(errorRes)
        else:
            self.write({'message':'Come on, please regist'})


        #self.finish包含self.write函数
        # self.finish({'message': 'ok'})



