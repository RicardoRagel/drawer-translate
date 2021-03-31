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
                                "@TargetDir@/drawer_translate.exe", // Executable of the released app
                                "@StartMenuDir@/Drawer Translate.lnk", // Link name at the Start Menu
                                "workingDirectory=@TargetDir@", // Working directory
                                "iconPath=@TargetDir@/drawer_translate.exe", "iconId=0", // Icon
                                "description=An open-source translator widget at the bottom of your screen"); // Description to show
    }
}
