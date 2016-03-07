#MOLGENIS walltime=23:59:00 mem=8gb nodes=1 ppn=2

### variables to help adding to database (have to use weave)
#string sampleName
#string project
###
#string stage
#string checkStage

#string WORKDIR
#string projectDir
#string beagleDir

#string beagleVersion

#string genotypedChrVcf
#string genotypedChrVcfIdx

#string genotypedChrVcfBeagleGenotypeProbabilities
#string chr

echo "## "$(date)" Start $0"


getFile ${genotypedChrVcf}
getFile ${genotypedChrVcfIdx}


${stage} beagle/${beagleVersion}
${checkStage}

mkdir -p ${beagleDir}

if java -Xmx6g -XX:ParallelGCThreads=2 -jar $EBROOTBEAGLE/beagle.$beagleVersion.jar \
 gl=${genotypedChrVcf} \
 out=${genotypedChrVcfBeagleGenotypeProbabilities} \
 chrom=${chr}
then
 echo "returncode: $?";
 putFile ${genotypedChrVcfBeagleGenotypeProbabilities}
 cd ${beagleDir}
 bname=$(basename ${genotypedChrVcfBeagleGenotypeProbabilities})
 md5sum ${bname} > ${bname}.md5
 cd -
 echo "succes moving files";
else
 echo "returncode: $?";
 echo "fail";
fi

echo "## "$(date)" ##  $0 Done "
