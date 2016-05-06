bug report: multiple joins

a upgrade "script", which is complex somehow. has several sql statements, and some java logic. one of sql is ill

        String sql = "SELECT t0.id AS t0_id,"
                + " t1.id AS t1_id, t1.logisticsStatus AS t1_logisticsStatus, t1.invoiceStatus AS t1_invoiceStatus,"
                + " t1.lineType AS t1_lineType, t1.quantity AS t1_quantity, t1.sku_Id AS t1_sku_Id,"
                + " t2.id AS t2_id, t2.logisticsStatus AS t2_logisticsStatus, t2.invoiceStatus AS t2_invoiceStatus,"
                + " t2.lineType AS t2_lineType, t2.quantity AS t2_quantity, t2.sku_Id AS t2_sku_Id,"
                + " t3.id AS t3_id, t3.logisticsStatus AS t3_logisticsStatus, t3.invoiceStatus AS t3_invoiceStatus,"
                + " t3.lineType AS t3_lineType, t3.quantity AS t3_quantity, t3.sku_Id AS t3_sku_Id"
                + " FROM SalesOrder t0"
                + " LEFT JOIN OrderProductLine t1 ON t0.id = t1.salesorderid"
                + " LEFT JOIN OrderShippingLine t2 ON t0.id = t2.salesorderid"
                + " LEFT JOIN OrderReturnLine t3 ON t0.id = t3.salesorderid WHERE t0.id = ?";
				
				
I thought what would come out by the sql

t0_id ... t1_id ... t2_id ... t3_id ...
1          101          ?          ?
1          ?          202          ?
1          ?           ?           303



what happens really

t0_id ... t1_id ... t2_id ... t3_id ...
1         101        202        303


why not detect

when I test. in test data, 2 t1 lines, no other type lineType. test results
t0_id ... t1_id ... t2_id ... t3_id ...
1          101          ?          ?
1          102          ?          ?

2 t1 lines, 2 results, sound good


what's my bad
- not understand multiple join very well
- not do full test in local