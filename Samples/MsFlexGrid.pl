# perl -w
#
#  Hosting MsFlexGrid : Test Indexed properties
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
               -control => "MSFlexGridLib.MSFlexGrid",
 ) or die "new Control";

# Test Enum property set by string value
# $Control->SetProperty("ScrollBars", "flexScrollBarNone");
# $Control->SetProperty("GridLines", "flexGridInset");

$Control->SetProperty("Rows", 5);
$Control->SetProperty("Cols", 5);

$Control->SetProperty("TextMatrix", 1, 2, "Hello!!!");

$r = $Control->GetProperty("Rows");
$c = $Control->GetProperty("Cols");
$t = $Control->GetProperty("TextMatrix", 1, 2);
print "Rows = $r, Cols = $c, TextMatrix(1,2) = $t\n";

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
