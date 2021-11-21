# csv parser script

csvfile="/Users/vignesh/Downloads/512L2.csv"
#for line in `cat $csvfile` 
#do 
#    echo $line

#done

while IFS=, read -r col1 col2
do
    argument=$col1
    echo $argument
    main $argument
done < $csvfile