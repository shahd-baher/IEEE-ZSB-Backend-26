## 1. Understanding HTTP for Backend Engineers
**HTTP (Hypertext Transfer Protocol)** is the application-layer protocol that powers almost all communication on the web. It's built on a **Client-Server model**: the client (browser, mobile app, or another backend service) sends a request, and the server processes it and sends back a response. Everything from loading a webpage to calling a REST API goes through this cycle.
### Key Concepts:
- **Statelessness:** Every HTTP request is handled on its own — the server doesn't automatically remember anything from a previous request. That's why we need sessions, cookies, or tokens (like JWT) if we want the server to "recognize" a client across multiple requests.
- **HTTP Methods:**
  - `GET`: Fetch data, should not change anything on the server (read-only).
  - `POST`: Create a new resource / submit data.
  - `PUT`: Replace an entire existing resource.
  - `PATCH`: Update only part of an existing resource.
  - `DELETE`: Remove a resource.
- **HTTP Status Codes:**
  - ### 1xx — Informational
    The request was received and the process is continuing.
    - **`100 Continue`** — the client can go ahead and send the rest of the request body.
    - **`101 Switching Protocols`** — server agrees to switch protocols (e.g. upgrading to WebSocket).
  - ### 2xx — Success
    The request was received and handled correctly.
    - **`200 OK`** — standard success response.
    - **`201 Created`** — a new resource was successfully created.
    - **`202 Accepted`** — request accepted, but processing isn't finished yet (common with async jobs).
    - **`204 No Content`** — success, but nothing to send back in the body.
  - ### 3xx — Redirection
    The client needs to do something else (usually go to a different URL) to finish the request.
    - **`301 Moved Permanently`** — resource has a new permanent URL.
    - **`302 Found`** — resource is temporarily at a different URL.
    - **`304 Not Modified`** — nothing changed, use your cached copy.
  - ### 4xx — Client Errors
    Something is wrong on the client's side.
    - **`400 Bad Request`** — malformed request or invalid data.
    - **`401 Unauthorized`** — no valid credentials provided.
    - **`403 Forbidden`** — credentials are valid, but access isn't allowed.
    - **`404 Not Found`** — the resource/URL doesn't exist.
    - **`405 Method Not Allowed`** — this endpoint doesn't support the HTTP method used.
    - **`409 Conflict`** — request conflicts with the current server state.
    - **`429 Too Many Requests`** — client hit a rate limit.
  - ### 5xx — Server Errors
    The request was fine, but the server failed to handle it.
    - **`500 Internal Server Error`** — generic "something broke on the server" error.
    - **`502 Bad Gateway`** — a proxy/gateway got an invalid response from the upstream server.
    - **`503 Service Unavailable`** — server is overloaded or down for maintenance.
    - **`504 Gateway Timeout`** — upstream server didn't respond in time.
- **Headers & Body:**
  - **Headers** carry metadata about the request/response — things like `Content-Type` (what format the body is in) or `Authorization` (auth credentials).
  - **Body** is the actual data being sent, e.g. the JSON payload of a `POST` request.
