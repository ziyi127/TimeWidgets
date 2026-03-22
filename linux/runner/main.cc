#include "my_application.h"

int main(int argc, char** argv) {
  const char* session_type = g_getenv("XDG_SESSION_TYPE");
  const char* display = g_getenv("DISPLAY");

  // On Wayland, some compositors enforce a thin title strip for top-level
  // windows even when decorated=false. Prefer X11/XWayland when available to
  // get consistent borderless floating widget behavior.
  if (g_strcmp0(session_type, "wayland") == 0 && display != nullptr &&
      *display != '\0') {
    g_setenv("GDK_BACKEND", "x11", TRUE);
  }

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
