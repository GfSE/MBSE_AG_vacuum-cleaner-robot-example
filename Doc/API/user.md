# SysML v2 API Usage Documentation



## Publishing models

The API has an integrated Model Server that structures the SysML v2 model in conformance with the specification.
Each element (including relationships) gets a unique ID and is structured with respective relations.

To achieve this, models have to be published to the server.
Here, dedicated jupyter kernels exist, which can be installed with conda: https://www.npmjs.com/package/@systems-modeling/jupyterlab-sysml (current version: 0.52.1)

Some jupyter lab environments already include this kernel such as [Sysmlv2Lab](https://www.sysmlv2lab.com) (thanks to @Weilkiti for hosting).
This will used as an example for the interaction.

Open the platform and create a new SysML v2 Notebook (orange button).

![alt text](../assets/API_JupyterLab_Start.png)

Copy the content of [integration.sysml](https://github.com/GfSE/MBSE_AG_vacuum-cleaner-robot-example/blob/f5a84d3f6d2aa9acf7e1061789404ea41492a850/Functions/Integration/Integration.sysml) into the Cell:

> [!CAUTION]
> As the current ``master`` branch has several issues in the Integration file an old commit is used. 
> Please check that you are using the correct file.

![alt text](../assets/API_JupyterLab_Cell.png)

Press ``Ctrl+Enter`` to start the compilation.

This will create the packages mentioned in the Integration and give them a unique ID:

![alt text](../assets/API_JupyterLab_Packages.png)

You can vizualize them by using the ``%viz`` command in a new cell (press the + button on top).
You have to reference the name with name with ticks to show that it is one name.
Components within a package can be addressed by using the ``::`` notation in breaking them down.

![alt text](../assets/API_JupyterLab_Viz.png)

To publish it use ``%publish "Robotic Vacuum Cleaner"`` or any other of the packages.
This will then be pushed to the configured API server (in case of [Sysmlv2Lab](https://www.sysmlv2lab.com) to [intercax](http://sysml2.intercax.com:9000/docs/).)

![alt text](../assets/API_JupyterLab_Publish.png)

> [!NOTE]
> Both the SysML v2 Lab and the Intercax Server are regularly purged as they are only intended for testing.
 > Once this is done a new id will be created - always check your ID!

## Looking up models

In the following the