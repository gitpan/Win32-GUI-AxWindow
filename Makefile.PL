use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	   => 'Win32::GUI::AxWindow',
    'VERSION_FROM' => 'AxWindow.pm', # finds $VERSION
    'XS'           => { 'AxWindow.xs' => 'AxWindow.cpp' },
    'LIBS'         => ['atl.lib'],   # e.g., '-lm'    
    'INC'	   => '',     # e.g., '-I/usr/include/other' 
     ($] eq '5.00503')
     ? (
	'DEFINE'	   => '-DPERL_5005',     # e.g., '-DHAVE_SOMETHING' 
     ) : (
	'DEFINE'	   => '',     # e.g., '-DHAVE_SOMETHING' 
     ),     
     ($] ge '5.005')
     ? (
      'AUTHOR'   => 'ROCHER Laurent (rocherl@club-internet.fr)',
      'ABSTRACT' => 'Add ActiveX Control Hosting in Win32::GUI',
     )
     : (),
);

sub MY::xs_c {
'

.xs.c:
    $(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs > $*.c

.xs.cpp:
    $(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs > $*.cpp

';
}
