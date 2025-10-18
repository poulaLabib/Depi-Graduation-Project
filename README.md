# Fikraty  

> A digital platform inspired by *Shark Tank*, connecting **entrepreneurs** with **investors** in a professional, accessible way.  

---

## 📌 Overview  
**Fikraty** is a mobile application designed to help **entrepreneurs** present their startup ideas and connect directly with **investors**.  
The platform bridges the gap between innovation and funding by offering an easy-to-use, secure, and professional environment.  

---

## 🎯 Objectives  
- 🤝 Facilitate direct communication between entrepreneurs and investors  
- ⚡ Accelerate access to funding opportunities  
- 🌍 Build a digital community for startup growth and collaboration  

---

## 📲 Features  

**General** 🔒  
- Basic registration available for all users  
- Additional **authorization required** to access full features  
  - Entrepreneurs cannot submit requests or nudge investors without authorization  
  - Investors cannot directly communicate with entrepreneurs without authorization  

**Entrepreneurs** 🧑‍💻  
- Create and manage personal & company profiles  
- Submit requests (currently only **fundraising**)  
- Browse investor profiles  
- Nudge investors **(only if the investor has agreed & entrepreneur is authorized)**  

**Investors** 💼  
- Two types: **Angel Investors** & **Venture Capitalists**  
- Create and manage personal profiles  
- Browse fundraising requests  
- View entrepreneur & company profiles **(only for those who submitted requests)**  
- Sort requests by **industry** and **funding amount**  
- Communicate directly with entrepreneurs **(only if authorized)**  
- Choose whether to allow or block nudges  

---

## 👨‍💻 Team Members
- Youssef Mohamed (**Team Leader**)  
- Nourhan Ahmed  
- Mohamed Adel  
- Poula Labib  
- Ahmed Mohamed  
- Omar Ahmed Ali

---

## 📅 Work Plan

### 1. Research & Analysis
#### 👥 Target Users
- **Entrepreneurs** 🧑‍💻: Individuals or teams looking to showcase their startup ideas and attract funding.  
- **Investors** 💼: Angel investors and venture capitalists interested in discovering promising opportunities.  

---

### 2. Visual Identity
[Link to Drive Folder](https://drive.google.com/drive/folders/13ekEDLPfK-LCBPbbIMYMziaHKOovLsgI)  
*Logo design, branding elements, and color schemes.*

---

### 3. Main Designs
[Link to Drive Folder](https://drive.google.com/drive/folders/1b8ytB8BiUEWRhILur3lRKWeMXsrjdhO-)  
*UI mockups, posters, and app screen designs.*

---

### 4. Final Presentation
[Link to Drive Folder](https://drive.google.com/drive/folders/1i-v5P9e_PrK8GawTJ93Kt54WHdDPVbjc)  
*Slides and materials prepared for the final project presentation.*

---

## 👨‍💻 Roles & Responsibilities

Each team member contributes across multiple areas to ensure collaboration and shared responsibility.

### 🔧 Backend
- **Firebase Authentication:** Ahmed Mohamed & Youssef Mohamed  
- **Firestore Database Design & Management:** Omar Ahmed Ali & Mohamed Adel  
- **Cloud Functions / API Integrations:** Ahmed Mohamed & Poula Labib  
- **State Management & Data Flow:** Youssef Mohamed & Nourhan Ahmed  

---

### 🎨 Frontend (Flutter)
- **UI Implementation:** Mohamed Adel & Nourhan Ahmed  
- **Navigation & Routing:** Poula Labib & Youssef Mohamed  
- **State Management (Bloc / Provider):** Ahmed Mohamed & Omar Ahmed Ali  
- **Testing & Debugging:** All team members  

---

### 🖌️ UI/UX Design
- **Wireframes & Prototypes:** Nourhan Ahmed & Youssef Mohamed  
- **User Experience Flow:** Poula Labib & Mohamed Adel  
- **Design Consistency & Branding:** Nourhan Ahmed & Omar Ahmed Ali  

---

### 📂 Project Management
- **Task Allocation & Deadlines:** Youssef Mohamed  
- **Documentation (README, Reports):** Ahmed Mohamed & Omar Ahmed Ali  
- **Final Presentation:** All team members

---

## 👨‍🏫 Instructor
- Michiel Hany

---

## 🗓️ Project Timeline

### Week 1: Setup & UI/UX
**Tasks:**  
- Initialize Flutter project and GitHub repository  
- Design wireframes in Figma for core flows: entrepreneur signup, project submission, investor signup, project browsing, project detail & feedback screens  
- Plan Firestore database schema (users, projects, feedback)  
- Build static UI screens (login, dashboards, project detail)  

**Deliverables:**  
- Flutter project on GitHub  
- Figma prototype of MVP  
- Static UI screens ready for integration  

---

### Week 2: Backend & Firebase Integration
**Tasks:**  
- Integrate Firebase (Authentication, Firestore, Cloud Functions)  
- Implement role-based login/registration (Entrepreneur vs. Investor)  
- Configure Firestore with proper security rules  
- Begin connecting UI with backend (basic data flow)  

**Deliverables:**  
- Functional authentication system  
- Firestore integrated and secured  
- Initial backend connected to UI screens  

---

### Week 3: Core Features (Project Submission & Browsing)
**Tasks:**  
- Complete project submission for entrepreneurs (title, description, pitch deck)  
- Build investor dashboard with sorting/filtering (industry, funding amount)  
- Project detail screens showing entrepreneur/company info  
- Implement nudge feature and authorization checks  

**Deliverables:**  
- Entrepreneurs can submit projects; investors can browse and view details  
- Fully integrated core features with backend  

---

### Week 4: Feedback, Testing, and Finalization
**Tasks:**  
- Implement feedback/rating system for investors  
- Test full app flow: authentication → submission → browsing → feedback  
- Fix bugs, polish UI, optimize UX  
- Prepare release-ready build (Android, optional iOS)  
- Prepare final pitch/demo presentation  

**Deliverables:**  
- Complete and stable MVP ready for demo  
- Final documentation and presentation materials  

---

## 🚀 Progress Update

### ✅ Completed
- 🖥️ UI screens and layouts  
- 🔐 Authentication & BLoC integration  
- 🧾 Basic registration for all users  

### 👷‍♂️ In Progress
- 👨‍💻 Entrepreneur & company profiles  
- 💼 Investor profiles  
- 💰 Fundraising request submission flow  

### ➡️ Next Phase
- 🔍 Investor browsing & sorting  
- 🤝 Nudge & communication authorization system


---

## 📂 Google Drive
[Project Resources](https://drive.google.com/drive/folders/10ItZDCpwTAKaMxpzxY7eUkeuYQnQYLrc?usp=drive_link)  

---

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
