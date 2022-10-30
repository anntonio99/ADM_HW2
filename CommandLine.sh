#!/bin/bash

echo "Command line question : We want to retrieve the first 10 profiles who have published a post with a description longer than 100 characters and "
echo " output User not found for the posts which have a profile_id that isn't in the profiles dataset"
echo "Downloading instagram_posts.zip";
wget https://adm2022.s3.amazonaws.com/instagram_posts.zip;
echo "Done";
echo "Downloading instagram_profiles.zip";
wget https://adm2022.s3.amazonaws.com/instagram_profiles.zip;
echo "Done";
echo "Unzipping instagram_posts.zip";
unzip instagram_posts.zip;
echo "Done";
echo "Unzipping instagram_profiles.zip";
unzip instagram_profiles.zip;
echo "Done";
echo "Selection of only the columns of interest: post_id, profile_id and description and put them in a new file called sub_posts.csv";
cut -f 3,4,8 instagram_posts.csv | tr '\t' ',' > sub_posts.csv;
echo "Done";

echo "We go through the process to answer the query";
awk -F',' -vOFS=',' '{if (length($3) > 100) print $1, $2, length($3)}' sub_posts.csv | sort -t$',' -k3 -n | head -10 > query.csv;
echo "Done";


echo "Now, we are printing the results of the process, the profiles that answer the query are:";
awk -F',' -vOFS=',' '{if (length($2) == 0) print "There aren t posts with description with  more than 100 characters!"; else print $2}' query.csv;

echo "We have the first ten profiles that have a description longer than 100 characters, but some of them may not be found in the profiles. Now, we are searching these"
echo "profiles in the instagram_profiles.csv and we print out only the profiles that exist in this file."

grep '42361942\|8128232\|222026992\|1518481370\|230617661\|355470702\|222580681\|273342922\|335637382\|232070804' instagram_profiles.csv; 

