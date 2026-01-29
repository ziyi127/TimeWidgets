# TimeWidgets Plugin SDK

Welcome to the TimeWidgets Plugin Development Kit. This system allows you to extend the application with custom widgets, tray menus, and settings.

## Plugin Structure

A plugin is a ZIP file containing the following structure:

```
my-plugin.zip
├── plugin.json       (Required: Manifest)
├── layout.json       (Optional: UI Definition)
├── tray.json         (Optional: Tray Menu)
├── settings.json     (Optional: Settings Schema)
└── assets/           (Optional: Images, icons)
```

## 1. Manifest (plugin.json)

Defines metadata about your plugin.

```json
{
  "id": "com.example.myplugin",
  "name": "My Custom Widget",
  "version": "1.0.0",
  "description": "Displays a custom message",
  "author": "Developer Name",
  "minAppVersion": "1.0.0",
  "permissions": ["network"]
}
```

## 2. UI Layout (layout.json)

Defines the widget structure using a JSON schema.

Supported Types: `Container`, `Column`, `Row`, `Text`, `Icon`, `SizedBox`, `Center`.

```json
{
  "type": "Container",
  "params": {
    "padding": 16,
    "color": "#FFFFFF",
    "width": 200,
    "height": 100
  },
  "children": [
    {
      "type": "Column",
      "params": {
        "mainAxisAlignment": "center"
      },
      "children": [
        {
          "type": "Icon",
          "params": {
            "icon": "access_time",
            "size": 24,
            "color": "#000000"
          }
        },
        {
          "type": "Text",
          "params": {
            "text": "Hello Plugin!",
            "fontSize": 16,
            "fontWeight": "bold"
          }
        }
      ]
    }
  ]
}
```

## 3. Tray Menu (tray.json)

Adds items to the system tray context menu.

```json
[
  {
    "label": "Open My Plugin",
    "action": "open_ui"
  },
  {
    "label": "Refresh Data",
    "action": "refresh"
  }
]
```

## 4. Settings (settings.json)

Defines user-configurable settings.

```json
[
  {
    "key": "refresh_rate",
    "label": "Refresh Rate (seconds)",
    "type": "number",
    "defaultValue": 60
  },
  {
    "key": "theme",
    "label": "Theme",
    "type": "choice",
    "options": ["Light", "Dark"],
    "defaultValue": "Light"
  }
]
```

## Packaging

1. Create the files above.
2. Compress them into a ZIP file.
3. Use the `SignatureVerifier` (if enabled) to sign your package.
4. Import into TimeWidgets.

## Security

Plugins run in a sandboxed environment. Currently, they are limited to:
- JSON-based UI rendering (no arbitrary code execution).
- Predefined actions (no raw file system or network access unless permitted).
