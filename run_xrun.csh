#!/bin/csh -f

#parse command flags
#-------------------

#compile mode: Load/Compile. Default Load -
set comp_mode = '-sncompargs -enable_DAC'
set xrun_flags = ''
set libdir_name = '-xmlibdirname proj_libdid'
set libdir_path = '-xmlibdirpath ./'

while ("$1" =~ -*)
    switch ($1)
    case '-no_sncomp':
        set comp_mode = '-nosncom'
        shift
        breaksw
    case '-gui':
        set  xrun_flags = ($xrun_flags' -gui')
        shift
        breaksw 
    case '-fl':
         shift
        set xrun_flags = ($xrun_flags $1)
        shift
        breaksw
    case '-lib_name':
        shift
        set libdir_name = ('-xmlibdirname' $1)
        shift
        breaksw
    case '-lib_path':
        shift
        set libdir_name = ('-xmlibdirpath' $1)
        shift
        breaksw
    default:
        echo 'Wrong parameters (Need to add usage instructions)'
        exit -1
        breaksw
    endsw
end

# ENV Variables (From nc_ifc)
setenv CDS_PLACE       /users/cadence
setenv CDS_REV         XCL2009
setenv CDS_PATH        $CDS_PLACE/$CDS_REV

setenv LM_LICENSE_FILE        "5280@rdlnx116:5280@rdlnx144"
setenv VRST_HOME       $CDS_PATH
setenv INDAGO_ROOT     $CDS_PLACE/INDAGO2009

# replace add_check_path
set path = ($path $CDS_PATH/bin)
set path = ($path $CDS_PATH/tools)
set path = ($path $CDS_PATH/tools/bin)

source $CDS_PATH/env.csh

setenv SPECMAN_PATH    "$CDS_PATH/patches:.:com:e_src/dalton/e:e_src/wb_mdl_lib/e:e_src/wb_misc_lib/e:e_src/wb_espi_mdl/e:exec/rh4:./evc:./e_src"
setenv SPECMAN_PRE_COMMANDS "global.host_bus = ESPI"

# Build run command
set xrun_run_cmd = "xrun -f dalton_files  -input runtest.ecom -exit"
set xrun_run_cmd = ($xrun_run_cmd $comp_mode) 
set xrun_run_cmd = ($xrun_run_cmd $xrun_flags) 
set xrun_run_cmd = ($xrun_run_cmd $libdir_name) 
set xrun_run_cmd = ($xrun_run_cmd $libdir_path) 

#run command
echo $xrun_run_cmd
$xrun_run_cmd

