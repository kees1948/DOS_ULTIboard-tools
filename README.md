# DOS_ULTIboard-tools

Breathe new life into this very nice software package from the 90's. UTIBoard and ULTICap are very capable tools
for Schematic entry and PCB design. I use it still as of today with pleasure.

If you still have a ULTIBOARD version for DOS, WITH THE DONGLE and the license file (lic100.pwd), you can still successfuly 
use it today. (Warning: using dosbox with ULTIboard on Windows is dangerous, we have experienced multiple events where 
the DONGLE was DAMAGED beyond further use. This NEVER happened with the Linux version (this dosbox version)

I found that it runs very succesfuly in a dosbox on Linux. The only difficulty may be that you need the parallel port
to be on the motherboard, as the dongle is accessed via that.

The DOS ULTIboard postprocessing only creates a RS274D format. I created a Perl tools that transforms these RS274D files
into RS274X formatted files, that are accepted at most PCB factories today.

From the Linux commandline everything is started by using the command ulti. This is a shell script and creates a .bat file
for the dosbox environment.

The (uploaded) 'dosbox' is a special version that has a patch included for use of the parallel port.

The .doxboxrc file sets eveything up and includes the definition for the parallel port. 

The Ultimate programs are put in a folder ~/Ultimate

The designfiles goed into ~/ultiproj/


