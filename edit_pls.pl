#!/usr/bin/perl
# -w


use 	Tk;
require Tk::ROText;
require	Tk::Font;
require Tk::Dialog;
require	Tk::LabEntry;
use	Tk::ErrorDialog;
use 	Time::HiRes "usleep";
use 	Tk ':eventtypes';
use 	Cwd;



$index = 0;

%bit2name = (1, ecn_value, 2, bol_value, 4, via_value, 8, pdr_value,
            16, smd_value, 32, ptp_value, 64, pbt_value, 128, sst_value,
            256, sbt_value, 512, sbb_value, 1024, gst_value, 2048, cnm_value,
            4096, cvl_value, 8192, drh_value, 16384, drc_value, 32768, rfl_value,
            65536, osz_value, 131072, npl_value, 262144, drf_value,
            );
%name2bit = (ecn_value, 1, bol_value, 2, via_value, 4, pdr_value, 8,
            smd_value, 16, ptp_value, 32, pbt_value, 64, sst_value, 128,
            sbt_value, 256, sbb_value, 512, gst_value, 1024, cnm_value, 2048,
            cvl_value, 4096, drh_value, 8192, drc_value, 16384, rfl_value, 32768,           
            osz_value, 65536, npl_value, 131072, drf_value, 262144,
            );

$filechange = 0;

#======================================================================================
#
# create main window and set size
#
#======================================================================================
	my $mw=MainWindow->new(-title => edit_pls , -bg => 'steelblue', -takefocus => '1');
	$mw->geometry("800x640");
	$mw->Font("arial 6 bold");
#	$mw-resizable(0,0);