**`My Conclusion:`** I used to only check "is it 200 or not," but now I actually read the specific status code before debugging — it usually tells me exactly where to look (client-side vs server-side vs a redirect I didn't expect).
---
## 2. Serialization and Deserialization for Backend Engineers
### What is Serialization?
Serialization is turning an in-memory object or data structure into a format that can be stored or sent over a network — usually JSON, XML, or a raw byte stream.
### What is Deserialization?
Deserialization is the opposite: taking that stored/transmitted format and rebuilding it back into a usable object in memory.
### Why we actually need this:
- **APIs:** A backend serializes objects (e.g. database records) into JSON before sending them in an HTTP response, and deserializes incoming JSON request bodies back into objects/arrays the code can work with.
- **Storage & Caching:** Complex objects (session data, computed results) get serialized before being saved into fast key-value stores like Redis, or into a database column, since these storage layers can't hold raw in-memory objects directly.
**`My Conclusion:`** I used to treat encoding/decoding JSON as a throwaway utility call, but it's really the mechanism that lets two systems written in completely different languages exchange data reliably.
---
## 3. Caching, the Secret Behind It All
### What is Caching?
Caching means storing a copy of frequently requested data in a faster, temporary storage layer (usually RAM) so future requests for the same data don't have to redo expensive work — like hitting the database again.
### Caching Types & Strategies:
- **In-memory caching:** using dedicated fast stores like **Redis** or **Memcached** instead of hitting the main database every time.
- **Cache-Aside (Lazy Loading):**
  1. Check the cache first.
  2. If the data is there (**cache hit**) — return it right away.
  3. If it's not (**cache miss**) — fetch it from the database, store it in the cache, then return it.
- **Eviction & Invalidation:**
  - **TTL (Time to Live):** cached data automatically expires after a set amount of time.
  - **Cache Invalidation:** manually clearing or updating cached entries whenever the underlying data changes, so the cache never serves stale results.
**`My Conclusion:`** Caching isn't just "make it faster" — the real difficulty is knowing when to expire or invalidate data so users never see outdated information.
---
## 4. UML Class Diagram
UML Class Diagrams are static structure diagrams used to describe a system by showing its classes, their attributes/methods, and how the classes relate to each other — essentially a blueprint you draw before (or while) writing code.
### Class Representation:
Each class box has 3 parts:
1. **Class Name**
2. **Attributes** (with visibility markers)
3. **Methods**
### Visibility Modifiers:
- `+` **Public** — accessible from anywhere.
- `-` **Private** — accessible only inside the class itself.
- `#` **Protected** — accessible inside the class and any subclasses.
### Relationships:
- **Inheritance (Generalization):** solid line with a hollow arrowhead — "is-a" relationship.
- **Association:** a general connection between two classes.
- **Aggregation:** "has-a" relationship, but the child can exist independently of the parent (hollow diamond).
- **Composition:** "has-a" relationship where the child cannot exist without the parent (filled diamond).
- **Dependency:** one class temporarily depends on/uses another (dashed arrow).
**`My Conclusion:`** Sketching the class diagram before coding forces me to actually decide ownership and relationships up front, instead of figuring it out halfway through implementation.
---
## 5. Observer Design Pattern
The **Observer Pattern** is a behavioral design pattern where a **Subject (Observable)** keeps a list of dependents (**Observers**) and automatically notifies all of them whenever its state changes, typically by calling a method on each one.
### Key Benefits:
- **Loose Coupling:** the Subject doesn't need to know any implementation details about its Observers — it just notifies them, keeping the code modular and easy to extend.
- **Event-Driven Architecture:** this is the pattern behind most event/listener systems in frameworks (e.g. Laravel's Events & Listeners/Observers).
### Example Scenario:
When a new user registers:
- **Subject:** the `UserRegistered` event.
- **Observers:** `SendWelcomeEmailListener`, `LogUserRegistrationListener`, `CreateUserProfileListener` — each reacts independently without the registration logic needing to know they exist.
**`My Conclusion:`** Once I connected this pattern to something I already use daily (event listeners), it clicked immediately — it's the foundation of decoupled, event-driven code.
---
## 6. Real World System Design
System Design is about defining the architecture, components, interfaces, and data flow of a system so it can meet a given set of requirements — both functional and non-functional (scale, latency, availability).
### Core Architecture Principles:
- **Scalability:**
  - **Vertical Scaling (Scale-Up):** add more CPU/RAM to a single server.
  - **Horizontal Scaling (Scale-Out):** add more server instances and distribute traffic between them.
- **Load Balancers:** distribute incoming traffic across multiple servers (e.g. Nginx, AWS ALB) to keep the system available and prevent any single server from being overwhelmed.
- **Database Optimization:**
  - **Read Replicas:** separate read traffic from write traffic to reduce load on the main database.
  - **Sharding:** split a large database horizontally across multiple servers so no single one holds all the data.
- **Asynchronous Processing:** offload slow tasks (sending emails, processing images, etc.) to background jobs via message queues (RabbitMQ, Redis Queues) instead of making the client wait for them inside the HTTP request/response cycle.
**`My Conclusion:`** This tied everything together — HTTP and serialization are how data moves, caching is how we avoid repeating work, UML/Observer are how we model and decouple the code, and all of it comes together as the toolbox used in real system design decisions.
---
## Resources Searched & Tools Used
- MDN Web Docs (HTTP Overview & Status Codes)
- Refactoring.Guru (Design Patterns: Observer Pattern)
- System Design Primer / System Design Basics
- Claude / LLM Prompting: Used to research and summarize key concepts for Laravel task 
---