#! /bin/bash
readonly DBPATH="DBSE";
declare -a DBARR ;


function createDB {
	clear
	read -p "Enter Database Name : " dbName;
	if [ ! -d $DBPATH/$dbName ];
		then	mkdir $DBPATH/$dbName;
	
		echo $dbName" Created Successfully" ;
				
	else	
		echo "This Database is Exists";
	fi

}

function listDB {
	cd cd /home/malaa/Documents/Bashproject/DBSE
	clear
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		echo $i") "$DB;
		let i=i+1;
	done
	echo ""

	if [ $i -eq 1 ]; 
		then
		echo "You have no DBs please try to add one :)"	
		userInterface;
	fi
	
}
function dropDB {
		clear
		i=1;
		for DB in `ls $DBPATH`
		do
		DBARR[$i]=$DB;
		echo $i") "$DB;
		let	 i=i+1;
		done
		if [ $i -ne 1 ]; then
		{
		read -p "Choose only the number you want to delete from the DB : " choise ;
		#echo $choise 
		if [ $choise -lt $i ]; then
		read -p "Are You Sure Droping ${DBARR[$choise]} Database [Y/N] " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm -r $DBPATH/${DBARR[$choise]};
	        	DBARR[$choise]="";
	        	echo "${DBARR[@]}";

	    	;;

	    	*)
			userInterface;
			;;
		esac	
		else
		{
			#clear
			echo "Please only choose from the numbers above :)";
			userInterface;
			
		}


		fi
		}
		else
		echo "You have no DBs to remove please try to add one :)"
		
		fi

}
function tablemenu {

	options=("create New Table" "Enter Table To Do Operations" "Show Tables" "Drop Table" "Return TO Main Menu" "Quit");
		PS3="Enter Your Choice : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"create New Table")
					createTl;
					tablemenu;
					break ;
					;;
				"Enter Table To Do Operations")
					crudOperations;
					break ;
					;;
				"Show Tables")
					listTB "show";
					
					break ;
					;;
				"Drop Table")
					dropTB;
					tablemenu
					break ;
					;;
				"Return TO Main Menu")
					clear;
					userInterface;
					;;
				"Quit")
					exit -1 ;
					;;
			esac
		done

}
function tableOperations {
	
	read -p "Choose Database You Want To Use It From The Above Databases List : " Cho ;

	if [  $Cho -lt $i ]; then
	clear	
		#echo $i 
		echo "You Are Using ${DBARR[$Cho]} Database";
		tablemenu		
	else
	{
	clear
	echo "out of range please only choose form above Databases";
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		echo $i") "$DB;
	let	 i=i+1;
	done
	options2=("To Choose right answer" "Return TO Main Menu" "Quit");
		select opt in  "${options2[@]}"
		do
			case $opt in
				"To Choose right answer")
					tableOperations;
					;;

				"Return TO Main Menu")
					clear;
					userInterface;
					;;
				"Quit")
					exit -1 ;
					;;
			esac
		done

		}	
	fi
}

