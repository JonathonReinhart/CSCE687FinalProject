

== Setting up SDK (Eclipse) workspace ==

Eclipse workspace is not stored in SVN.  After checking out:

 1) Open Xilinx SDK.
    When it prompts you for a workspace directory, point it at the XPS/SDK/SDK_Export subdirectory.

 2) Import projects.
    a)  Select File -> Import. In the Import dialog, under General, select
        "Existing Projects into Workspace". Click Next.
    b)  Select root directory of XPS/SDK/SDK_Export. (It should already be there in the tree)
        The projects should appear under Projects: below. Click Finish.
    
    At this point, everything should build. But there's more.
    
 3) Add local drivers repository (workaround bug in SDK 13.2)
    a)  Select Xilinx Tools -> Repositories.
    b)  Click New... beside Local Repositories. 
    c)  Navigate to and select the XPS directory (not a subdirectory!)
    d)  Click Rescan Repositories and click OK.
    Now BSP settings will work.

    
    