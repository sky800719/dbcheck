from openpyxl.chart import (
    LineChart,
    Reference,
)


# 数据库运行负载状态图
def DBLOAD_CHART(worksheet, dbname, chartday, chartrow):
    loadchart = LineChart()
    loadchart.title = dbname + ' ' + chartday + ' DB time'
    loadchart.style = 10
    loadchart.y_axis.title = 'Value'
    loadchart.x_axis.title = 'Housr'

    data = Reference(worksheet, min_col=4, min_row=8, max_col=6, max_row=8 + chartrow)
    loadchart.add_data(data, titles_from_data=True)

    # Style the lines
    loadseries1 = loadchart.series[0]
    loadseries1.marker.symbol = 'triangle'
    loadseries1.marker.graphicalProperties.solidFill = 'FF0000'  # Marker filling
    loadseries1.marker.graphicalProperties.line.solidFill = 'FF0000'  # Marker outline
    loadseries1.smooth = True

    # Style the lines
    loadseries2 = loadchart.series[1]
    loadseries2.marker.symbol = 'circle'
    loadseries2.marker.graphicalProperties.solidFill = '00FF00'  # Marker filling
    loadseries2.marker.graphicalProperties.line.solidFill = '00FF00'  # Marker outline
    loadseries2.smooth = True

    # Style the lines
    loadseries3 = loadchart.series[2]
    loadseries3.marker.symbol = 'plus'
    loadseries3.marker.graphicalProperties.solidFill = '0000FF'  # Marker filling
    loadseries3.marker.graphicalProperties.line.solidFill = '0000FF'  # Marker outline
    loadseries3.smooth = True

    return loadchart
