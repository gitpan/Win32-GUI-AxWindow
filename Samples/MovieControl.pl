# perl -v
#
#  Hosting Movie Control (A movie player control see http://www.viscomsoft.com/movieplayer.htm)
#
use Cwd;
use Win32::GUI;
use Win32::GUI::AxWindow;

# main Window
$Window = new Win32::GUI::Window (
    -title    => "Movie Control Test",
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
#               -control => "{F4A32EAF-F30D-466D-BEC8-F4ED86CAF84E}",
               -control => "MOVIEPLAYER.MoviePlayerCtrl.1",
 ) or die "new Control";

# Load Avi file
$Control->SetProperty("FileName", "movie.avi");

# Event loop
$Window->Show();
# Start Avi player
$Control->CallMethod("Play");
Win32::GUI::Dialog();


# Main window event handler

sub Window_Terminate {

  # Release all before destroy window
  # $Control->Release();

  return -1;
}

sub Window_Resize {

  if (defined $Window) {
    ($width, $height) = ($Window->GetClientRect)[2..3];
    $Control->Move   (0, 0);
    $Control->Resize ($width, $height);
  }
}
