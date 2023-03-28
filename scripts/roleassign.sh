#az synapse role assignment list --workspace-name groovywstest --role "Synapse Administrator" --assignee 4fe7fc36-b425-420f-a3f4-5e14e084eb5e
if [[ $(az synapse role assignment create --workspace-name groovywstest --role "Synapse Administrator" --assignee '4fe7fc36-b425-420f-a3f4-5e14e084eb5e') <0 ]]
then 
 echo "Assignment already exists" 
else 
 az synapse role assignment create --workspace-name groovywstest --role "Synapse Administrator" --assignee '4fe7fc36-b425-420f-a3f4-5e14e084eb5e'
 echo "Assignment applied"
fi 