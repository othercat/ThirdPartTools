#!/usr/bin/perl
#
# 24 November 2008
# Framework Dumping utility; requires class-dump
#

use strict;

use Cwd;
use File::Path;

my $HOME = (getpwuid($<))[7] || $ENV{'HOME'} 
  or die "Could not find your home directory!";

# This command must be in your path.
# http://www.codethecode.com/projects/class-dump/
my $CLASS_DUMP = 'class-dump'; 

# Public Frameworks
dump_frameworks('/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/System/Library/Frameworks',
                'Frameworks');

# Private Frameworks
dump_frameworks('/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/System/Library/PrivateFrameworks',
                'PrivateFrameworks');

sub dump_frameworks
{
  my($dir, $subdir) = @_;

  opendir(my $dirh, $dir) or die "Could not opendir($dir) - $!";

  # Iterate through each framework found in the directory
  foreach my $file (grep { /\.framework$/ } readdir($dirh))
  {
    # Extract the framework name
    (my $fname = $file) =~ s/\.framework$//;
    print "Framework: $fname\n";

    my $headers_dir = "$HOME/Headers/$subdir/$fname";

    # Create the folder to store the headers
    mkpath($headers_dir);

    # Perform the class-dump
    my $cwd = cwd();
    chdir($headers_dir) or die "Could not chdir($headers_dir) - $!";

    system($CLASS_DUMP, '-H', "$dir/$file");

    if(my $ret = $? >> 8)
    {
      #die "$CLASS_DUMP failed, returning $ret\n";
		print "$CLASS_DUMP failed, returning $ret\n";
    }

    chdir($cwd) or die "Could not chdir($cwd) - $!";
  }
}
