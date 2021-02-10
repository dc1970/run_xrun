#!/bin/csh -f

# 
# setenv SPECMAN_PATH    "$CDS_PATH/patches:.:com:e_src/dalton/e:e_src/wb_mdl_lib/e:e_src/wb_misc_lib/e:e_src/wb_espi_mdl/e:exec/rh4:./evc:./e_src"
# Run from terminal: run_xrun.csh -espi -f dalton_files -input runtest.ecom 
# Run from screept : run_xrun.csh -espi -f dalton_files -input runtest.ecom $argv

#parse command flags
#-------------------

#compile mode: Load/Compile. Default Load -
set xrun_flags = ''
set comp_mode = '-sncompargs -enable_DAC'
set run_mode = '-exit'
set cds_ver = XCL2009
set indago_ver = INDAGO2009 
foreach p ($argv)
    switch ($p)
    case '-espi':
        shift
        setenv SPECMAN_PRE_COMMANDS "global.host_bus = ESPI"
        breaksw
    case '-lpc':
        shift
        setenv SPECMAN_PRE_COMMANDS "global.host_bus = LPC"
        breaksw
    case '-cds_ver':
        shift
        set cds_ver = $p
        shift
        breaksw
    case '-indago_ver':
        shift
        set indago_ver = $p
        shift
        breaksw
    case '-gui':
        set run_mode = ''
        set xrun_flags = ($xrun_flags $p)
        shift
        breaksw
    case '-nosncom':
        set comp_mode = ''
        set xrun_flags = ($xrun_flags $p)
        shift
        breaksw
    default:
        set xrun_flags = ($xrun_flags $p)
        shift
        breaksw
    endsw
end

# ENV Variables (From nc_ifc)
setenv CDS_PLACE       /users/cadence
setenv CDS_REV         $cds_ver
setenv CDS_PATH        $CDS_PLACE/$CDS_REV

setenv LM_LICENSE_FILE        "5280@rdlnx116:5280@rdlnx144"
setenv VRST_HOME       $CDS_PATH
setenv INDAGO_ROOT     $CDS_PLACE/$indago_ver

# replace add_check_path
set path = ($path $CDS_PATH/bin)
set path = ($path $CDS_PATH/tools)
set path = ($path $CDS_PATH/tools/bin)

source $CDS_PATH/env.csh


# Build run command
set xrun_run_cmd = "xrun $run_mode $comp_mode $xrun_flags" 

#run command
echo $xrun_run_cmd
$xrun_run_cmd

