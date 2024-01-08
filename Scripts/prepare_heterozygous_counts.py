import argparse
import traceback
import csv
import sys

class Experimental_Design ():
    def __init__(self,model_filename):
        self.mfn = model_filename
        self.reps = {}  # dictionary of string:list
    def load_model(self):
        with open(self.mfn, 'rt') as tsvfile:
            reader = csv.DictReader(tsvfile, delimiter="\t")
            for row in reader: # row is a dict
                cross=row['Cross']
                self.add_row(cross,row)
    def add_row(self,cross,details):
        if cross not in self.reps:
            self.reps[cross]=[]  # empty list
        self.reps[cross].append(details)
    def self_describe(self):
        for k in self.reps.keys():
            print(k)
            for r in self.reps[k]:
                print(r)
    def get_crosses(self):
        return self.reps.keys()
    def get_details(self,cross):
        if cross not in self.reps:
            return None
        return self.reps[cross]

class One_Cross ():

    def __init__(self,cross):
        self.cross = cross

    def set_replicates(self,reps):
        self.mat=None
        self.pat=None
        self.replicates = reps
        self.num_replicates=len(reps)
        self.gene_data = {}  # dict of gene: list of counts

    def load_cross(self):
        repnum=0
        for replicate in self.replicates:
            repnum = repnum + 1
            if self.mat == None:
                self.mat=replicate['Mat']
            elif self.mat != replicate['Mat']:
                raise Exception("Replicate with different mother.")
            if self.pat == None:
                self.pat=replicate['Pat']
            elif self.pat != replicate['Pat']:
                raise Exception("Replicate with different father.")
            matmult=replicate['MatMult']
            mult=self.to_float(matmult)
            file=replicate['Replicate']
            norm=replicate['Norm']
            norm=self.to_float(norm)
            self.load_replicate(mult,file,repnum,norm)

    def to_float(self,numstr):
        answer=None
        # This is designed for interpreting multiplier columns
        # within the input model file.
        # Users should write "1.0" for no multiplication effect.
        # If we see a zero, assume the user didn't mean to multiply
        # all read counts by zero!
        if numstr!="" and numstr!="0" and numstr!="0.0":
            try:
                answer=float(numstr)
            except Exception:
                pass
        return answer

    def load_replicate(self,mult,fn,num,norm):
        gd = self.gene_data
        nr = self.num_replicates
        ROUND=0.5
        PSEUDOCOUNT=1
        with open(fn, 'rt') as tsvfile:
            reader = csv.DictReader(tsvfile, delimiter="\t")
            for row in reader: # row is a dict
                gene=row['gene']
                allele=row['allele']
                count=int(row['count']) + PSEUDOCOUNT
                if norm != None:
                    count=int(count * norm + ROUND)
                if allele==self.mat and mult != None:
                    # MatMult=0.5  means cut maternal count in half
                    count = int(count * mult + ROUND)
                if allele==self.mat:
                    column=num 
                elif allele==self.pat:
                    column=num+nr 
                if gene not in gd.keys():
                    gd[gene]=[PSEUDOCOUNT]*(2*nr+1) # zero in every col
                gd[gene][column]=count # leave list element 0 for gene
                gd[gene][0]=gene

    def print_cross(self):
        gd = self.gene_data
        fn=self.cross+".counts.csv"
        with open(fn, 'wt') as csvfile:
            writer = csv.writer(csvfile, delimiter=",")
            for gene in gd.keys():
                gene_plus_counts=gd[gene]
                writer.writerow(gene_plus_counts)
                #debug: print(*mylist,sep=",")

class Tests ():
    def __init__(self,prefix):
        self.filename=prefix
    def write_test_files(self):
        model=self.filename+"_model.tsv"
        rep1=self.filename+"_CrossA_replicate1.tsv"
        rep2=self.filename+"_CrossA_replicate2.tsv"
        rep3=self.filename+"_CrossA_replicate3.tsv"
        rep4=self.filename+"_CrossA_replicate4.tsv"
        with open(model, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
        rep3=self.filename+"_CrossA_replicate3.tsv"
        rep4=self.filename+"_CrossA_replicate4.tsv"
        with open(model, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
            tsv_writer.writerow(['Cross','Mat','Pat','MatMult','Replicate'])
            tsv_writer.writerow(['test','Alaska','Norway','0.5',rep1,1.0])
            tsv_writer.writerow(['test','Alaska','Norway','0.5',rep2,1.0])
            tsv_writer.writerow(['test','Alaska','Norway','0.5',rep3,1.0])
            tsv_writer.writerow(['test','Alaska','Norway','0.5',rep4,1.0])
        with open(rep1, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
            tsv_writer.writerow(['gene','allele','count'])
            tsv_writer.writerow(['GENE1','Alaska','193'])
            tsv_writer.writerow(['GENE1','Norway','197'])
        with open(rep2, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
            tsv_writer.writerow(['gene','allele','count'])
            tsv_writer.writerow(['GENE1','Alaska','250'])
            tsv_writer.writerow(['GENE1','Norway','260'])
        with open(rep3, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
            tsv_writer.writerow(['gene','allele','count'])
            tsv_writer.writerow(['GENE1','Alaska','302'])
            tsv_writer.writerow(['GENE1','Norway','300'])
        with open(rep4, 'wt') as outfile:
            tsv_writer = csv.writer(outfile, delimiter='\t')
            tsv_writer.writerow(['gene','allele','count'])
            tsv_writer.writerow(['GENE1','Alaska','345'])
            tsv_writer.writerow(['GENE1','Norway','354'])
        return model

def say(statement):
    try:
        if (args.debug):
            print(statement, file=sys.stderr, end="\n")
    except Exception:
        pass

def args_parse():
    global args
    parser = argparse.ArgumentParser(description='Prepare counts for statistics step.')
    parser.add_argument('model', help = 'File that defines the inputs (tsv)', type=str)
    parser.add_argument('--test', help = 'Generate and process test files', action = 'store_true')
    parser.add_argument('--debug', action = 'store_true')
    args = parser.parse_args()  # on error, program exits

if __name__ == '__main__':
    """
    Command line invocation:
    $ python3 Prepare_Heterozygous_Counts.py --help
    $ python3 Prepare_Heterozygous_Counts.py anyprefix --test
    $ python3 Prepare_Heterozygous_Counts.py my_model.tsv --debug
    """
    try:
        args_parse()
        model_name=args.model
        if args.test:
            tests = Tests(model_name)
            model_name=tests.write_test_files()
        modeler = Experimental_Design(model_name)
        modeler.load_model()
        if (args.debug):
            modeler.self_describe()
        for cross in modeler.get_crosses():
            cc = One_Cross(cross)
            cc.set_replicates(modeler.get_details(cross))
            cc.load_cross()
            cc.print_cross()

    except Exception as e:
        print("\nThere was an error.")
        if args.debug:
            print(traceback.format_exc())
        else:
            print ('Consider running with --debug')
