# perl -w
#
#  MSHTML : Load static HTML data
#
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
               -control => "MSHTML:<HTML><BODY>This is a line of text</BODY></HTML>",
 ) or die "new Control";

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
