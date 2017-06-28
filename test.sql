/*transaction item grouped by date, in another way
select domain_userid,user_id,event,derived_tstamp::timestamp::date as date_of_event,
extract (hour from derived_tstamp) || ':' || extract (MINUTE FROM derived_tstamp) || ':' || extract (second from derived_tstamp) as time_of_event,
ti_orderid,ti_sku,ti_price,ti_quantity
from atomic.events
where app_id like 'Netshoes' and event like 'transaction_item' and derived_tstamp > '2017-04-01 00:00:00'
*/

/*cast(extract (hour from derived_tstamp) as varchar(2)) + ':'+
cast(extract (MINUTE FROM derived_tstamp) as varchar(2)) + ':' + cast(extract (second from derived_tstamp) as varchar(2)),
select derived_tstamp::timestamp::date as date_of_event, sum(ti_quantity)
from atomic.events
where app_id like 'Netshoes' and event like 'transaction_item' and derived_tstamp > '2017-04-01 00:00:00'
group by date_of_event
order by date_of_event asc

*/

/* select all PDP view events for a certain period
SELECT 
domain_userid as user_id,
REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') "sku_id",
derived_tstamp::timestamp::date as date_of_purchase,
REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') "product_id",
'NA' as order_id,
'100005' as site,
br_name as browser
FROM "atomic".events 
where derived_tstamp between '2017-04-23 00:00:00' and '2017-04-23 23:59:59.99999' and app_id = 'Netshoes'and event = 'page_view'and page_urlpath like '%/produto/%'
and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') is not null and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') <> ''
order by date_of_purchase
limit 100
*/



/* extract shopping cart together with navigation information	
select domain_userid,user_id,event,derived_tstamp,
tr_orderid,tr_total,tr_shipping,ti_orderid,ti_sku,ti_price,ti_quantity,ti_name,ti_category,REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') "PDP_sku_id"
from "atomic".events
where app_id = 'Netshoes'and (event like 'transaction%' or (event like 'page_view' and page_urlpath like '%/produto/%')) and derived_tstamp between '2017-04-03 00:00:00' and '2017-04-03 23:59:59.99999' and domain_userid in 
(select domain_userid
FROM "atomic".events 
where app_id = 'Netshoes'and event like 'transaction%' and derived_tstamp between '2017-04-03 00:00:00' and '2017-04-03 23:59:59.99999')
order by domain_userid ASC, derived_tstamp,event
*/

/*number of transaction items grouped by date
select domain_sessionid,domain_userid,derived_tstamp::timestamp::date as date_of_event,derived_tstamp,ti_sku,ti_quantity
from "atomic".events
where app_id = 'Netshoes' and event like 'transaction_item' and derived_tstamp between '2017-04-23 00:00:00' and '2017-04-24 23:59:59'
order by domain_sessionid,domain_userid
*/


	
/*number of PDP view grouped by date
select derived_tstamp::timestamp::date as date_of_event,count(derived_tstamp)
from "atomic".events
where app_id = 'Netshoes' and event like 'page_view' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') is not null and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') <> '' and br_name is null
group by date_of_event
order by date_of_event asc
*/



/*number of transactions grouped by date
select derived_tstamp::timestamp::date as date_of_event,count(derived_tstamp)
from "atomic".events
where app_id = 'N	etshoes' and event like 'transaction'
group by date_of_event
order by date_of_event asc 
*/

/* PDP view events
select domain_userid, domain_sessionid,domain_sessionidx,user_id,derived_tstamp,REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') "viewed_sku_id"
from atomic.events
where app_id = 'Netshoes' and event like 'page_view' and derived_tstamp between '2017-04-04 23:30:00' and '2017-04-04 23:59:59.99999' and 
REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') is not null and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') <> ''
order by domain_userid asc, derived_tstamp,event
*/

/*transaction item information
select domain_userid, domain_sessionid,domain_sessionidx,user_id,derived_tstamp,ti_sku as "
_sku_id"
from atomic.events
where app_id = 'Netshoes' and event like 'transaction_item' and derived_tstamp between '2017-04-04 23:30:00' and '2017-04-04 23:59:59.99999'
order by domain_userid asc, derived_tstamp,event
*/


