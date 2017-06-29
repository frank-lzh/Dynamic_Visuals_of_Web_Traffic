#!/bin/bash
#calculate the dates for training and testing
current_wd=$PWD
current_date=$(date +"%Y-%m-%d")
yesterday_date=$(date +%Y-%m-%d -d "$current_date - 1 day")
echo "current_date: "$current_date
echo "yesterday_date: "$yesterday_date
echo "Current Working Directory: "$current_wd

## declare array variables for site, page_type and period
declare -a site_list=("Zattini" "Netshoes" )
declare -a page_type_list=("Home" "PDP" "Cart" "All")
declare -a period_list=("day" "hour" "minute")
declare -a device_list=("mobile" "non-mobile" "all")
device_A="f"
device_B="t"

## now loop through the above arrays starting from 2017-04-01 00:00:00
for site in "${site_list[@]}"
do
	for page_type in "${page_type_list[@]}"
	do
		for period in "${period_list[@]}"
		do
			for device in "${device_list[@]}"
			do
				#generate prefix and device_condition
				file_prefix=(${site}_${page_type}_${period}_${device})
				sql_file=${current_wd}/Sql/${page_type}.sql
				result_file=${current_wd}/result/${file_prefix}.txt
				echo "-------Now execute the count for "$result_file
				case  $device  in
					mobile)       
			     		    device_A="t"
					    device_B="t"
					    ;;
					non-mobile)
			     		    device_A="f"
					    device_B="f"
					    ;;            
					all)       
			     		    device_A="f"
					    device_B="t"
					    ;;
					*)  
			     		    device_A="f"
					    device_B="t"
					    ;;            
				  esac 
				#check whether the sql file exists
				if [ ! -f $sql_file ]
				then
					echo "$sql_file not found!"
					continue #skip to the next sql file
				fi
				#Need to initiate a full historical file of these is not one
				if [ ! -f $result_file ]
				then
					echo "$result_file not found!"
					echo "Now generate a full historical file from 2017-04-01 till today"
					grep -rl $sql_file -e "2017-06-22" | xargs sed -i "s/2017-06-22/2017-04-01/g"
					grep -rl $sql_file -e "2017-06-23" | xargs sed -i "s/2017-06-23/$current_date/g"
					psql -h pulse.cdc5dx3e4dfr.us-west-2.redshift.amazonaws.com -U read_only -d dev -p 5439 -f $sql_file -t -v period="'"$period"'" -v site="'"$site"'" -v ismobile_A="'"$device_A"'" -v ismobile_B="'"$device_B"'" > tmp.txt
					sed '/^\s*$/d' tmp.txt > tmp1.txt
					awk '!a[$0]++' tmp1.txt > $result_file
					rm tmp.txt tmp1.txt
					grep -rl $sql_file -e "2017-04-01" | xargs sed -i "s/2017-04-01/2017-06-22/g"
					grep -rl $sql_file -e "$current_date" | xargs sed -i "s/$current_date/2017-06-23/g"
				else
					#replace the dates in sql files, by default, the extraction date is 2017-06-22
					grep -rl $sql_file -e "2017-06-22" | xargs sed -i "s/2017-06-22/$yesterday_date/g"
					grep -rl $sql_file -e "2017-06-23" | xargs sed -i "s/2017-06-23/$current_date/g"
					#get the data count for the new day
					psql -h pulse.cdc5dx3e4dfr.us-west-2.redshift.amazonaws.com -U read_only -d dev -p 5439 -f $sql_file -t -v period="'"$period"'" -v site="'"$site"'" -v ismobile_A="'"$device_A"'" -v ismobile_B="'"$device_B"'" > tmp.txt
					grep -rl $sql_file -e "$yesterday_date" | xargs sed -i "s/$yesterday_date/2017-06-22/g"
					grep -rl $sql_file -e "$current_date" | xargs sed -i "s/$current_date/2017-06-23/g"

					#remove the empty lines and append the new data to the historical data
					sed  '/^\s*$/d' tmp.txt >> tmp1.txt
					awk '!a[$0]++' tmp1.txt > tmp2.txt
					cp tmp2.txt $result_file
					rm tmp.txt tmp1.txt tmp2.txt
				fi
				#sort the new data and get the maximum 
				sort -k4nr $result_file > tmp.txt
				head -1 tmp.txt > new_max_count.txt
				new_max_count_file=$(readlink -f new_max_count.txt)
				#invoke the Rscipt
				echo "bash part ends, now compare the old_max_count and new_max_count in R"
				Rscipt="update_max_count.R"
				./$Rscipt $site $page_type $period $device $new_max_count_file

				rm tmp.txt
			
				echo "----------End of Execution for "$result_file
			done    			
		done
	done
done

echo "Now upload the max_count_table file to S3 bucket"
s3cmd put ~/Exploration/traffic_count/Netshoes_Page_Request_Analytics.csv s3://beveel/statistics/Netshoes_Page_Request_Analytics.csv
