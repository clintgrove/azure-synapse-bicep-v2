# Azure Synapse - How to build a Synapse Workspace and promote it's artifacts to the next environment
 In this blog I have created a simple synapse deployment. You will learn about the following things:
 
 - Create at a YAML file that will deploy a bicep infrastructure as code file. This bicep file will build a Synapse workspace, a Spark Pool and an Integration Runtime. 
 - Make some pipelines and a Notebook in the Synapse workspace and commit that to the main branch. 
 - Publish from the main branch so that artifacts like pipelines and so on get committed to the "live" workspace
 - The results from the publish action generate a new ARM template which we will use to action a "Synapse workspace deployment@2" task in YAML to promote this to the next Synapse workspace in a higher environment (from Dev to Test for example)
 - Add some access rights to get onto the workspace (taking note that the first time you deploy that the firewall rules may need time to kick in and your pipeline might fail)
 
 ## IAC
 ### AzureResourceManagerTemplateDeployment@3

 When creating a new Synapse Workspace it is necessary to have a linked storage account. We will create this storage account alongside the Synapse workspace. You can find the bicep file in ../modules/synapse.bicep.
 
Starting with the yaml file that kicks off first in the DevOps project, you can see that azure-pipelines.yml has no branch trigger (so no automated CI/CD). It has parameters for the user to select which enviornment to run the pipeline for. It has a library call as you can see in this code

```
variables:
     - group: ${{parameters.Environment}}-vars
```
This calls a library from your DevOps area
<br>
<img width="390" alt="image" src="https://user-images.githubusercontent.com/30802291/231078348-2e918a3e-3f4d-4bc9-ac76-199a46f1c427.png">

The `steps: ` section is where the first task is called to build an Azure resource (in this case our Synapse Workspace and Storage Account)

```
steps:

- task: AzureResourceManagerTemplateDeployment@3
```

In the "modules" folder you will see a file called synapse.bicep. This bicep file creates the Synapse Workspace, the Storage Account, the firewall rules, a Spark Pool and does some role assigments.

 ### AzureCLI@2
 Running a bash file with arguments
 
 
 ## Synapse Artifacts
 ### Creating and publishing in the workspace
 do some work in workspace
 publish
 ### Looking at the workspace_publish branch and using that to promote to next environment
 #### a new yaml file and a new release pipeline
 You will have a new yaml file which is in the branch workspace_publish 
 
 
 
 
 
 
