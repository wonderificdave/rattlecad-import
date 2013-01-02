# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded   rattleCAD  3.3 "\ 
        [list source  [file join $dir rattleCAD.tcl]]; \ 
        [list source  [file join $dir lib_file.tcl]]; \
        [list source  [file join $dir lib_project.tcl]]; \
        [list source  [file join $dir lib_gui.tcl]]; \
        [list source  [file join $dir lib_cfg_report.tcl]]; \
        [list source  [file join $dir lib_config.tcl]]; \
        [list source  [file join $dir lib_comp_library.tcl]]; \
        [list source  [file join $dir lib_frame_geometry.tcl]]; \
        [list source  [file join $dir lib_frame_geometryUpdate.tcl]]; \
        [list source  [file join $dir lib_frame_geometryExtend.tcl]]; \
        [list source  [file join $dir lib_frame_visualisation.tcl]]; \
        [list source  [file join $dir lib_version_info.tcl]]; \
        [list source  [file join $dir lib_tube.tcl]]; \
        [list source  [file join $dir lib_cv_custom.tcl]]; \
        [list source  [file join $dir lib_cv_customRearMockup.tcl]]; \
        [list source  [file join $dir lib_cv_customUpdate.tcl]]; \
   "

 # .. unused since 3.1.00
 # [list source  [file join $dir lib_control.tcl]]; 
 # [list source  [file join $dir lib_frame_ref_geometry.tcl]]; \        
