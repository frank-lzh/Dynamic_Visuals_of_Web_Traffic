select date_trunc(:period,derived_tstamp) as time_of_event,count(derived_tstamp)
from "atomic".events
where app_id like :site and event like 'page_view' and  derived_tstamp between '2017-06-22 00:00:00' and '2017-06-23 00:00:00' and (page_urlpath like '/' or page_url like '/Home')
group by time_of_event
order by time_of_event asc
