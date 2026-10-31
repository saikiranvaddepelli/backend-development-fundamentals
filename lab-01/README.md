# Lab 1: Node.js and Express server

Oddepelly Sai Kiran · 252U1R5116 · Section A  
Backend Development Fundamentals · Year II Term II · Aurora · Faculty: Joel Prashanth D

---

## Live Link

Not applicable (Running in local development environment; all routes tested and verified).

---

## How to Run

### Prerequisites
- Node.js (v18 or higher recommended)
- npm (Node Package Manager)

### Installation
Clone the repository and install dependencies:
```bash
git clone <repository-url>
cd backend-development-fundamentals/lab-01
npm install
```

### Environment Variables
Optionally configure a `.env` file in `lab-01/`:
```env
PORT=3000
```

### Start Commands
To run the Express server:
```bash
npm start
```
or
```bash
node index.js
```

To run the plain built-in HTTP server:
```bash
npm run start:http
```
or
```bash
node http-server.js
```

---

## Endpoints / Scripts Table

### Express Server Routes (`index.js`)

| Method | Endpoint | Description | Status Code | Expected Output |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/` | Welcome text message | `200 OK` | `Welcome to the Node.js and Express server!` |
| `GET` | `/about` | JSON response with name, registration number, and section | `200 OK` | `{"name":"Oddepelly Sai Kiran","registrationNumber":"252U1R5116","section":"..."}` |
| `GET` | `/time` | JSON response with current ISO timestamp | `200 OK` | `{"currentTime":"2026-..."}` |
| `ALL` | `*` (e.g. `/unknown`) | 404 handler for any unmapped route | `404 Not Found` | `404 Not Found: The requested resource does not exist.` |

### Plain HTTP Server (`http-server.js`)

| Method | Endpoint | Description | Status Code | Expected Output |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/` | Built-in `http.createServer` response | `200 OK` | `Hello` |

---

## Screenshots

### 1. Plain HTTP Server (`GET /`)
![Plain HTTP Server](screenshots/01-http-server.png)

### 2. Express Server Welcome (`GET /`)
![Express Welcome](screenshots/02-express-welcome.png)

### 3. Express Server About (`GET /about`)
![Express About JSON](screenshots/03-express-about.png)

### 4. Express Server Time (`GET /time`)
![Express Current Time](screenshots/04-express-time.png)

### 5. Express Server 404 Unknown Route (`GET /unknown`)
![Express 404 Not Found](screenshots/05-express-404.png)

---

## package.json Fields Explanation

- `name`: The lowercase package name (`lab-01`).
- `version`: The current semantic version (`1.0.0`).
- `description`: Brief summary of the project.
- `main`: The entry point script (`index.js`).
- `scripts`: Custom CLI shortcut commands (`npm start`, `npm run start:http`).
- `keywords`: Array of search tags for the project.
- `author`: The developer's name (`Oddepelly Sai Kiran`).
- `license`: Open-source licensing standard (`ISC`).
- `dependencies`: Production packages required by the application (`express`).

---

## Viva Questions & Answers

1. **What is the difference between `package.json` and `node_modules`?**
   - `package.json` is a lightweight configuration file storing project metadata, scripts, and dependency version rules.
   - `node_modules` is the directory where the actual package source code and all nested dependencies are downloaded and stored.

2. **What does `app.listen` do?**
   - `app.listen()` binds the application to a specific port and IP address, listening for incoming HTTP connections and requests.

3. **What do request and response represent?**
   - `req` (Request) is an object containing details about the client's HTTP request, including URL path, query params, headers, and body.
   - `res` (Response) is an object used to send status codes, headers, and payload (JSON, text, HTML) back to the client.

---

## Notes: Problems Faced and How You Solved Them

- **Port collision between servers**: Both the plain HTTP server and the Express server use port 3000. Resolved by running them under distinct start scripts (`npm start` and `npm run start:http`) and cleanly terminating previous instances before switching.
- **Order of middleware for 404 handler**: If placed before defined routes, the 404 handler intercepts all requests. Resolved by placing `app.use((req, res) => ...)` at the very bottom after all route declarations.
