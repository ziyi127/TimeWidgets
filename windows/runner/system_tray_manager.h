#ifndef RUNNER_SYSTEM_TRAY_MANAGER_H_
#define RUNNER_SYSTEM_TRAY_MANAGER_H_

#include <windows.h>
#include <shellapi.h>
#include <string>

// Menu item IDs
#define IDM_SHOW_WINDOW 1
#define IDM_EXIT        2

class SystemTrayManager {
public:
    SystemTrayManager();
    ~SystemTrayManager();

    bool Initialize(HWND hwnd, HINSTANCE hInstance);
    void Uninitialize();
    void ShowTrayMenu();
    void HandleTrayMessage(UINT message, WPARAM wparam, LPARAM lparam);
    void ExitApplication();

private:
    HWND hwnd_;
    HINSTANCE hInstance_;
    HMENU trayMenu_;
    bool isInitialized_;
    UINT WM_TRAYICON;

    bool AddTrayIcon();
    bool RemoveTrayIcon();
    void CreateTrayMenu();
    void LoadTrayIcon();
};

#endif // RUNNER_SYSTEM_TRAY_MANAGER_H_