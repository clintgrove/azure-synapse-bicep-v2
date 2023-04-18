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

NOTE! The first time you run this, it will probably fail! I know, I haven't found a way around yet. It has to do with the time delay in the Workspace having the firewall settings set up. Inside the bicep file you will see that we open up the firewall to all ip ranges. As I said this is a simple Synapse set up, so no fancy private networks. Just run the same very pipeline again a second time and it will succeed. 

 ### AzureCLI@2
 Running a bash file with arguments
 
 In the second task of the azure-pipelines.yml file you will see a AzureCLI@2 task. 
 ```
 - task: AzureCLI@2
  displayName: 'Assign role "Synapse Administrator"'
  inputs:
    azureSubscription: clintazrealallrgs
    scriptType: bash
    scriptLocation: 'scriptPath'
    scriptPath: '$(System.DefaultWorkingDirectory)/scripts/roleassignAdmin.sh'
    arguments: "groovyws${{lower(parameters.Environment)}} 4fe7fc36-b425-420f-a3f4-5e14e084eb5e"
 ```
 
 As you can see from the display name, I am adding people as users to the Synapse workspace. You can see the bash script "roleassignAdmin.sh" in the scripts/ folder.
 
 The arguments piece took me a while to learn. I hope it comes in handy for you at some point in the future. All you need to do to pass arguments to the .sh file is to put the argument in the right order. You will see that I have two arguments in the argument line above, they are in the correct order according to the variables in the .sh file
 
 
 ## Synapse Artifacts
 ### Creating and publishing in the workspace
 do some work in workspace
 publish
 ### Looking at the workspace_publish branch and using that to promote to next environment
 #### a new yaml file and a new release pipeline
 You will have a new yaml file which is in the branch workspace_publish 
 
 
 
 
 
 
