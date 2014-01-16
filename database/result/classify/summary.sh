#!/usr/bin/env sh

postfix='_train_selectedfeatures-normalized-classify.arff'

for file in $(find . -name "*.arff")
do 
  basename $file .arff >> summary_title.txt

  train='training_error'
  newdir="summary-$train"
  mkdir -p $newdir 
  newfile=`echo $file | sed s/$postfix/-$train.txt/`
  tail -n 32 $file | head -n 11 > "$newdir/$newfile"
  awk '/Correctly/'  "$newdir/$newfile" >> summary_train_Correctly.txt
  awk '/Incorrectly/' "$newdir/$newfile" >> summary_train_Inorrectly.txt
  awk '/Total/' "$newdir/$newfile" >> summary_train_Total.txt

  testing='test_error'
  newdir="summary-$testing"
  mkdir -p $newdir 
  newfile=`echo $file | sed s/$postfix/-$testing.txt/`
  tail -n 11 $file > "$newdir/$newfile"
  awk '/Correctly/'  "$newdir/$newfile" >> summary_test_Correctly.txt
  awk '/Incorrectly/' "$newdir/$newfile" >> summary_test_Inorrectly.txt

  class='class_accuracy'
  newdir="summary-$class"
  mkdir -p $newdir
  newfile=`echo $file | sed s/$postfix/-$class.txt/`
  tail -n 19 $file | head -n 7 > "$newdir/$newfile"
  awk '/\ \ \ \ Y/' "$newdir/$newfile" >> summary_Y.txt
  awk '/\ \ \ \ N/' "$newdir/$newfile" >> summary_N.txt
  awk '/Weighted/'  "$newdir/$newfile" >> summary_Weighted.txt
done

wc *.txt

