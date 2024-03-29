package Win32::GUI::AxWindow;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Win32::GUI;

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader Win32::GUI::Window);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();
$VERSION = '0.07';

bootstrap Win32::GUI::AxWindow $VERSION;

# Preloaded methods go here.

# Initialise

Win32::GUI::AxWindow::_Initialise();

# DeInitialise

END {
  Win32::GUI::AxWindow::_DeInitialise();
}

# Autoload methods go after =cut, and are processed by the autosplit program.

#
#  new : Create a new ActiveX Window
#

sub new {

  my $class  = shift;
  my %in     = @_;

  ### Control option
  croak("-parent undefined")  unless exists $in{-parent};
  croak("-name undefined")    unless exists $in{-name};
  croak("-control undefined") unless exists $in{-control};

  my $parent = $in{-parent};
  my $name   = $in{-name};
  my $clsid  = $in{-control};

  # print "Parent = $parent->{-name}\n";
  # print "Name = $name\n";
  # print "Control = $clsid\n";

  ### Size
  my ($x, $y, $w, $h) = (0,0,1,1);

  $x = $in{-left}       if exists $in{-left};
  $y = $in{-top}        if exists $in{-top};
  $w = $in{-width}      if exists $in{-width};
  $h = $in{-height}     if exists $in{-height};
  ($x, $y) = ($in{-pos}[0] , $in{-pos}[1]) if exists $in{-pos};
  ($w, $h) = ($in{-size}[0],$in{-size}[1]) if exists $in{-size};
  # print "(x,y) = ($x,$y)\n(w,h) = ($w,$h)\n";

  ### Window Style
  my $style = WS_CHILD | WS_CLIPCHILDREN;

  $style  = $in{-style}     if exists $in{-style};
  $style |= $in{-pushstyle} if exists $in{-pushstyle};
  $style ^= $in{-popstyle}  if exists $in{-popstyle};
  $style |= $in{-addstyle}  if exists $in{-addstyle};
  $style ^= $in{-remstyle}  if exists $in{-remstyle};

  $style |= WS_VISIBLE      unless exists $in{-visible} && $in{-visible} == 0;
  $style |= WS_TABSTOP      unless exists $in{-tabstop} && $in{-tabstop} == 0;
  $style |= WS_DISABLED     if exists $in{-enable} && $in{-enable} == 0;
  $style |= WS_HSCROLL      if exists $in{-hscroll} && $in{-hscroll} == 1;
  $style |= WS_VSCROLL      if exists $in{-vscroll} && $in{-vscroll} == 1;

  # print "Style = $style\n";

  ### Window ExStyle
  my $exstyle = 0;

  $exstyle = $in{-exstyle}      if exists $in{-exstyle};
  $exstyle |= $in{-pushexstyle} if exists $in{-pushexstyle};
  $exstyle ^= $in{-popexstyle}  if exists $in{-popexstyle};
  $exstyle |= $in{-addexstyle}  if exists $in{-addexstyle};
  $exstyle ^= $in{-remexstyle}  if exists $in{-remexstyle};

  # print "ExStyle = $exstyle\n";

  ### Create Window and ActiveX Object
  my $self = {};
  bless $self, $class;

  if ( $self->_Create($parent, $clsid, $style, $exstyle, $x, $y, $w, $h) )
  {
    ### Store Data (Win32::GUI glue)
    $self->{-name}   = $in{-name};
    $parent->{$name} = $self;

    return $self;
  }

  return undef;
}

#
# CallMethod : Use Invoke with DISPATCH_METHOD
#

sub CallMethod {
  my $self = shift;

  return $self->Invoke (0x01, @_);
}

#
# GetProperty : Use Invoke with DISPATCH_PROPERTYGET
#

sub GetProperty {

  my $self = shift;

  return $self->Invoke (0x02, @_);
}

#
# PutProperty : Use Invoke with DISPATCH_PROPERTYPUT
#

sub SetProperty {

  my $self = shift;

  return $self->Invoke (0x04, @_);
}


1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Win32::GUI::AxWindow - Perl extension for Hosting ActiveX Control in Win32::GUI

