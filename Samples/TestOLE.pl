# perl -W
#
#  Host with AxWindow and manipulate with Win32::OLE
#  - Use GetOLE
#  - Call method
#  - Write in a HTML document
#
use Cwd;
use Win32::GUI;
use Win32::OLE;
use Win32::GUI::AxWindow;

# main Window
$Window = new Win32::GUI::Window (
    -title    => "Win32::GUI::AxWindow and Win32::OLE",
    -pos     => [100, 100],
    -size    => [400, 400],
    -name     => "Window",
) or die "new Window";

# A button
$Button = new Win32::GUI::Button (
    -parent  => $Window,
    -name    => "Button",
    -pos     => [0, 25],
    -size    => [400, 50],
    -text    => "Click me !!!",
    );

# Create AxWindow
$Control = new Win32::GUI::AxWindow  (
               -parent  => $Window,
               -name    => "Control",
               -pos     => [0, 100],
               -size    => [400, 300],
               -control => "Shell.Explorer.2",
 ) or die "new Control";

# Get Ole object
$OLEControl = $Control->GetOLE();
# $OLEControl->Navigate("about:blank");  # Clear control
$OLEControl->Navigate("http://www.google.com/");

# Event loop
$Window->Show();
Win32::GUI::Dialog();

# Button Event
sub Button_Click {
  $OLEControl->{Document}->{body}->insertAdjacentHTML("BeforeEnd","Click !!!");
  print "HTML = ", $OLEControl->{Document}->{body}->innerHTML, "\n";
}

# Main window event handler

sub Window_Terminate {

  # Release all before destroy window
  undef $OLEControl;
  $Control->Release();

  return -1;
}

sub Window_Resize {

  if (defined $Window) {
    ($width, $height) = ($Window->GetClientRect)[2..3];
    $Button->Move(0,25);
    $Button->Resize ($width, 50);
    $Control->Move   (0, 100);
    $Control->Resize ($width, $height-100);
  }
}
