you can find sir that i have done everysingle thing as you said

i solved the issue of the .h file to be sensed twice using 2 different methodolgies 

the first way that i stated some dependencies which are the .h file and added them to the make file dependencies for each target

for each file.o target i add the .c and the .h files that it uses 

by using this methodologies i mad the make file sense the change at the .h file 

it is a very tedious way when dealing with hundreds of files i know 

so i searched for a workaround for solving that issue 

i made a .d file for each .c file and the .d containing the dependencies in that .c file

sothat i don't need to state it manually like i did at the first methodology 

and that solves the problem of tedious stuff
