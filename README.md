# Nikaay

Nikaay is a premium, AI-powered organic skincare consultation app built to provide users with personalized skincare routines, ingredient analysis, and real-time guidance. Designed as a polished, production-ready product, Nikaay seamlessly integrates a Flutter mobile frontend with a robust Django REST Framework backend, leveraging the Google Gemini API for intelligent skin analysis.

---

## Table of Contents

- [Demo](#demo)
- [Screenshots](#screenshots)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Engineering and Production Considerations](#engineering-and-production-considerations)
- [Local Setup Instructions](#local-setup-instructions)
- [Security Notes](#security-notes)
- [Future Improvements](#future-improvements)

---

## Demo

The GIFs below walk through the splash screen and onboarding flow. They play automatically when the README is viewed on GitHub, so no download or external player is needed.

<p align="center">
  <img src="./assets/readme/gifs/splash-onboarding-1.gif" width="45%" alt="Splash and onboarding flow, part 1">
  <img src="./assets/readme/gifs/splash-onboarding-2.gif" width="45%" alt="Splash and onboarding flow, part 2">
</p>

If you prefer the full-resolution version with audio, the original screen recordings are available here:

- [Full walkthrough, part 1](./assets/readme/screenrecord/screen-recording-1.mov)
- [Full walkthrough, part 2](./assets/readme/screenrecord/screen-recording-2.mov)

---

## Screenshots

<p align="center">
  <img src="./assets/readme/screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-09-17%20at%2020.31.25.png" width="22%" alt="Splash screen">
  <img src="./assets/readme/screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20-%202026-09-17%20at%2020.31.36.png" width="22%" alt="Onboarding screen">
  <img src="./assets/readme/screenshots/simulator_screenshot_028C6E96-AE42-4EB7-A4DE-11D342CD07EB.png" width="22%" alt="Screen 3">
  <img src="./assets/readme/screenshots/simulator_screenshot_1609F054-7C65-4444-9672-4FEBCE28326D.png" width="22%" alt="Screen 4">
</p>
<p align="center">
  <img src="./assets/readme/screenshots/simulator_screenshot_363C36C6-4BCF-40AF-838D-6759D3B76CE7.png" width="22%" alt="Screen 5">
  <img src="./assets/readme/screenshots/simulator_screenshot_3D901DBC-EC9F-49CC-8197-0D154B178FCC.png" width="22%" alt="Screen 6">
  <img src="./assets/readme/screenshots/simulator_screenshot_4BE3A71A-BDFC-4972-A8EE-961015B55D4D.png" width="22%" alt="Screen 7">
  <img src="./assets/readme/screenshots/simulator_screenshot_8F6AA9C4-2609-4B41-994C-3D450984A22C.png" width="22%" alt="Screen 8">
</p>
<p align="center">
  <img src="./assets/readme/screenshots/simulator_screenshot_C7C7B41E-CCB7-4D7C-9CF2-A599CADB92A3.png" width="22%" alt="Screen 9">
  <img src="./assets/readme/screenshots/simulator_screenshot_DA5F7E90-21CE-4A4C-A831-06AFD8A0BA08.png" width="22%" alt="Screen 10">
  <img src="./assets/readme/screenshots/simulator_screenshot_E6ED642C-9A3B-4805-A091-19C912F348A7.png" width="22%" alt="Screen 11">
</p>

---

## Key Features

**Personalized AI Skin Analysis**
Users complete a comprehensive multi-step assessment, which is processed by Google's Gemini LLM to generate custom morning and evening routines along with ingredient recommendations tailored to their skin profile.

**Intelligent Skincare Chatbot**
A real-time AI assistant that answers skincare questions with contextual awareness of the user's prior assessments and stated concerns.

**Secure Authentication**
Firebase Authentication (Email/Password) is used on the client and verified server-side via the Firebase Admin SDK, keeping session handling and identity checks in sync between the app and the backend.

**Consultation History**
Users can review past assessments and track how their skin has changed over time, giving the AI analysis a longitudinal dimension rather than a single snapshot.

**Secure File and Report Uploads**
Users can safely upload prior dermatology reports and prescriptions, with support for both images and documents, so recommendations can account for existing medical context.

**Educational Content Hub**
Curated articles covering ingredients, routines, and organic skincare practices, giving users a reference point beyond their personalized plan.

**Premium UI and UX**
A clean, organic design system built on Material 3 guidelines, with fluid animations and a layout that adapts responsively across device sizes.

---

## Tech Stack

### Frontend (Mobile App)

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart |
| State Management | Riverpod |
| Navigation | GoRouter |
| Networking | Dio, with interceptors for auth tokens |
| Storage | Shared Preferences |

### Backend (API Server)

| Layer | Technology |
|---|---|
| Framework | Django and Django REST Framework (DRF) |
| Database | PostgreSQL |
| AI Integration | Google Gemini API |
| Authentication | Firebase Admin SDK (ID Token Verification) |

---

## Engineering and Production Considerations

Nikaay is architected with production resilience and cost-awareness in mind, rather than as a bare-minimum demo:

- **API-Level Throttling** — Protects against runaway AI service costs from repeated or abusive requests using DRF's `ScopedRateThrottle`.
- **Graceful Degradation** — Falls back to curated skincare data if the AI service fails, with structured logging for observability into when and why fallbacks occur.
- **Defensive LLM Parsing** — Uses pattern-based regex extraction rather than naive string splitting, to handle variability in LLM-generated JSON output.
- **Strict Schema Validation** — Server-side schema validation ensures the mobile app never receives malformed AI responses, catching errors at the API boundary instead of the client.
- **Cross-Platform Network Client** — Built without top-level `dart:io` dependencies, enabling the same networking code to compile for Flutter Web alongside iOS and Android.
- **Transparent AI Telemetry** — Explicit fallback flags (`is_fallback`) ensure degraded or offline responses are tracked in the database for auditing, so it's always clear which recommendations came from the model versus the fallback dataset.

---

## Local Setup Instructions

### Prerequisites

- Flutter SDK (v3.19 or later)
- Python (v3.10 or later)
- PostgreSQL installed and running
- A Firebase project with Authentication enabled
- A Google Gemini API key

### 1. Backend Setup (Django)

```bash
# Clone the repository
git clone https://github.com/yourusername/nikaay.git
cd nikaay/backend

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Open .env and fill in your DB credentials, Gemini API key, and Firebase Admin JSON path

# Run migrations
python manage.py migrate

# Start the server
python manage.py runserver
```

### 2. Frontend Setup (Flutter)

```bash
# Navigate to the Flutter project
cd nikaay

# Install dependencies
flutter pub get

# Environment variables
# Ensure your Firebase project is connected (use the FlutterFire CLI to generate
# firebase_options.dart if it isn't already present)

# Run the app
flutter run
```

---

## Security Notes

- No API keys (Gemini) or Firebase Admin credentials are ever exposed in the Flutter frontend.
- API endpoints strictly enforce authenticated ownership; users cannot access each other's assessments or data.
- User payloads and uploaded files are validated before being passed to the database or the AI inference pipeline.

---

## Future Improvements

- **User Feedback System** — Star ratings and feedback collection on AI-generated responses.
- **Push Notifications** — Firebase Cloud Messaging (FCM) integration for skincare routine reminders.
- **Multilingual Support** — Localization for wider accessibility.
- **AR Virtual Try-ons** — Assessing skin health via the device camera.

---

*Designed and developed as a premium internship assessment project.*