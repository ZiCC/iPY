
import pymysql

conn = pymysql.connect(host="localhost", user="root", passwd="d1231234", db="zictest", port=3306, charset="utf8")

cur = conn.cursor()