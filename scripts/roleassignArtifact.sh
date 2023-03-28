objectid='98c07b1c-fc74-4941-85e3-771788c82c15'
synapseWS='groovywstest'
if [[ $(az synapse role assignment create --workspace-name $synapseWS --role "Synapse Artifact Publisher" --assignee $objectid ) <0 ]]
then 
 echo "Assignment already exists" 
else 
 az synapse role assignment create --workspace-name $synapseWS --role "Synapse Artifact Publisher" --assignee $objectid
 echo "Assignment applied"
fi 

#98c07b1c-fc74-4941-85e3-771788c82c15
#4fe7fc36-b425-420f-a3f4-5e14e084eb5e
#Synapse Administrator