function createTl {
	cd /home/malaa/Documents/Bashproject/
	echo 'Enter Table Name:';
	read table;
	echo $table >> $DBPATH/${DBARR[$Cho]}/tables;
	if test -e ./$DBPATH/${DBARR[$Cho]}/$table
	then
		echo -e "  Faild already Exist" ;
	else
		echo "ok"
		touch $DBPATH/${DBARR[$Cho]}/$table;
		sudo chmod u+rw ./$DBPATH/${DBARR[$Cho]}/$table;
		sudo touch $DBPATH/${DBARR[$Cho]}/meta$table;
		sudo chmod 777 ./$DBPATH/${DBARR[$Cho]}/meta$table;
		echo 'Enter Number of column';
		read col;
		re='^[0-9]+$'
		while ! [[ $col =~ $re ]]
		do
			read -p "not a number please enter a number " col
			
		done	
		myvar=0
		sudo touch $DBPATH/${DBARR[$Cho]}/attrcout$table
		sudo chmod 777 $DBPATH/${DBARR[$Cho]}/attrcout$table
		echo $col > $DBPATH/${DBARR[$Cho]}/attrcout$table
		echo Enter column number $((myvar+1)) that you want it primary key;
		read attr
		echo "please enter i to set pk"
		read pk
		while [ $pk != "i" ]
		do
			echo "please enter i to set pk"
			read pk
		done
		 echo -n i >> ./$DBPATH/${DBARR[$Cho]}/meta$table " ";
		 echo -n $attr >> ./$DBPATH/${DBARR[$Cho]}/$table " "
		 myvar=1
		while test $myvar -lt $col
		do 

			echo Enter column number $((myvar+1)) name;
			read attr
			echo -n $attr >> ./$DBPATH/${DBARR[$Cho]}/$table " "
			echo choose column number $((myvar+1)) datatype  Press s to pass;
			read dtype
			while [ $dtype != "s" ]
			do
				echo "please enter s to pass"
				read dtype
				
			done
			echo -n s >> ./$DBPATH/${DBARR[$Cho]}/meta$table " "
			sudo touch $DBPATH/${DBARR[$Cho]}/tintemp
			sudo chmod 777 $DBPATH/${DBARR[$Cho]}/tintemp
			myvar=$(( myvar+1 ))
		done
		echo ' ';
		echo -e "Table  Successfully "
		cat $DBPATH/${DBARR[$Cho]}/meta$table | tr -s " " > tintemp
		sudo rm $DBPATH/${DBARR[$Cho]}/meta$table
		sudo touch $DBPATH/${DBARR[$Cho]}/meta$table
		sudo chmod 777 $DBPATH/${DBARR[$Cho]}/meta$table
		cat tintemp > $DBPATH/${DBARR[$Cho]}/meta$table
		sudo rm $DBPATH/${DBARR[$Cho]}/tintemp 	
	fi


}
function listTB {
	clear
	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
	cat ./tables;
	echo ""
	tablemenu
	
}
function dropTB {
	
		cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
		cat ./tables;	
		echo "Enter the table name";
		read table
		if test -e ./$table
		then
			sudo rm ./$table;
			sudo rm ./meta$table;
			sudo rm ./attrcout$table;
			sudo touch tablestemp;
			sudo chmod 777 tablestemp;
			grep -v $table tables > tablestemp;
			sudo rm tables
			sudo touch tables
			sudo chmod 777 tables
			cat tablestemp > tables
			sudo rm tablestemp;
		
		 echo -e " Table Removed " 
		else
		echo -e "Drop Faild , is not exist" ;
		fi
}

function crudOperations {

		echo "You Are Using ${DBARR[$Cho]} Databas";menuOperations

}

function insertRw() 
{   

	#cd 
	
	#cd $DBPATH/${DBARR[$Cho]}
	read -p 'insert table name : 'table
	 
	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
	if test -e ./$table
	then
	read attributes < $table
	read datatypes < meta$table
	dtarr={$datatypes};
	myarr={$attributes};
	echo >> ./$table;

	read myatrcounter < attrcout$table
	minecounter=1
	for attr in $myarr
	do

		sudo touch mycontainer
		sudo chmod 777 mycontainer
		cut -d " " -f $minecounter ./meta$table > mycontainer
		read dt < mycontainer
		testflag=0
		
		
			case $dt in
			"i") while test $testflag -eq 0
			do
				echo 'enter value of' $attr; 
				read val
				if test $val -gt 0
				then 
					grep $val ./$table > dummy #3ayez at2ked en el record dah msh mawgod abl keda

					if test $? -eq 0
					then
						echo -e "Duplicated Primary Key , Please Enter another one "
					else
					echo -n $val >> ./$table " "; 
					testflag=1;	
					sudo rm dummy;	
					fi		
				else 
		
				echo -e "This is not a number, try again.. ";
				fi 
				done ;;
				"s")
				echo 'enter value of' $attr; 
				read val;
				
				echo -n $val >> ./$table " ";;
			esac
		
			sudo rm mycontainer
			minecounter=$(($minecounter+1))
		done
		echo ' ';
		echo  " Successfully"
		else
	  echo -e "Insertion Faild, not exist " ;
	fi

}

#$DBPATH/${DBARR[$Cho]}/$tlName

