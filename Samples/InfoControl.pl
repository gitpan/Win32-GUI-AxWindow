# perl -w
#
#  Information about a control.
#  Create a html file with control information.
#  Parametre : CLSID Or ProgID
#
use Cwd;
use Win32::GUI;
use Win32::GUI::AxWindow;

if ($#ARGV != 0)
{
  print $0, " : ControlId\n";
  exit(0);
}

$ControlID = $ARGV[0];

# main Window
$Window = new Win32::GUI::Window (
    -title    => "Win32::GUI::AxWindow test",
    -left     => 100,
    -top      => 100,
    -width    => 400,
    -height   => 400,
    -name     => "Window",
) or die "new Window";

# Create AxWindow
$Control = new Win32::GUI::AxWindow  (
               -parent  => $Window,
               -name    => "Control",
               -pos     => [0, 0],
               -size    => [400, 400],
               -control => $ControlID,
 ) or die "new Control";

open (F, ">$ControlID.html") or die "open";

# Enum Property info

print F '<HTML><BODY><HR><H1>Properties</H1><HR>';
print "Properties\n";
foreach $id ($Control->EnumPropertyID()) {

  %property = $Control->GetPropertyInfo ($id);

  foreach $key (keys %property) {
    print F "<B>$key</B> = ", $property {$key}, "<BR>";
  }

  print F "<P>";
}

# Enum Method info

print F "<P><HR><H1>Methods</H1><HR>";
print "Methods\n";
foreach $id ($Control->EnumMethodID()) {

  %method = $Control->GetMethodInfo ($id);

  foreach $key (keys %method) {
    print F "<B>$key</B> = ", $method {$key}, "<BR>";
  }

  print F "<P>";
}

# Enum Event info

print F "<P><HR><H1>Events</H1><HR>";
print "Events\n";
foreach $id ($Control->EnumEventID()) {

  %event = $Control->GetEventInfo ($id);

  foreach $key (keys %event) {
    print F "<B>$key</B> = ", $event {$key}, "<BR>";
  }

  print F "<P>";
}

print F "</BODY></HTML>";
close (F);
