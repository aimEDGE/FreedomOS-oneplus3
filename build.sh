#!/bin/bash
# FreedomOS build script
# Author : Nevax

VERSION=1.0
OOS=OnePlus3Oxygen_16_OTA_008_all_1606122244_e0cfc5ffc8bf411a
SU=BETA-SuperSU-v2.74-2-20160519174328
XPOSED=xposed-v85-sdk23-arm64
XPOSED_APK=XposedInstaller_3.0_alpha4
DIVINE=DiVINE_BEATS_v7.0_EVOLUTION_BY_THE_ROYAL_SEEKER
RECOVERY=twrp-Garak-3.0.2-0

MENU=0

echo "Choose the option what you want :"
echo -en '\n'
echo "1) Signed (Slower)"
echo "2) Unsigned (Faster)"
echo -en '\n'
read MENU
echo -en '\n'

if [ "$MENU" = 1 ];
then
        echo "Signed"
elif  [ "$MENU" = 2 ];
then
        echo "Unsigned"
else
        echo "Wrong entry"
        exit
fi

echo -en '\n'
echo "Clear tmp/ foler..."
rm -Rf tmp/*
touch tmp/EMPTY_DIRECTORY

echo -en '\n'
echo "Clear output/ foler..."
rm -Rf output/*.zip
rm -Rf output/*.md5

echo -en '\n'
echo "Checking dependencies..."

echo -en '\n'
if [ -f "download/$OOS.zip" ];
then
   echo "File $OOS.zip exist."
else
   echo "File $OOS.zip does not exist" >&2
   echo "Downloading.."
   wget "http://fr1.androidOOShost.com/dl/OVtaqkbP1apDmbYG3wFiCQ/1467377045/24591000424941790/$OOS.zip" -O download/$OOS.zip
   echo "Done!"
fi

if [ -f "download/$SU.zip" ];
then
   echo "File $SU.zip exist."
else
   echo "File $SU.zip does not exist" >&2
   echo "Downloading.."
   wget "https://download.chainfire.eu/964/SuperSU/$SU.zip?retrieve_file=1" -O download/$SU.zip
   echo "Done!"
fi

if [ -f "download/$XPOSED.zip" ];
then
   echo "File $XPOSED.zip exist."
else
   echo "File $XPOSED.zip does not exist" >&2
   echo "Downloading.."
   wget "http://dl-xda.xposed.info/framework/sdk23/arm64/$XPOSED.zip" -O download/$XPOSED.zip
   rm -R system/*
   unzip -o download/$OOS.zip -d system/
   echo "Done!"
fi

if [ -f "download/$XPOSED_APK.apk" ];
then
   echo "File $XPOSED_APK.apk exist."
else
   echo "File $XPOSED_APK.apk does not exist" >&2
   echo "Downloading.."
   wget "http://forum.xda-developers.com/attachment.php?attachmentid=3383776&d=1435601440" -O download/$XPOSED_APK.apk
   echo "Done!"
fi

if [ -f "download/$DIVINE.zip" ];
then
   echo "File $DIVINE.zip exist."
else
   echo "File $DIVINE.zip does not exist" >&2
   echo "Downloading.."
   wget "http://fr1.androidfilehost.com/dl/b-p7sG3YlA4BZN8XoW7tbQ/1467379312/24533103863141857/$DIVINE.zip" -O download/$DIVINE.zip
   echo "Done!"
fi

if [ -f "download/$RECOVERY.img" ];
then
   echo "File $RECOVERY.img exist."
else
   echo "File $RECOVERY.img does not exist" >&2
   echo "Downloading.."
   wget "https://basketbuild.com/uploads/devs/Grarak/oneplus3/recovery.img" -O download/$RECOVERY.img
   echo "Done!"
fi

echo -en '\n'
echo "Unzip system"
unzip -o "download/$OOS.zip" -d "tmp/"
echo "Remove META-INF"
rm -R "tmp/META-INF"
echo "Add aroma"
cp -R "aroma/META-INF" "tmp/"
echo "Add tools"
cp -R "tools" "tmp/"
echo "Add SuperSU"
cp download/$SU.zip tmp/tools/su/su.zip
echo "Add xposed"
cp download/{$XPOSED.zip,$XPOSED_APK.apk} tmp/tools/xposed/
echo "Add Divine"
unzip -o "download/$DIVINE.zip" -d "tmp/tools/divine/"
#cp download/$DIVINE.zip tmp/tools/divine/
#cp download/$RECOVERY.img tmp/tools/recovery.img

if [ "$MENU" = 1 ];
then
  cd tmp/
  echo -en '\n'
  echo "Making zip file"
  zip -r9 "FreedomOS-op3-nevax-$VERSION-unsigned.zip" * -x EMPTY_DIRECTORY
  echo "----"
  cd ..
  echo -en '\n'
  echo "SignApk....."
  java -jar "SignApk/signapk.jar" "SignApk/testkey.x509.pem" "SignApk/testkey.pk8" "tmp/FreedomOS-op3-nevax-$VERSION-unsigned.zip" "tmp/FreedomOS-op3-nevax-$VERSION-signed.zip"
  echo "Move signed zip file in output folder"
  mv "tmp/FreedomOS-op3-nevax-$VERSION-signed.zip" "output/"
  echo "Generating md5sum"
  md5sum "output/FreedomOS-op3-nevax-$VERSION-signed.zip" > "output/FreedomOS-op3-nevax-$VERSION-signed.zip.md5"
fi

if [ "$MENU" = 2 ];
then
  cd tmp/
  echo -en '\n'
  echo "Making zip file"
  zip -r1 "FreedomOS-op3-nevax-$VERSION.zip" * -x EMPTY_DIRECTORY
  echo "----"
  echo -en '\n'
  cd ..
  echo "Move unsigned zip file in output folder"
  mv "tmp/FreedomOS-op3-nevax-$VERSION.zip" "output/"
  echo "Generating md5sum"
  md5sum "output/FreedomOS-op3-nevax-$VERSION.zip" > "output/FreedomOS-op3-nevax-$VERSION.zip.md5"
fi

echo "Clear tmp/ foler..."
rm -Rf "tmp/*"
touch "tmp/EMPTY_DIRECTORY"
echo -en '\n'
echo "Finish !"
