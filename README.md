# Country Explorer App

**Name:** [Abel Bete]  
**Student ID:** [ATE/4222/15]  

## 1. Track Chosen
**TRACK A — Country Explorer App** (API: RestCountries)

## 2. Description
This Flutter application allows users to explore countries around the world. It provides a list of all countries along with their flags and populations, allows users to search for specific countries by name using a debounced search bar, and view detailed information such as capital, area, timezone, currencies, and languages. It correctly handles loading, error, and data states and implements custom API exceptions.

## 3. Setup Instructions
To run this application locally:
1. Ensure Flutter is installed and configured on your machine.
2. Clone this repository and open the project directory.
3. Run `flutter pub get` to install the `http` package dependency.
4. Run `flutter run` to launch the app on an emulator or connected device.

## 4. API Endpoints Used
The app communicates with the free `restcountries.com` API:
- `GET /v3.1/all?fields=name,flags,region,population,cca3` — Fetches all countries for the home screen.
- `GET /v3.1/name/{name}` — Searches for matching countries by name.
- `GET /v3.1/alpha/{code}` — Fetches the complete details of a specific country by its ISO code.

## 5. Known Limitations or Bugs
- The API may occasionally return missing fields (e.g. some countries do not have a capital). The app handles these gracefully with null-aware operators.
- The RestCountries API doesn't support pagination, so the home screen loads all countries at once.
- The country list relies on the device supporting the flag emojis; on older Windows/Linux machines, some flags might not render natively.
