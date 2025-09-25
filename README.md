# (“Fikraty”)

> A digital platform inspired by *Shark Tank*, connecting **entrepreneurs** with **investors** in a professional, accessible way.

---

## 📌 Overview
PitchUp is a mobile application designed to help **entrepreneurs** present their startup ideas and connect directly with **investors** seeking new opportunities.  

The platform bridges the gap between innovation and funding by offering an easy-to-use, secure, and professional environment.

---

## 🎯 Objectives
- 🤝 Facilitate direct communication between entrepreneurs and investors.  
- ⚡ Accelerate access to funding opportunities.  
- 🌍 Build a digital community for startup growth and collaboration.  

---

## 👥 Target Users
- **Entrepreneurs** 🧑‍💻: Showcase their startup ideas and projects.  
- **Investors** 💼: Discover promising opportunities and connect with innovators.  

---

## ⚠️ Challenges
- 📈 Attracting both entrepreneurs and investors.  
- 🧐 Ensuring quality of submitted projects (avoiding non-serious ideas).  
- 🔒 Protecting sensitive investor and project data.  
- ⏳ Managing time effectively between academic work and app development.  

---

## 🛠️ Tech Stack
- **Frontend:** Flutter  
- **Backend:** Firebase (Authentication, Firestore, Cloud Functions)  
- **UI/UX:** Figma (Prototyping & Wireframes)  

---

## 👨‍💻 Team Roles
| Role | Member |
|------|---------|
| 🧑‍✈️ Project Manager | Youssef Mohamed |
| 🎨 UI/UX Designers | Nourhan Ahmed & Youssef Mohamed |
| 💻 Frontend Developers | Mohamed Adel & Poula Labib |
| ⚙️ Backend Developers (Firebase) | Ahmed Mohamed & Omar Ahmed Ali |

---

## 📲 Features (Planned)
- ✅ User authentication (Entrepreneurs & Investors)  
- ✅ Project submission & pitch creation  
- ✅ Investor dashboards for browsing projects  
- ✅ Project rating & feedback system  

---

# Project Timeline

## Week 1: Setup, UI/UX, and Project Foundation
**Tasks:**
- Initialize the Flutter project and connect it to a GitHub repository for version control.
- Design wireframes in Figma for the core flows:
  - Entrepreneur signup & project submission.
  - Investor signup & project browsing.
  - Project detail and feedback screens.
- Define Firestore database schema (users, projects, feedback).
- Build static UI screens (non-functional): login, entrepreneur dashboard, investor dashboard, project detail page.

**Deliverables:**
- A Flutter project initialized and hosted on GitHub.
- Complete Figma prototype for the MVP.
- Static UI screens ready for authentication and data integration.

## Week 2: Firebase Integration and Authentication
**Tasks:**
- Integrate Firebase into the Flutter project (Authentication, Firestore).
- Implement user registration/login with role-based navigation (Entrepreneur vs. Investor).
- Create profile setup for each role.
- Configure Firestore with proper security rules for protecting user and project data.

**Deliverables:**
- Working login/registration system with roles.
- Entrepreneurs and investors redirected to their dashboards.
- Firestore database connected and secured.

## Week 3: Core Features (Project Submission & Browsing)
**Tasks:**
- Implement project submission flow for entrepreneurs (title, description, pitch deck upload).
- Build investor dashboard to list/filter projects.
- Create project detail screen with all entrepreneur information.
- Connect Firestore to handle project submissions and investor browsing in real time.

**Deliverables:**
- Entrepreneurs can submit projects.
- Investors can browse and view project details.
- Fully working integration between UI and Firestore.

## Week 4: Feedback, Testing, and Finalization
**Tasks:**
- Implement project feedback/rating system for investors.
- Test the full app flow: authentication → project submission → browsing → feedback.
- Fix bugs, polish UI consistency, and optimize UX.
- Prepare a release-ready build (Android, optionally iOS).
- Prepare pitch/demo presentation.

**Deliverables:**
- Complete MVP (authentication, submission, browsing, feedback).
- Tested and stable app ready for demo.
- Final documentation and project presentation.


---
# Current Phase

✅ UI Screens Completed (Login, Entrepreneur Dashboard, Investor Dashboard, Project Detail Page)  
➡️ Next Phase: Firebase Integration and Authentication (User registration/login, role-based navigation, Firestore setup with security rules)

---
## Google drive link :
https://drive.google.com/drive/folders/10ItZDCpwTAKaMxpzxY7eUkeuYQnQYLrc?usp=drive_link
## 🚀 Getting Started

### Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install)  
- Install [Firebase CLI](https://firebase.google.com/docs/cli)  

### Run the App
```bash
git clone https://github.com/poulaLabib/DEPI-Graduation-Project.git
cd DEPI-Graduation-Project
flutter pub get
flutter run
