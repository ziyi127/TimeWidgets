
# Static Website Replica - Moonshot Academy

This folder contains a static replica of the Moonshot Academy website (https://moonshotacademy.cn/).

## Structure
- `index.html`: Main entry point. Open this file in your browser.
- `css/`: Stylesheets and localized library CSS.
- `js/`: JavaScript files and localized library JS.
- `images/`: Images, icons, and avatars.
- `font/`: Web fonts (HYQiHei).
- `video/`: Downloaded video assets.

## Notes
1. **Offline Capability**: 
   - Most assets (fonts, images, icons, core JS libraries like Mapbox) have been downloaded and linked locally.
   - The site should look correct even without an internet connection.
   
2. **External Dependencies**:
   - Map APIs (Google Maps, QQ Maps) are kept as external script references because they require API keys and dynamic tile loading. They may not display maps correctly in offline mode.
   - External links (e.g., to WeChat articles, admission application) are preserved as original external links.

3. **Missing Assets**:
   - Some video files (`ending_questions.mp4`, `loading_text.mp4`, `logo_white_video_230.mp4`) could not be downloaded (404 Not Found on source). The references in the code point to the `video/` folder but the files might be missing.
   
## How to Run
Simply double-click `index.html` to open it in your default web browser. No server is required, though using a local server (e.g., `python -m http.server`) is recommended for best performance with some browser security policies.
