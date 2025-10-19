#include "system_tray_manager.h"
#include <windows.h>
#include <shellapi.h>
#include <stdio.h>

SystemTrayManager::SystemTrayManager() 
    : hwnd_(nullptr), hInstance_(nullptr), trayMenu_(nullptr), isInitialized_(false) {
    WM_TRAYICON = RegisterWindowMessage(L"TrayIconMessage");
}

SystemTrayManager::~SystemTrayManager() {
    Uninitialize();
}

bool SystemTrayManager::Initialize(HWND hwnd, HINSTANCE hInstance) {
    hwnd_ = hwnd;
    hInstance_ = hInstance;
    
    CreateTrayMenu();
    LoadTrayIcon();
    
    isInitialized_ = AddTrayIcon();
    return isInitialized_;
}

void SystemTrayManager::Uninitialize() {
    if (isInitialized_) {
        RemoveTrayIcon();
        isInitialized_ = false;
    }
    
    if (trayMenu_) {
        DestroyMenu(trayMenu_);
        trayMenu_ = nullptr;
    }
}

void SystemTrayManager::ShowTrayMenu() {
    if (!trayMenu_) return;
    
    POINT pt;
    GetCursorPos(&pt);
    
    SetForegroundWindow(hwnd_);
    TrackPopupMenu(trayMenu_, TPM_BOTTOMALIGN | TPM_LEFTALIGN, pt.x, pt.y, 0, hwnd_, NULL);
}

void SystemTrayManager::HandleTrayMessage(UINT message, WPARAM wparam, LPARAM lparam) {
    if (message != WM_TRAYICON) return;
    
    switch (lparam) {
        case WM_LBUTTONDOWN:
            // Left click to show/hide window
            if (IsWindowVisible(hwnd_)) {
                ShowWindow(hwnd_, SW_HIDE);
            } else {
                ShowWindow(hwnd_, SW_SHOW);
                SetForegroundWindow(hwnd_);
            }
            break;
            
        case WM_RBUTTONDOWN:
            // Right click to show menu
            ShowTrayMenu();
            break;
    }
}

void SystemTrayManager::HandleMenuCommand(WPARAM wparam) {
    switch (wparam) {
        case IDM_SHOW_WINDOW:
            ShowWindow(hwnd_, SW_SHOW);
            SetForegroundWindow(hwnd_);
            break;
            
        case IDM_EDIT_TIMETABLE:
            // Show window and navigate to timetable edit screen
            ShowWindow(hwnd_, SW_SHOW);
            SetForegroundWindow(hwnd_);
            // Send a custom message to the Flutter window to navigate to timetable edit
            PostMessage(hwnd_, WM_USER + 1, IDM_EDIT_TIMETABLE, 0);
            break;
            
        case IDM_EXIT:
            ExitApplication();
            break;
    }
}

void SystemTrayManager::ExitApplication() {
    // Send WM_CLOSE message to the main window
    if (hwnd_) {
        PostMessage(hwnd_, WM_CLOSE, 0, 0);
    }
}

bool SystemTrayManager::AddTrayIcon() {
    if (!hwnd_ || !hInstance_) {
        return false;
    }
    
    NOTIFYICONDATA nid = {0};
    nid.cbSize = sizeof(NOTIFYICONDATA);
    nid.hWnd = hwnd_;
    nid.uID = 1;
    nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
    nid.uCallbackMessage = WM_TRAYICON;
    
    // Load the icon from resources
    HICON hIcon = LoadIcon(hInstance_, MAKEINTRESOURCE(101)); // IDI_APP_ICON
    if (!hIcon) {
        // Fallback to default application icon
        hIcon = LoadIcon(NULL, IDI_APPLICATION);
    }
    nid.hIcon = hIcon;
    
    wcscpy_s(nid.szTip, L"Smart Schedule");
    
    return Shell_NotifyIcon(NIM_ADD, &nid) != FALSE;
}

bool SystemTrayManager::RemoveTrayIcon() {
    NOTIFYICONDATA nid = {0};
    nid.cbSize = sizeof(NOTIFYICONDATA);
    nid.hWnd = hwnd_;
    nid.uID = 1;
    
    return Shell_NotifyIcon(NIM_DELETE, &nid) != FALSE;
}

void SystemTrayManager::CreateTrayMenu() {
    trayMenu_ = CreatePopupMenu();
    
    AppendMenu(trayMenu_, MF_STRING, IDM_SHOW_WINDOW, L"显示窗口");
    AppendMenu(trayMenu_, MF_STRING, IDM_EDIT_TIMETABLE, L"编辑课表");
    AppendMenu(trayMenu_, MF_SEPARATOR, 0, NULL);
    AppendMenu(trayMenu_, MF_STRING, IDM_EXIT, L"退出");
}

void SystemTrayManager::LoadTrayIcon() {
    // Icon is already defined in resources, no need to load extra
}