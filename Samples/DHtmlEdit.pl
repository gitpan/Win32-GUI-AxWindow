# perl -w
#
#  Hosting DHtmlEdit basic 
#

use Cwd;
use Win32::GUI;
use Win32::GUI::AxWindow;

# main Window
$Window = new Win32::GUI::Window (
    -name     => "Window",
    -title    => "Win32::GUI::AxWindow test",
    -pos      => [100, 100],
    -size     => [400, 400],
) or die "new Window";

# Create AxWindow
$Control = new Win32::GUI::AxWindow  (
               -parent  => $Window,
               -name    => "Control",
               -pos     => [0, 0],
               -size    => [400, 400],
               -control => "{2D360200-FFF5-11D1-8D03-00A0C959BC0A}",
 ) or die "new Control";

# Method call
$Control->CallMethod("NewDocument");

# Event loop
$Window->Show();
Win32::GUI::Dialog();

# Main window event handler

sub Window_Terminate {

  # Print Html Text
  print $Control->GetProperty("DocumentHTML");

  return -1;
}

sub Window_Resize {

  if (defined $Window) {
    ($width, $height) = ($Window->GetClientRect)[2..3];
    $Control->Move   (0, 0);
    $Control->Resize ($width, $height);
  }
}
