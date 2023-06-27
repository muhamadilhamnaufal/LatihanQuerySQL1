select * from customer;
select * from orders;
select * from prodnumber;

with tablebase as (


/*mencari customer id yang pembeliannya diatas rata-rata*/
with tablebase as (
select extract(year from o.date) tahun, extract(month from o.date) bulan, o.date, o.orderid, o.customerid,
	concat(c.firstname,' ',c.lastname)as name, c.customeremail, c.customerphone, c.customeraddress, c.customerstate, pc.prodnumber, pc.prodname,
	pc.category, pc.price, o.quantity, sum (pc.price * o.quantity ) as total_pembelian
	
	from orders as o
	left join customer as c on c.customerid=o.customerid
	left join productcategory as pc on pc.prodnumber=o.prodnumber
	
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	order by tahun,bulan,date
),
avg_pembelian as ( 
select round(avg(total_pembelian),2) as avg_total  from tablebase
	
--rata-rata keseluruhan pembelian adalah 525.53
	
),
melebihi_rata_pembelian as (
select customerid, name, customeremail, customerphone, sum(quantity) as jumlah_barang, count(customerid) as total_order,sum(total_pembelian) as total_pembelian
from tablebase where total_pembelian > ( select avg_total from avg_pembelian ) 
	group by 1,2,3,4
)

select * from melebihi_rata_pembelian 
where total_order>2
order by customerid;


