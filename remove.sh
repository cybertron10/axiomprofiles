bbrf programs > programs;
for program in $(cat programs); do
bbrf rm $program;
done
