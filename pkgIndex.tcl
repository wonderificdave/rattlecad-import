# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded bikeGeometry  1.57 "\
            [list source [file join $dir lib project3x project.tcl]]; \
            [list source [file join $dir lib project3x lib_projectUpdate.tcl]]; \
                \
            [list source [file join $dir lib bikeGeometry.tcl]]; \
            [list source [file join $dir lib model_freeAngle.tcl]]; \
            [list source [file join $dir lib model_lugAngle.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometry.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryExt.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryFork.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryComponents.tcl]]; \
            [list source [file join $dir lib lib_bikeGeometryFrameTubes.tcl]]; \
            [list source [file join $dir lib lib_tube.tcl]]; \
                \
            [list source [file join $dir lib lib_validate.tcl]]; \
                \
            [list source [file join $dir lib IF_OutsideIn.tcl]]; \
            [list source [file join $dir lib IF_StackReach.tcl]]; \
            [list source [file join $dir lib IF_LugAngles.tcl]]; \
            [list source [file join $dir lib IF_Classic.tcl]]; \
        "

# [list source [file join $dir lib lib_bikeGeometryResult.tcl]]; \      
# [list source [file join $dir lib fruit.tcl]]; 
# [list source [file join $dir lib lib_geometry.tcl]]; \
# [list source [file join $dir lib lib_components.tcl]]; \
# [list source [file join $dir lib lib_frametubes.tcl]]; \
            