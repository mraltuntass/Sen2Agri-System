#! /bin/bash

#USER modif
#add directories where SPOT products are to be found
inputXML="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130217_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130217_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130222_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130222_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130227_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130227_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130304_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130304_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130319_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130319_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130324_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130324_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130329_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130329_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130403_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130403_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130413_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130413_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130418_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130418_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130423_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130423_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130503_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130503_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130513_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130513_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130518_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130518_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130523_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130523_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130602_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130602_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130607_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130607_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130612_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130612_N2A_CSudmipy-ED0000B0000.xml "
inputXML+="/mnt/Satellite_Imagery/S2-QR/CSudmipy-E_LEVEL2A/SPOT4_HRVIR1_XS_20130617_N2A_CSudmipy-ED0000B0000/SPOT4_HRVIR1_XS_20130617_N2A_CSudmipy-ED0000B0000.xml "
#end of USER modif

if [ $# -lt 3 ]
then
  echo "Usage: $0 <croptype otb application directory> <pheno metrics otb application directory> <output directory name>"
  echo "The file with input xmls should be given. The resolution for which the computations will be performed should be given. The output directory should be given" 1>&2  
  exit
fi

./run_pheno.sh $1 $2 "$inputXML" $3

