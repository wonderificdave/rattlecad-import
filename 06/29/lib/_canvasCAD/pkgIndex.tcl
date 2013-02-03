# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded canvasCAD  0.30 "\
            [list source [file join $dir canvasCAD.tcl]]; \
            [list source [file join $dir canvasCAD_tdom.tcl]]; \
            [list source [file join $dir canvasCAD_stage.tcl]]; \
            [list source [file join $dir canvasCAD_binding.tcl]]; \            
            [list source [file join $dir canvasCAD_utility.tcl]]; \
            [list source [file join $dir canvasCAD_IO.tcl]]; \
            [list source [file join $dir canvasCAD_svg_path.tcl]]; \
            [list source [file join $dir canvasCAD_print.tcl]]; \
            [list source [file join $dir vectormath.tcl]]; \
            [list source [file join $dir vectorfont.tcl]]; \
            [list source [file join $dir dimension.tcl]]; \
   "