=head1 SYNOPSIS

  use Win32::GUI;
  use Win32::GUI::AxWindow;

  # Main Window
  $Window = new Win32::GUI::Window (
               -name     => "Window",
               -title    => "Win32::GUI::AxWindow test",
               -post     => [100, 100],
               -size     => [400, 400],
  );

  # Add a WebBrowser AxtiveX
  $Control = new Win32::GUI::AxWindow  (
                -parent  => $Window,
                -name    => "Control",
                -control => "Shell.Explorer.2",
                # -control => "{8856F961-340A-11D0-A96B-00C04FD705A2}",
                -pos     => [0, 0],
                -size    => [400, 400],
  );

  # Register some event
  $Control->RegisterEvent("StatusTextChange",
                           sub {
                               $self    = shift;
                               $eventid = shift;
                               print "Event : ", @_, "\n";
                            } );

  # Call Method
  $Control->CallMethod("Navigate", 'http://www.perl.com/');

  # Event loop
  $Window->Show();
  Win32::GUI::Dialog();

  # Main window event handler

  sub Window_Terminate {

    return -1;
  }

  sub Window_Resize {

    if (defined $Window) {
      ($width, $height) = ($Window->GetClientRect)[2..3];
      $Control->Move   (0, 0);
      $Control->Resize ($width, $height);
    }
  }


=head1 DESCRIPTION

=head2 AxWindow

=item C<new> (...)

  Create a new ActiveX window.

  options  :

  -parent  => parent window  (Required)
  -name    => window name    (Required)
  -size    => window size [ width, heigth ]
  -pos     => window pos  [ left, top ]
  -width   => window width
  -height  => window height
  -left    => window left
  -top     => window top
  -control => clisd (see below) (Required).

  clsid is a string identifier to create the control.
  Must be formatted in one of the following ways:

    - A ProgID such as "MSCAL.Calendar.7"
    - A CLSID such as "{8E27C92B-1264-101C-8A2F-040224009C02}"
    - A URL such as "http://www.microsoft.com"
    - A reference to an Active document such as 'file://Documents/MyDoc.doc'
    - A fragment of HTML such as "MSHTML:<HTML><BODY>This is a line of text</BODY></HTML>"
      Note   "MSHTML:" must precede the HTML fragment so that it is designated as being an MSHTML stream.

  styles:

  -visible => 0/1
  -tabstop => 0/1
  -hscroll => 0/1
  -vscroll => 0/1

  -style, -addstyle, -pushstyle, -remstyle, -popstyle
  -exstyle, -exaddstyle, -expushstyle, -exremstyle, -expopstyle

  Default style is : WS_CHILD |  WS_VISIBLE | WS_TABSTOP | WS_CLIPCHILDREN

=item C<Release> ()

  If have crash when exiting, call this function before all the window are destroy (before Win32::GUI::Dialog(); exit).
  Generaly, call this function in the Window_Terminate handle.

=head2 Property

=item C<EnumPropertyID> ()

  Return a list of all the Property ID of the control.

=item C<EnumPropertyName> ()

  Return a list of all the Property name of the control.

=item C<GetPropertyInfo> (ID_or_Name)

  Return a hash with information about the Property from ID or Name.

  Hash entry :
    -Name        => Property Name.
    -ID          => Property ID.
    -VarType     => Property Type (Variant type).
    -EnumValue   => A formated string of enum value ( enum1=value1,enum2=value2,... ).
    -ReadOnly    => Indicate if a property can only be read.
    -Description => Property Description.
    -Prototype   => Prototype

=item C<GetProperty> (ID_or_Name, [index, ...])

  Get property value.
  For indexed property, add index list.

=item C<SetProperty> (ID_or_Name, [index, ...], value)

  Set property value
  For indexed property, add index list before value.

=head2 Method

=item C<EnumMethodID> ()

  Return a list of all the Method ID of the control.

=item C<EnumMethodName> ()

  Return a list of all the Method name of the control.

=item C<GetMethodInfo> (ID_Name)

  Return a hash with information about the Method from ID or Name.

  Hash entry :
    -Name        => Method Name.
    -ID          => Method ID.
    -Description => Method Description.
    -Prototype   => Method Prototype.

=item C<CallMethod> (ID_or_Name, ...)

  Invoke a method of an ActiveX control.

=head2 Event

=item C<EnumEventID> ()

  Return a list of all the Event ID of the control.

=item C<EnumEventName> ()

  Return a list of all the Event Name of the control.

=item C<GetEventInfo> (ID_or_Name)

  Return a hash with information about the Event from ID or Name.

  Hash entry :
    -Name        => Method Name.
    -ID          => Method ID.
    -Description => Method Description.
    -Prototype   => Method Prototype.

=item C<RegisterEvent> (ID_or_Name, Callback)

  Associate a Callback for an ActiveX Event.

=head2 Win32::OLE

=item C<GetOLE> ()

   Return a Win32::OLE object of Hosted ActiveX Control.

   You MUST add use Win32::OLE in your script.

=head1 AUTHOR

  Laurent Rocher (lrocher@cpan.org)
  HomePage :http://perso.club-internet.fr/rocherl/Win32GUI.html

=head1 SEE ALSO

  Win32::GUI

=cut
