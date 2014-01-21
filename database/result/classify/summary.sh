#!/usr/bin/env sh

postfix='_train_selectedfeatures-normalized-classify.arff'

for file in $(find . -name "*.arff")
do 
  basename $file .arff >> summary_title.txt

  class='class_accuracy'
  newdir="summary-$class"
  mkdir -p $newdir
  newfile=`echo $file | sed s/$postfix/-$class.txt/`
  tail -n 14 $file | head -n 6 > "$newdir/$newfile"
  awk '/\ \ \ \ Y/' "$newdir/$newfile" >> summary_Y.txt
  sed -i 's/[ ][ ]*/,/g' summary_Y.txt

  awk '/\ \ \ \ N/' "$newdir/$newfile" >> summary_N.txt
  sed -i 's/[ ][ ]*/,/g' summary_N.txt

  awk '/Weighted/'  "$newdir/$newfile" >> summary_Weighted.txt
  sed -i 's/[ ][ ]*/,/g' summary_Weighted.txt

done

wc *.txt

