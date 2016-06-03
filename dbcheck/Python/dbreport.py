import logging
import logging.config

from openpyxl import Workbook
from DATABASE_PROPERTIES import DBINFO
from datetime import datetime, timedelta
import excelparse

logging.config.fileConfig("logging.conf")
loggerInfo = logging.getLogger("debugHandler")

TODAY = datetime.now()
LASTDAY = (TODAY - timedelta(days=1)).strftime('%Y%m%d')
EXCELNAME = LASTDAY + '-数据库日常巡检报告.xlsx'

loggerInfo.debug("LASTDAY = %s" % LASTDAY)

# 创建新的报表文件
dbcheckwb = Workbook()
dbinfo = DBINFO.DBDICT

sheetNumber = 0
for (dbname, dbvalue) in dbinfo.items():
    loggerInfo.debug("dbname = %s" % dbname)
    print(dbname)
    dbcheckws = dbcheckwb.create_sheet(dbname.upper(), sheetNumber)
    excelparse.excelReport(dbname, dbcheckws, loggerInfo)
    sheetNumber = sheetNumber + 1

dbcheckwb.save(EXCELNAME)