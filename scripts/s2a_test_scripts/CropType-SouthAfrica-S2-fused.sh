#!/bin/sh

source ./set_build_folder.sh

./CropTypeFused.py \
    -refp /mnt/data/south_africa_medium/SA_FRST_LC_SM_2016_repaired.shp \
    -strata /mnt/data/south_africa_medium/Test_3Strata.shp \
    -outdir /mnt/data/south_africa_medium/South-Africa-medium-type \
    -rseed 0 \
    -input \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181945_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T023112_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T041216_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190131_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160309T070630_R135_V20160308T081127_20160308T081127.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160308.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160311T230641_R035_V20160311T082108_20160311T082108.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160311.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T063438_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150519_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141414_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T014108_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T121636_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T124753_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JMJ____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181945_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T023112_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T041216_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190131_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160311T230641_R035_V20160311T082108_20160311T082108.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160311.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T063438_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150519_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141414_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160501T102345_R035_V20160430T082712_20160430T082712.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160430.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162322_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T014108_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T121636_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T124753_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JMK____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181614_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T022435_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T040917_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190309_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160311T230704_R035_V20160311T082108_20160311T082108.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160311.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T061241_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150417_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141700_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160501T102540_R035_V20160430T082021_20160430T082712.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160430.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T013652_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T121916_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T125111_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JML____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181945_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T023112_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T041216_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190131_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160311T230641_R035_V20160311T082108_20160311T082108.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160311.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T063438_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150519_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141414_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162322_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T124753_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JNJ____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181945_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T023112_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T041216_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190131_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160311T230641_R035_V20160311T082108_20160311T082108.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160311.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T063438_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150519_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141414_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160501T102345_R035_V20160430T082712_20160430T082712.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160430.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162322_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T014108_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T121636_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T124753_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JNK____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160101T181614_R035_V20160101T083037_20160101T083037.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160101.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173140_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160114T022435_R035_V20160111T082928_20160111T082928.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160111.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160201T040917_R035_V20160131T082308_20160131T082308.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160131.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232752_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160210T190309_R035_V20160210T082634_20160210T082634.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160210.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160322T061241_R035_V20160321T082435_20160321T082435.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160321.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102627_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160412T150417_R035_V20160410T082341_20160410T082341.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160410.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133352_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160420T141700_R035_V20160420T082618_20160420T082618.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160420.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130803_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160501T102540_R035_V20160430T082021_20160430T082712.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160430.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162026_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T013652_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160511T121916_R035_V20160510T082412_20160510T082412.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160510.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160520T125111_R035_V20160520T082349_20160520T082349.SAFE/S2A_OPER_SSC_L2VALD_35JNL____20160520.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162322_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JPJ____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173225_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JPK____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JPK____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JPK____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JPK____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JPK____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173140_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232752_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102627_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133352_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130803_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162026_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JPL____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150553_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T025806_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T171855_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160315T210719_R092_V20160315T080136_20160315T080136.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160315.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135240_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130112_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T110548_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160424T133828_R092_V20160424T080306_20160424T080306.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160424.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T215317_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160514T135151_R092_V20160514T080633_20160514T080633.SAFE/S2A_OPER_SSC_L2VALD_35JQJ____20160514.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150553_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T025806_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T171855_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160315T210719_R092_V20160315T080136_20160315T080136.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160315.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135240_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130112_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T110548_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T215317_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_35JQK____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150319_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160108T173140_R135_V20160108T082023_20160108T082023.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160108.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T024955_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160205T235820_R092_V20160204T080212_20160204T080212.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160204.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232752_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T175552_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192003_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135030_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102627_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130314_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T105838_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133352_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130803_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T214803_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160507T162026_R135_V20160507T081253_20160507T081253.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160507.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160514T135447_R092_V20160514T080633_20160514T080633.SAFE/S2A_OPER_SSC_L2VALD_35JQL____20160514.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150553_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T025806_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T171855_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160315T210719_R092_V20160315T080136_20160315T080136.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160315.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135240_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130112_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T110548_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T215317_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160514T135151_R092_V20160514T080633_20160514T080633.SAFE/S2A_OPER_SSC_L2VALD_36JTP____20160514.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150553_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T025806_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232834_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T171855_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160315T210719_R092_V20160315T080136_20160315T080136.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160315.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192327_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135240_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102551_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130112_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T110548_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133215_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130601_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T215317_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160514T135151_R092_V20160514T080633_20160514T080633.SAFE/S2A_OPER_SSC_L2VALD_36JTQ____20160514.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160105T150319_R092_V20160105T081004_20160105T081004.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160105.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160128T024955_R092_V20160125T080559_20160125T080559.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160125.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160205T235820_R092_V20160204T080212_20160204T080212.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160204.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160207T232752_R135_V20160207T081608_20160207T081608.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160207.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160308T175552_R092_V20160305T080210_20160305T080210.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160305.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160318T192003_R135_V20160318T080751_20160318T080751.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160318.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160329T135030_R092_V20160325T080632_20160325T080632.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160325.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160331T102627_R135_V20160328T080803_20160328T080803.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160328.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160406T130314_R092_V20160404T080447_20160404T080447.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160404.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160415T105838_R092_V20160414T080236_20160414T080236.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160414.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160417T133352_R135_V20160417T081407_20160417T081407.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160417.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160427T130803_R135_V20160427T081514_20160427T081514.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160427.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160504T214803_R092_V20160504T080523_20160504T080523.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160504.HDR \
    /mnt/data/l2a/south-africa/S2A_OPER_PRD_MSIL2A_PDMC_20160514T135447_R092_V20160514T080633_20160514T080633.SAFE/S2A_OPER_SSC_L2VALD_36JTR____20160514.HDR \
    -buildfolder "$BUILD_FOLDER"