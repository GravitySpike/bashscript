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
			OA	else
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

			sed -i 's/Jan/01/p' u.item
			sed -i 's/Feb/02/p' u.item
			sed -i 's/Mar/03/p' u.item
			sed -i 's/Apr/04/p' u.item
			sed -i 's/May/05/p' u.item
			sed -i 's/Jun/06/p' u.item
			sed -i 's/Jul/07/p' u.item
			sed -i 's/Aug/08/p' u.item
			sed -i 's/Sep/09/p' u.item
			sed -i 's/Oct/10/p' u.item
			sed -i 's/Nov/11/p' u.item
			sed -i 's/Dec/12/p' u.item

			spl=0
			while read line || [ -n "$line" ]; do
				id=$(echo $line | cut -d '|' -f 1)
				echo $id
				if [ $((id)) -gt 1682 ]; then
					release=$(echo $line | cut -d '|' -f 3)
					marker=$(echo $line | tr '|' "\n")
					year=""
					month=""
					day=""
					data=$(echo $release | tr '-' "\n")
					for item in $data
					do
						if [ $spl == 0 ]; then
							day=$item
							((spl+=1))
						elif [ $spl == 1 ]; then
							month=$item
							((spl+=1))
						else
							year=$item
							((spl+=1))
						fi
					done

					spl=0

					for element in $marker
					do
						if [ $spl == 3 ]; then
							echo -n "$year"
							echo -n "$month"
							echo -n "$day"
							echo -n "|"
							((spl+=1))
						else
							echo -n "$element"
							echo -n "|"
							((spl+=1))
						fi
					done
					echo ""
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

