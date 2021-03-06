# First cd to the directory with the *.sh and *.finished scripts
<#noparse>
MOLGENIS_scriptsDir=$( cd -P "$( dirname "$0" )" && pwd )
echo "cd $MOLGENIS_scriptsDir"
cd $MOLGENIS_scriptsDir
</#noparse>

touch molgenis.submit.started

# Use this to indicate that we skip a step
skip(){
echo "0: Skipped --- TASK '$1' --- ON $(date +"%Y-%m-%d %T")" >> molgenis.skipped.log
}

<#foreach t in tasks>
#
##${t.name}
#

# Skip this step if step finished already successfully
if [ -f ${t.name}.sh.finished ]; then
skip ${t.name}.sh
echo "Skipped ${t.name}.sh"
else
# Build dependency string
dependenciesExist=false
dependencies="--dependency=afterok"
    <#foreach d in t.previousTasks>
    if [[ -n "$${d}" ]]; then
    dependenciesExist=true
    dependencies="<#noparse>${dependencies}</#noparse>:$${d}"
    fi
    </#foreach>
if ! $dependenciesExist; then
unset dependencies
fi
output=$(sbatch $dependencies ${t.name}.sh)
id=${t.name}
${t.name}=<#noparse>${output##"Submitted batch job "}</#noparse>
echo "$id:$${t.name}"
fi

</#foreach>

touch molgenis.submit.finished