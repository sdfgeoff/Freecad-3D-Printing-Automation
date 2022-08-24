# Freecad 3d printing automation template
When working on a 3D printing project, I get tired of manually exporting STL's. The larger the project, the more cumbersome this becomes. In the software development world we often use build automation tools to accelerate this process, and I saw no reason why I couldn't do this for 3D printing.

The makefile in this repository:
 1. Exports as STL any files in the `CAD/exports` folder. Only object names ending with `object_name_stl` are exported. It doesn't matter if these objects are local to the file or linked from other documents.
 2. Generates gcode from the STL's. This is done with `prusa_slicer` and it relies on a config file (currently `tools/SnapmakerOriginalPLA.ini`). It assumes that the STL's are correctly oriented, so make sure that you do any transforms needed in the exports file.
 3. Uploads them to octoprint. To twiddle the URL/key, see the file `tools/upload_to_octoprint.py`

The way this is currently implemented it requires the file in the exports folder to change to kick off the process. FreeCAD often offers to do this on save. A future version of this repo may use `tup` insead of `make` because `tup` cleverly monitors what files are actually read at export time - so would automatically resolve cross-file links.

Gcode files are excluded from the git repo because they tend to be printer-specific. STL's are not because it's handy to have a record of old versions.