#
#
#

	$trace = $mw->Frame(
			
			)->place(-relx => 0.05, -rely => 0.05);

	$pad = $mw->Frame(

			)->place(-relx => 0.05, -rely => 0.09);

	$pad->Label(
			-text => "Padlayer  ",
            -font => ("courier 12 bold"),
			)->pack(-side => 'left');

	$trace->Label(
			-text => "Tracelayer",
            -font => ("courier 12 bold"),
			)->pack(-side => 'left');

	foreach (qw( 1 4 3 6 5 8 7 2)) {
			$pad->Radiobutton(
					-text => $_,
					-value => $_,
					-variable => \$padlayers,
					)->pack( -side => 'left');
	}

	foreach (qw( 1 4 3 6 5 8 7 2)) {
			$trace->Radiobutton(
					-text => $_,
					-value => $_,
					-variable => \$tracelayers,
					)->pack( -side => 'left');
	}

    $mw->Checkbutton (
            -text => "Extended Corners                      ",
            -variable => \$ecn_value,
            -font => ("courier 12 bold"),
            )->place(-relx =>  0.05, -rely => 0.13);
            
    $mw->Checkbutton (
            -text => "Board Outlines                        ",
            -font => ("courier 12 bold"),
            -variable => \$bol_value,
            )->place(-relx =>  0.05, -rely => 0.17);
            
    $mw->Checkbutton (
            -text => "Via's                                 ",
            -font => ("courier 12 bold"),
            -variable => \$via_value,
            )->place(-relx =>  0.05, -rely => 0.21);
            
    $mw->Checkbutton (
            -text => "Pads Drilled                          ",
            -font => ("courier 12 bold"),
            -variable => \$pdr_value,
            )->place(-relx =>  0.05, -rely => 0.25);
            
    $mw->Checkbutton (
            -text => "SMD Pads                              ",
            -font => ("courier 12 bold"),
            -variable => \$smd_value,
            )->place(-relx =>  0.05, -rely => 0.29);
            
    $mw->Checkbutton (
            -text => "Pin1 Mark Topside                     ",
            -font => ("courier 12 bold"),
            -variable => \$ptp_value,
            )->place(-relx =>  0.05, -rely => 0.33);
            
    $mw->Checkbutton (
            -text => "Pin1 Mark Bottomside                  ",
            -font => ("courier 12 bold"),
            -variable => \$pbt_value,
            )->place(-relx =>  0.05, -rely => 0.37);
            
    $mw->Checkbutton (
            -text => "Silkscreen Topside                    ",
            -font => ("courier 12 bold"),
            -variable => \$sst_value,
            )->place(-relx =>  0.05, -rely => 0.41);
            
    $mw->Checkbutton (
            -text => "Silkscreen Bottomside (topview)       ",
            -font => ("courier 12 bold"),
            -variable => \$sbt_value,
            )->place(-relx =>  0.05, -rely => 0.45);
            
    $mw->Checkbutton (
            -text => "Silkscreen Bottomside (bottomview)    ",
            -font => ("courier 12 bold"),
            -variable => \$sbb_value,
            )->place(-relx =>  0.05, -rely => 0.49);
            
    $mw->Checkbutton (
            -text => "General Silk Text                     ",
            -font => ("courier 12 bold"),
            -variable => \$gst_value,
            )->place(-relx =>  0.05, -rely => 0.53);
            
    $mw->Checkbutton (
            -text => "Component Names                       ",
            -font => ("courier 12 bold"),
            -variable => \$cnm_value,
            )->place(-relx =>  0.05, -rely => 0.57);
            
    $mw->Checkbutton (
            -text => "Component Values                      ",
            -font => ("courier 12 bold"),
            -variable => \$cvl_value,
            )->place(-relx =>  0.05, -rely => 0.61);
            
    $mw->Checkbutton (
            -text => "Drilling Holes                         ",
            -font => ("courier 12 bold"),
            -variable => \$drh_value,
            )->place(-relx =>  0.05, -rely => 0.65);
            
    $mw->Checkbutton (
            -text => "Drill Center Points                   ",
            -font => ("courier 12 bold"),
            -variable => \$drc_value,
            )->place(-relx =>  0.05, -rely => 0.69);
            
    $mw->Checkbutton (
            -text => "Reflection                            ",
            -font => ("courier 12 bold"),
            -variable => \$rfl_value,
            )->place(-relx =>  0.05, -rely => 0.73);
            
    $mw->Checkbutton (
            -text => "Oversize                              ",
            -font => ("courier 12 bold"),
            -variable => \$osz_value,
            )->place(-relx =>  0.05, -rely => 0.77);
            
    $mw->Checkbutton (
            -text => "Negative (thermal break) plane layer  ",
            -font => ("courier 12 bold"),
            -variable => \$npl_value,
            )->place(-relx =>  0.05, -rely => 0.81);
            
    $mw->Checkbutton (
            -text => "Drill Reference Point                 ",
            -font => ("courier 12 bold"),
            -variable => \$drf_value,
            )->place(-relx =>  0.05, -rely => 0.85);

    $mw->LabEntry(
            -textvariable => \$index,
            -label => "Plot Select",
            -width => 16,
            -state => 'disabled',
            -justify => 'center',
            )->place(-relx => 0.125 , -rely => 0.90);

    $mw->Button(
            -text => "Prev",
            -command => \&LowerPlot,
            )->place(-relx => 0.05, -rely => 0.92);

    $mw->Button(
            -text => "Next",
            -command => \&HigherPlot,
            )->place(-relx => 0.28, -rely => 0.92);

    $mw->LabEntry(
            -textvariable => \$osv_value,
            -label => "oversize value (mill)",
            -width => 16,
            )->place(-relx => 0.60 , -rely => 0.74);

    $mw->LabEntry(
            -textvariable => \$pls_version,
            -label => "software version",
            -width => 16,
            -state => 'disabled',
            )->place(-relx => 0.60 , -rely => 0.05);




#########################################
#
# GO button
#
	$gobutton = $mw->Button(
			-fg => 'green',
			-relief => 'raised',
			-height => 2,
			-width => 5,
			-activebackground => 'yellow',
			-text => 'Save',
			-command => \&SaveData,
			)->place(-relx => 0.80, -rely => 0.90);

