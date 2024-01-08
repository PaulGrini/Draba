library(methods)

# Expect 9 columns per line: gene Ala Ala Ala Ala other other other other
# Four replicates of two conditions.

args<-commandArgs(trailingOnly=TRUE)
gene.counts<-args[1]
gene.sigs<-paste(args[1], "de", sep=".")

dax=read.table(gene.counts, header=FALSE, sep=",")

pseudocount=0.0 # in 2020, inputs are already normalized including pseudocounts
da<-log2(dax[,2:9]+pseudocount)

library(limma)
Group <- factor(c("Alaska","Alaska","Alaska","Alaska", "other", "other","other","other"))
design <- model.matrix(~0 + Group)
colnames(design) <- c("Alaska","other")
fit <- lmFit(da[,1:8],design)
contrast.matrix<-makeContrasts(Alaska-other, levels=design)
fit2<-contrasts.fit(fit,contrast.matrix)
fit2<-eBayes(fit2)
result1<-topTable(fit2,number=25000)

library(gtools)
x<-logratio2foldchange(result1$logFC, base=2)
res1<-cbind(result1,x)
write.csv(res1,gene.sigs)
