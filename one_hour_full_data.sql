/* select all views for one hour*/
SELECT 
domain_userid,
derived_tstamp,
page_url
FROM "atomic".events 
where derived_tstamp between '2017-06-26 00:00:00' and '2017-06-26 01:00:00' and event like 'page_view' and app_id='Netshoes'
order by page_url
