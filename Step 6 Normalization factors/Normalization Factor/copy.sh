# Collect counts.tsv files in this folder

for D in Sample_*/;
do
    cp ../$D/*.tsv .
done
echo DONE
