# TASK_TEMPLATE.md

This template defines a standardized task description for adding a new feature to the project. 

---

# Feature Task Template

## 1. Feature Name
- Add local storage for the tasks of the user, and their properties.

---

## 2. Feature Overview
- Currently, the users' tasks are saved on the runtime memory, which means that they are not persistent across app usage periods. Local storage (on the users' device) enables long term persistence of the users' tasks.

---

## 3. Requirements & Behaviors

### 3.1 Core Requirements  

-  Store the tasks and all their attributes that the user has created locally on his device.
-  Should allow for task fetching, creation, editing, and deletion - from the local database.

---

### 3.2 Edge Cases / Special Behaviors  
_Anything that needs extra care, exceptions, or special handling._

-  Make sure that if there are no tasks in the local database, the app's UI will act accordingly.

---

## 4. UI

### 4.1 Description of UI  
_Explain what screens, components, or widgets should exist._

-  The UI stays completely the same.

---

## 5. Data & State Requirements

### 5.1 Data Needed  
_What data the Data Agent must handle._

-  Task data  

---

## 6. Related Files, APIs, or Dependencies
_List anything the feature depends on._

- Use the Hive Database flutter package for storage.
- Provider, for state management (if needed)

---


