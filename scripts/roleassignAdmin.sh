synapseWS=$1
objectid=$2 
echo $synapseWS
echo $objectid
 if [[ $(az synapse role assignment create --workspace-name $synapseWS --role "Synapse Administrator" --assignee $objectid) <0 ]]
then 
 echo "Assignment already exists" 
else 
 az synapse role assignment create --workspace-name $synapseWS --role "Synapse Administrator" --assignee $objectid
 echo "Assignment applied"
fi 