function updateRw(){
 	
 	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}

	read -p  'Enter Table Name : ' table;
	if test -e ./$table
	then
	cat ./$table;
	echo ''
	echo -e 'Enter record Id';
		read recid;
		read attr < $table
		myattrarray=$attr;
		sudo touch ./mytempfile
		sudo chmod 777 ./mytempfile
		echo ${myattrarray[*]} > ./mytempfile;
		delrec=$((recid+1))
		grep -v -w "^$recid" ./$table > ./mytempfile
		sudo rm ./$table;
		sudo touch ./$table
		sudo chmod 777 ./$table 
		cat ./mytempfile > ./$table
		sudo rm ./mytempfile
		echo ' '
		read attributes < $table
	read datatypes < meta$table
	dtarr={$datatypes};
	myarr={$attributes};
	echo >> ./$table;

	read myatrcounter < attrcout$table
	minecounter=1
	for attr in $myarr
	do

		sudo touch mycontainer
		sudo chmod 777 mycontainer
		cut -d " " -f $minecounter ./meta$table > mycontainer
		read dt < mycontainer
		testflag=0
		
		
			case $dt in
			"i") while test $testflag -eq 0
			do
				echo 'enter value of' $attr; 
				read val
				if test $val -gt 0
				then 
					grep $val ./$table > dummy #3ayez at2ked en el record dah msh mawfod abl keda

					if test $? -eq 0
					then
						echo -e "Duplicated Primary Key , Please Enter another one "
					else
					echo -n $val >> ./$table " "; 
					testflag=1;	
					sudo rm dummy;	
					fi		
				else 
		
				echo -e "This is not a number, try again.. ";
				fi 
				done ;;
				"s")
				echo 'enter value of' $attr; 
				read val;
				
				echo -n $val >> ./$table " ";;
			esac
		
			sudo rm mycontainer
			minecounter=$(($minecounter+1))
		done
		echo ' ';
		echo  " Successfully"
	else 
	echo "wrong file" 
	fi


}
displayTB(){
 	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
		echo 'Enter table name';
		read table;
	if test -e ./$table
	then
		cat ./$table;
		echo " "
		else
		echo -e "Selection Faild ,is not exist $" ;
	fi
}


displayRw()
{
 	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
		echo 'Enter Table Name';
		read table;
	if test -e ./$table
	then
		echo 'Enter record Id';
		read recid;
		echo " "
		read attr < $table
		echo -e "$attr ";

		cat ./$table | grep -w "^$recid"
	else
		 echo -e "Retrieve Faild, is not exist " ;
	fi


}

deleteRw()
{
 	cd /home/malaa/Documents/Bashproject/$DBPATH/${DBARR[$Cho]}
	echo 'Enter Table Name';
	read table 
	if test -e ./$table
	then
		echo 'Enter record Id';
		read recid;
		read attr < $table
		myattrarray=$attr;
		sudo touch ./mytempfile
		sudo chmod 777 ./mytempfile
		echo ${myattrarray[*]} > ./mytempfile;
		delrec=$((recid+1))
		grep -v -w "^$recid" ./$table > ./mytempfile
		sudo rm ./$table;
		sudo touch ./$table
		sudo chmod 777 ./$table 
		cat ./mytempfile > ./$table
		sudo rm ./mytempfile
		echo ' '
		echo -e " Record Deleted ";
	else
		echo -e "Delete Faild , is not exist" 

	fi
}


function menuOperations
	{
	options=("Insert" "Update" "Display Table" "Display Record" "Delete Record" "Return TO Pervious Menu" "Return TO Main Menu" "Quit");
		PS3="Enter Your Choice : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"Insert")
					insertRw;
					crudOperations $?;
					break ;
					;;
				"Update")
					
					updateRw;
					crudOperations $?;
					break ;
					;;
				"Display Table")
					
					displayTB;
					crudOperations $?;
					break ;
					;;
				"Display Record")
					
					displayRw;
					crudOperations $?;
					break ;
					;;
				"Delete Record")
					
					deleteRw;
					crudOperations $?;
					break ;
					;;
				"Return TO Pervious Menu")
					tablemenu $Cho;
					;;
				"Return TO Main Menu")
					userInterface;
					;;
				"Quit")
					exit -1 ;
					;;
			esac
		done

}

function  userInterface {
	
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				
				createDB;
				userInterface;
				break ;
				;;
			"Use Database")
				
				listDB;
				tableOperations;
				break ;
				;;
			"Show Databases")
				
				listDB "show";
				userInterface
				break ;
				;;
			"Drop Databas")
				
				dropDB;
				userInterface
				break ;
				;;
			"Quit")
				exit -1 ; 

				;;
		esac
	done
};
userInterface
