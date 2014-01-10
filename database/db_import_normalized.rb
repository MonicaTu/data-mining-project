#!/usr/bin/env ruby

dbFile = ARGV[0]

begin
  # shell script
  sh = "sqlite3 #{dbFile} <<!
.separator ,
.import '../train_id.csv' UUID
SELECT COUNT(*) FROM UUID;
.import '../concepts/concepts.csv' Concepts
SELECT COUNT(*) FROM Concepts;
.import '../analysis/tmp/normalized/normalized-AutoColorCorrelogram.csv' AutoColorCorrelogram
SELECT COUNT(*) FROM AutoColorCorrelogram;
.import '../analysis/tmp/normalized/normalized-CEDD.csv' CEDD
SELECT COUNT(*) FROM CEDD;
.import '../analysis/tmp/normalized/normalized-ColorLayout.csv' ColorLayout
SELECT COUNT(*) FROM ColorLayout;
.import '../analysis/tmp/normalized/normalized-EdgeHistogram.csv' EdgeHistogram
SELECT COUNT(*) FROM EdgeHistogram;
.import '../analysis/tmp/normalized/normalized-FCTH.csv' FCTH
SELECT COUNT(*) FROM FCTH;
.import '../analysis/tmp/normalized/normalized-Gabor.csv' Gabor
SELECT COUNT(*) FROM Gabor;
.import '../analysis/tmp/normalized/normalized-JCD.csv' JCD
SELECT COUNT(*) FROM JCD;
.import '../analysis/tmp/normalized/normalized-JpegCH.csv' JpegCH
SELECT COUNT(*) FROM JpegCH;
.import '../analysis/tmp/normalized/normalized-ScalableColor.csv' ScalableColor
SELECT COUNT(*) FROM ScalableColor;
.import '../analysis/tmp/normalized/normalized-Tamura.csv' Tamura
SELECT COUNT(*) FROM Tamura;
!"
  %x{#{sh}}
end
