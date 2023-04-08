# Azure Synapse - How to promote Synapse artifacts to the next environment
 In this blog I have created a more simple synapse deployment. 
 - Ceate at a YAML file that will deploy a bicep infrastructure as code file. This bicep file will build a Synapse workspace, a Spark Pool and an Integration Runtime. 
 - Make some pipelines and a Notebook in the Synapse workspace and commit that to the main branch. 
 - Publish from the main branch 
 - The results from the publish action generate a new ARM template which we will use to action a "Synapse workspace deployment@2" task in YAML to promote this to the next Synapse workspace in a higher environment (from Dev to Test for example)
 - Add some access rights to get onto the workspace (taking note that the first time you deploy that the firewall rules may need time to kick in and your pipeline might fail)
 
 ## IAC
 ### AzureResourceManagerTemplateDeployment@3
 Info on bicep
 ### AzureCLI@2
 Running a bash file with arguments
 
 
 ## Synapse Artifacts
 ### Creating and publishing in the workspace
 do some work in workspace
 publish
 ### Looking at the workspace_publish branch and using that to promote to next environment
 #### a new yaml file and a new release pipeline
 
 
 
 
 
 
