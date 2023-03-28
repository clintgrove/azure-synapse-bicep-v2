synapseWS=$1
objectid=$2

if [[ $(az synapse role assignment create --workspace-name $synapseWS --role "Synapse Artifact Publisher" --assignee $objectid ) <0 ]]
then 
 echo "Assignment already exists" 
else 
 az synapse role assignment create --workspace-name $synapseWS --role "Synapse Artifact Publisher" --assignee $objectid
 echo "Assignment applied"
fi 
