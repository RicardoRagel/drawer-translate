function Component()
{
    // default constructor
}

Component.prototype.createOperations = function()
{
    // call default implementation to actually install README.txt!
    component.createOperations();

    if (systemInfo.productType === "windows") {
        component.addOperation( "CreateShortcut", 
                                "@TargetDir@/translator_app.exe", // Executable of the released app
                                "@StartMenuDir@/Translator App.lnk", // Link name at the Start Menu
                                "workingDirectory=@TargetDir@", // Working directory
                                "iconPath=@TargetDir@/translator_app.exe", "iconId=0", // Icon
                                "description=An open-source translator widget at the bottom of your screen"); // Description to show
    }
}
