# perl -w
#
#  Hosting a WebBrowser
#    Create a WebBrowser and register an event.
#    Enumerate Property, Methods and Events and create a Html file.
#    Load Html file in WebBrowser.
#
use Cwd;
use Win32::GUI;
use Win32::GUI::AxWindow;

# main Window
$Window = new Win32::GUI::Window (
    -title    => "Win32::GUI::AxWindow test",
    -pos     => [100, 100],
    -size    => [400, 400],
    -name     => "Window",
) or die "new Window";

# Create AxWindow
$Control = new Win32::GUI::AxWindow  (
               -parent  => $Window,
               -name    => "Control",
               -pos     => [0, 0],
               -size    => [400, 400],
               -control => "Shell.Explorer.2",
#               -control => "{8856F961-340A-11D0-A96B-00C04FD705A2}",
 ) or die "new Control";

# Register Event

$Control->RegisterEvent("StatusTextChange", sub { $self = shift; $id = shift; print "Event : ", @_, "\n"; } );

# Enum Property info

open (F, ">Webbrowser.html") or die "open";
print F '<HTML><BODY><HR><H1>Properties</H1><HR>';

foreach $id ($Control->EnumPropertyID()) {

  %property = $Control->GetPropertyInfo ($id);

  foreach $key (keys %property) {
    print F "<B>$key</B> = ", $property {$key}, "<BR>";
  }

  print F "<P>";
}

# Enum Method info

print F "<P><HR><H1>Methods</H1><HR>";

foreach $id ($Control->EnumMethodID()) {

  %method = $Control->GetMethodInfo ($id);

  foreach $key (keys %method) {
    print F "<B>$key</B> = ", $method {$key}, "<BR>";
  }

  print F "<P>";
}

# Enum Event info

print F "<P><HR><H1>Events</H1><HR>";

foreach $id ($Control->EnumEventID()) {

  %event = $Control->GetEventInfo ($id);

  foreach $key (keys %event) {
    print F "<B>$key</B> = ", $event {$key}, "<BR>";
  }

  print F "<P>";
}

print F "</BODY></HTML>";
close (F);

# Method call
$dir  = cwd;
$path = "file://$dir/Webbrowser.html";

# print $path, "\n";
$Control->CallMethod("Navigate", $path);

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
