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
.import '../../train_features/ImageCLEF 2012 (training) - AutoColorCorrelogram.csv' AutoColorCorrelogram
SELECT COUNT(*) FROM AutoColorCorrelogram;
.import '../../train_features/ImageCLEF 2012 (training) - CEDD.csv' CEDD
SELECT COUNT(*) FROM CEDD;
.import '../../train_features/ImageCLEF 2012 (training) - ColorLayout.csv' ColorLayout
SELECT COUNT(*) FROM ColorLayout;
.import '../../train_features/ImageCLEF 2012 (training) - EdgeHistogram.csv' EdgeHistogram
SELECT COUNT(*) FROM EdgeHistogram;
.import '../../train_features/ImageCLEF 2012 (training) - FCTH.csv' FCTH
SELECT COUNT(*) FROM FCTH;
.import '../../train_features/ImageCLEF 2012 (training) - Gabor.csv' Gabor
SELECT COUNT(*) FROM Gabor;
.import '../../train_features/ImageCLEF 2012 (training) - JCD.csv' JCD
SELECT COUNT(*) FROM JCD;
.import '../../train_features/ImageCLEF 2012 (training) - JpegCH.csv' JpegCH
SELECT COUNT(*) FROM JpegCH;
.import '../../train_features/ImageCLEF 2012 (training) - ScalableColor.csv' ScalableColor
SELECT COUNT(*) FROM ScalableColor;
.import '../../train_features/ImageCLEF 2012 (training) - Tamura.csv' Tamura
SELECT COUNT(*) FROM Tamura;
!"
  %x{#{sh}}
end