########################################
#
# Exit button
#
	$exitbutton = $mw->Button(
			-fg => 'red',
			-relief => 'raised',
			-height => 2,
			-width => 5,
			-activebackground => 'yellow',
			-text => 'Exit',
			-command => \&Cleanup,
			)->place(-relx => 0.905, -rely => 0.90);



	if ($#ARGV < 0)
	{
		print ("usage:  edit_pls  <> \n");
		print ("< file >	name of PLS file\n");
		exit(1);
	}
	
#
# read in the PLS file as a whole
#
	open(PLSFILE, "$ARGV[0]") || die "can't open plot PLS file $ARGV[1] !\n";
    
    while (<PLSFILE>)
    {
        chomp;
        $_ =~ s/[\x00-\x1f]//g;  # strip control characters
        
        push @regels, $_;
    }
    close PLSFILE;    

#
# copy relevant data and do some sanity checks
#    
    $pls_version = shift @regels;
    $pls_trailer = pop @regels;  
    if ((scalar @regels) != 50)
    {
        printf "edit_pls: file has only %d data lines, expect 50...\n",   (scalar @regels) ;
        exit 1;
    }

    &FillData;

#
#
#
MainLoop();

#
# Functions
#  
    
sub Cleanup
{
    my ($res, $line) = &CheckData;

    if ($res != 0)
    {
        $regels[$index] = $line;
        $filechange = 1;
    }       
    if ($filechange == 1)
    {
print "**** SAVE\n";        
        
       &SaveData; 
    }    
    
    
    
    exit;
}

#
# Write out data back to file
#
sub SaveData
{
    my $line;
    
    
    open OUTFILE, ">$ARGV[0]" || die "Can't open $ARGV[0] file for output!\n";
    
    print OUTFILE $pls_version."\r\n";
    
    foreach $line (@regels)
    {
        print OUTFILE $line."\r\n";
    }
    
    print OUTFILE $pls_trailer."\r\n";
    
    close OUTFILE;
}

#
# select lower plot number
#
sub LowerPlot
{
    my ($res, $line) = &CheckData;
    
    if ($res != 0)
    {
        $regels[$index] = $line;
        $filechange = 1;
    }

    if ($index > 0)
    {
        $index--;
    }
 
    &FillData;
}

#
# select higher plot number
#
sub HigherPlot
{
    my ($res, $line) = &CheckData;

    if ($res != 0)
    {
        $regels[$index] = $line;
        $filechange = 1;
    }   
     
    if ($index < 49)
    {
        $index++;
    }

    &FillData;  
}

#
# fill in the form,  $index is global
#
sub FillData
{
    
    my  $line = $regels[$index];
    $line =~ s/\#//g;  # strip control characters    
    $line =~ s/\;//g;  # strip control characters
    my @items = split (/,/, $line);
   
	$pad->Radiobutton->configure(-value => \$items[1]);
	$padlayers = $items[1];

	$trace->Radiobutton->configure(-value => \$items[0]);
	$tracelayers = $items[0];

    &items2vars($items[2]);

    $osv_value = $items[3];

}

#
# check form data with values
#
sub CheckData
{
    my  $line = $regels[$index];
    $line =~ s/\#//g;  # strip control characters    
    $line =~ s/\;//g;  # strip control characters
    my @items = split (/,/, $line);   
    my $status = 0;
    my $tval = 0;
    
	$items[1] = $padlayers;
    $tval = 0;

    $items[0] = $tracelayers;

    $tval = &vars2items;
    
    if ($tval != hex($items[2]))
    {
        $status = 1;
    }
    $items[2] = $tval;
         
    if ($osv_value != $items[3])
    {
        $status = 1;
    }
    $items[3] = $osv_value;
    
    $line = sprintf "\#%d,%d,%x,%d,%d\;", $items[0], $items[1], $items[2], $items[3], $items[4];
  
    return ($status, $line);
}

#
# update form variables
#
sub items2vars()
{
    my $decimalvalue = hex ($_[0]);

    my $vname;
    
    for ($v = 1; $v < 524288  ; $v *= 2)
    {
        $vname = $bit2name{$v};
        if ($decimalvalue & $v)
        {
            $vval = 1;
        }
        else
        {
            $vval  = 0;
        }
        $$vname = $vval;
    }
}

#
# transform form variables into value
#
sub vars2items()
{
    my $val = 0;
    
    my @varnames = keys %name2bit;
    
    for my $name (@varnames) {
        if ($$name == 1)
        {
            $val |= $name2bit{$name};
        }
    }
    return $val;
}






