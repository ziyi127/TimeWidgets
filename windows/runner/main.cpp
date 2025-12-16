#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <shellapi.h>

#include "flutter_window.h"
#include "system_tray_manager.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Request UIAccess permission (requires administrator privileges)
  HANDLE hToken;
  TOKEN_ELEVATION elevation;
  DWORD dwSize;
  
  if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken)) {
    if (GetTokenInformation(hToken, TokenElevation, &elevation, sizeof(elevation), &dwSize)) {
      if (!elevation.TokenIsElevated) {
        // If not administrator, try to restart as administrator
        wchar_t szPath[MAX_PATH];
        if (GetModuleFileName(NULL, szPath, MAX_PATH)) {
          ShellExecute(NULL, L"runas", szPath, NULL, NULL, SW_SHOWNORMAL);
          return 0;
        }
      }
    }
    CloseHandle(hToken);
  }
  
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(0, 0);  // Position will be auto-calculated (top-right)
  Win32Window::Size size(480, 1080);  // Adapted for 1080p screen width
  if (!window.Create(L"Smart Schedule", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
