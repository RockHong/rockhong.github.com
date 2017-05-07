select * from t0 left join t1 on 1 = 0 

it will still selects all rows of t0  (even if 1 =0 will never satisfy)
it's nature of join.

join is not equals to select

select * from t0, t1  (笛卡儿积)  where 1= 0
no rows will select