#include "flutter_window.h"

#include <optional>
#include <windows.h>
#include <dwmapi.h>

#include "flutter/generated_plugin_registrant.h"
#include "system_tray_manager.h"

// Static member definition
SystemTrayManager* FlutterWindow::tray_manager_ = nullptr;

#pragma comment(lib, "dwmapi.lib")

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {
    if (tray_manager_ == nullptr) {
        tray_manager_ = new SystemTrayManager();
    }
}

FlutterWindow::~FlutterWindow() {
    if (tray_manager_ != nullptr) {
        delete tray_manager_;
        tray_manager_ = nullptr;
    }
}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  // Initialize system tray
  if (tray_manager_ != nullptr) {
      tray_manager_->Initialize(this->GetHandle(), GetModuleHandle(NULL));
  }

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  // Uninitialize system tray
  if (tray_manager_ != nullptr) {
      tray_manager_->Uninitialize();
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Handle system tray messages
  if (tray_manager_ != nullptr) {
      UINT wm_trayicon = RegisterWindowMessage(L"TrayIconMessage");
      if (message == wm_trayicon) {
          tray_manager_->HandleTrayMessage(message, wparam, lparam);
          return 0;
      }
      
      // Handle menu commands
      if (message == WM_COMMAND) {
          tray_manager_->HandleMenuCommand(LOWORD(wparam));
          return 0;
      }
      
      // Handle custom messages from system tray
      if (message == WM_USER + 1) {
          if (wparam == IDM_EDIT_TIMETABLE) {
              // Send a message to Flutter to navigate to timetable edit screen
              if (flutter_controller_) {
                  flutter_controller_->engine()->ReloadSystemFonts();
              }
          }
          return 0;
      }
  }

  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
