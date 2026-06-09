# BookMyEvent

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev) [![NestJS](https://img.shields.io/badge/NestJS-9.x-green.svg)](https://nestjs.com) [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE) 

## Overview 🚀
BookMyEvent is a **Flutter**‑based mobile application that lets users discover, search, and book events at local venues. It offers a smooth UI, real‑time updates, and secure booking flow.
Live Demo: https://bookmyevent-4rrq.onrender.com



## Features ✨
### Front‑end (Flutter)
- Event discovery, searchable UI, venue details, booking flow, push notifications, dark mode with glassmorphism.
### Back‑end (NestJS)
- RESTful API, JWT authentication, Prisma + PostgreSQL, real‑time sync, scalable architecture.



## Tech Stack 📚
| Layer | Technology | Description |
|-------|------------|-------------|
| Front‑end | Flutter 3.x | UI framework for iOS/Android |
|  | Dart | Programming language |
|  | Provider / Riverpod | State management |
|  | Google Fonts (Inter) | Typography & styling |
| Back‑end | NestJS (Node.js/TypeScript) | Server framework |
|  | Prisma ORM | Type‑safe DB access |
|  | PostgreSQL | Relational database |
|  | JWT | Stateless authentication |

## Getting Started
### Prerequisites
- Flutter SDK (stable) – https://flutter.dev
- Node.js ≥ 20 & npm
- PostgreSQL (Docker recommended)

### Installation
#### Front‑end
```bash
git clone <repo-url>
cd BookMyEvent
flutter pub get
```
#### Back‑end
```bash
cd backend
npm install
cp .env.example .env   # Create your own .env file (set DB_URL, JWT_SECRET, etc.)
npx prisma migrate dev --name init
npm run dev
# The server will listen on the port defined by the PORT environment variable (default 3000).
```
### Run the Application
```bash
# Terminal 1 – Flutter UI
flutter run

# Terminal 2 – NestJS API
cd backend && npm run dev
```

## Project Structure
```
BookMyEvent/
├─ lib/                     # Flutter source
│  ├─ widgets/
│  │   └─ inputs/
│  │       └─ custom_search_bar.dart
│  ├─ screens/
│  ├─ models/
│  └─ services/
├─ backend/
│  ├─ src/
│  │   └─ venues/
│  ├─ prisma/
│  ├─ test/
│  └─ package.json
├─ assets/                  # Images, GIFs, fonts
├─ test/                    # Flutter tests
└─ README.md
```

## Testing
```bash
# Flutter tests
flutter test

# NestJS tests
cd backend && npm test
```


## License
MIT © [License](LICENSE)