/* all transaction information
select domain_userid,user_id,event,event_id,derived_tstamp,
tr_orderid,tr_total,tr_shipping,tr_tax,ti_orderid,ti_sku,ti_price,ti_quantity
from "atomic".events
where app_id = 'Netshoes'and event like 'transaction%' and derived_tstamp between '2017-04-03 00:00:00' and '2017-04-03 23:59:59.99999' 
order by domain_userid asc, derived_tstamp,event
*/


/* event count grouped by hour
select DATEPART(month, derived_tstamp) as month,DATEPART(day, derived_tstamp) as day,DATEPART(hour, derived_tstamp) as hour,count(*)
from atomic.events
where app_id like 'Netshoes' and derived_tstamp between '2017-03-01 23:59:00' and '2017-04-06 23:59:59.99999'
group by DATEPART(month, derived_tstamp),DATEPART(day, derived_tstamp),DATEPART(hour, derived_tstamp)
order by month,day, hour
*/





/* failed selection
select purchase_table.domain_userid,purchase_table.domain_sessionid,
purchase_table.purchase_product_id,view_table.view_product_id,purchase_table.time_of_purchase,view_table.time_of_view
from    --session purchase information(may be empty) for sessions that have PDP views
	(select domain_userid, domain_sessionid,SUBSTRING(ti_sku,1,8) as "purchase_product_id", max(derived_tstamp) as time_of_purchase
			from atomic.events
			where app_id = 'Netshoes' and (event like 'transaction_item' or event like 'page_view')and derived_tstamp between '2017-04-10 23:00:00' and '2017-04-10 23:59:59.99999' and domain_sessionid in (select distinct domain_sessionid
				from atomic.events
				where app_id like 'Netshoes' and event like 'page_view' and derived_tstamp between '2017-04-10 23:00:00' and '2017-04-10 23:59:59.99999' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') <> '' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') is not null and domain_sessionid is not null
		    )
				group by domain_userid,domain_sessionid,purchase_product_id
	) as purchase_table
	left join
	--session view information(not empty)
	(select domain_userid,domain_sessionid,REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') "view_product_id",max(derived_tstamp) as time_of_view
		from atomic.events
		where app_id like 'Netshoes' and event like 'page_view' and derived_tstamp between '2017-04-10 23:00:00' and '2017-04-10 23:59:59.99999' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') <> '' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}') is not null and domain_sessionid is not null
		group by domain_userid,domain_sessionid,view_product_id
	) as view_table
	on purchase_table.domain_userid = view_table.domain_userid and purchase_table.domain_sessionid = view_table.domain_sessionid
where (purchase_table.purchase_product_id is null or (purchase_table.purchase_product_id is not null and purchase_table.purchase_product_id != view_table.view_product_id)) and purchase_table.time_of_purchase>view_table.time_of_view
order by purchase_table.domain_userid,purchase_table.purchase_product_id,view_table.time_of_view desc
*/

/*get purchases data from pulse
select user_id, tr_orderid as order_id, SUBSTRING(ti_sku,1,8) as product_id,ti_sku as sku_id,derived_tstamp::timestamp::date as date_of_purchase, ti_price as price,'NA' as sku_currently_in_stock,'NA' as gender,'NA' as dob,'100005' as site
from atomic.events
where app_id like 'Netshoes' and event like 'transaction_item' and derived_tstamp between '2015-09-01 00:00:00' and '2017-04-27 00:00:00'*/

/*get today's review data
select CURRENT_TIMESTAMP,derived_tstamp::timestamp::date as date_of_event,count(derived_tstamp)
from "atomic".events
where app_id = 'Netshoes' and event like 'page_view' and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') is not null and REGEXP_SUBSTR(page_urlpath,'[A-Z|0-9]{3}-[0-9]{4}-[0-9]{3}') <> '' and br_name is not null and derived_tstamp between '2017-01-01 00:00:00' and '2017-01-01 23:59:59'
group by date_of_event
order by date_of_event asc*/

/*unique device type
Unknown
Game console
Mobile
Digital media receiver
Computer
 
Tablet*/

select date_trunc(:period,derived_tstamp) as time_of_event,count(derived_tstamp)
from "atomic".events
where app_id like :site and event like 'page_view' and  (dvce_ismobile=:ismobile_A or dvce_ismobile=:ismobile_B) and derived_tstamp between '2017-06-22 00:00:00' and '2017-06-23 00:00:00' and (page_urlpath like '/checkout/cart.jsp%' or page_urlpath like '/crs/cart/cart.jsp%')
group by time_of_event
order by time_of_event asc
