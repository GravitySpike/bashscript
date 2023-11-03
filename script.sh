#!/bin/bash

for ((i=0; i<30; i++));
do
	printf "-"
done
echo ""

echo "User Name: $(whoami)"
value=$(<menu.txt)
echo "$value"
while :
do
	printf "Enter your choice [ 1-9 ] "
	read num
	case $num in
		1)
			printf "Please enter \'movie id\' (1~1682) :"
			read id
			echo ""
			cnt=1
			while read line || [ -n "$line" ]; do
				if [ "$cnt" -eq "$id" ]; then
					echo "$line"
					echo ""
					break
				else
					((cnt+=1))
				fi
			done < u.item
			;;
		2)
			printf "Do you want to get the data of \'action\' genre movies from \'u.item\'?(y/n) :"
			read answer
			if [ $answer == "n" ]; then
				continue
			fi

			cnt=0
			while read line || [ -n "$line" ]; do
				marker=$(echo $line | cut -d '|' -f 7)
				if [ "$marker" == "1" ]; then
					printf "%s " $(echo $line | cut -d '|' -f 1) 
					echo $line | cut -d '|' -f 2
					((cnt+=1))
					if [ $cnt == 10 ]; then
						break
					fi
				fi
			done < u.item
			;;
		3)
			printf "Please enter the 'movie id' (1~1682):"
			read id
			echo ""
			total=0
			cnt=0
			while read line || [ -n "$line" ]; do
				marker=$(echo $line | cut -d ' ' -f 2)
				if [ "$marker" == "$id" ]; then
					((cnt+=1))
					rate=$(echo $line | cut -d ' ' -f 3)
					((total+=$rate))
				fi
			done < u.data
			printf "average rating of $id: "
			printf "%.5f\n" $total/$cnt
			;;
		4)
			printf "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):"
			read answer
			if [ "$answer" == "n" ]; then
				continue
			fi
			cnt=0
			while read line || [ -n "$line" ]; do
				subject=$(echo $line | tr '|' "\n")
				for item in $subject
				do
					if [[ "$item" =~ "http" ]]; then
						printf "|"
					else
						printf "$item"
						printf "|"
					fi
				done
				echo ""
				((cnt+=1))
				if [ $cnt == 10 ]; then
					break
				fi
			done < u.item
			;;
		5)
			printf "Do you want to get the data about users from 'u.user'?(y/n):"
			read answer
			if [ "$answer" == "n" ]; then
				continue
			fi
			cnt=1
			while read line || [ -n "$line" ]; do
				age=$(echo $line | cut -d '|' -f 2)
				gender=$(echo $line | cut -d '|' -f 3)
				if [ "$gender" == "M" ]; then
					gender="male"
				else
					gender="female"
				fi
				occup=$(echo $line | cut -d '|' -f 4)
				printf "User $cnt is %s years old %s %s\n" $age $gender $occup
				((cnt+=1))
				if [ $cnt == 11 ]; then
					break
				fi
			done < u.user
			;;
		6)
			printf "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):"
			read answer
			if [ "$answer" == "n" ]; then
				continue
			fi
			cnt=1
			cnt2=0
			while read line || [ -n "$line" ]; do
				if [ $(echo $line | cut -d '|' -f 1) > 1672 ]; then
					release=$(echo $line | cut -d '|' -f 3)
					dates=$(echo $release | tr '-' "\n")
					year=""
					month=""
					day=""
					for item in $dates
					do
						if [ $cnt2 == 0 ]; then
							day=item
						elif [$cnt2 == 1]; then
							case $item in
								"Jan")
									month="01"
									;;
								"Feb")
									month="02"
									;;
								"Mar")
									month="03"
									;;
								"Apr")
									month="04"
									;;
								"May")
									month="05"
									;;
								"Jun")
									month="06"
									;;
								"Jul")
									month="07"
									;;
								"Aug")
									month="08"
									;;
								"Sep")
									month="09"
									;;
								"Oct")
									month="10"
									;;
								"Nov")
									month="11"
									;;
								"Dec")
									month="12"
									;;
							esac
						else
							year=$item
						fi
					done
					subject=$(echo $line | tr '|' "\n")
					((cnt+=1))
					cnt2=0
					for element in $subject
					do
						if [ $cnt2 == 2 ]; then
							printf "%s%s%s" $year $month $day
							printf "|"
							((cnt2+=1))
						else
							printf "$element"
							printf "|"
						fi
					done
					echo ""
				else
					((cnt+=1))
				fi
			done < u.item
			;;
		7)
			printf "Please enter the 'user id' (1~943):"
			read uid
			array=[]
			cnt=0
			cnt2=0
			while read line || [ -n "$line" ]; do
				marker=$(echo $line | cut -d ' ' -f 1)
				echo $marker
				if [ $marker == $uid ]; then
					${array[$cnt]}=$(echo $line | cut -d ' ' -f 2)
					((cnt+=1))
					((cnt2+=1))
					if [ $cnt2 == 400 ]; then
						break
					fi
				else
					((cnt2+=1))
					if [ $cnt2 == 400 ]; then
						break
					fi
				fi
			done < u.data
			echo $array
			;;
		8)
			;;
		9)
			echo "Bye!"
			exit;;
		*)
			continue;;
	esac
done

