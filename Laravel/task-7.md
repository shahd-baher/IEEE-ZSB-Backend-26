# Design Patterns & Backend Concurrency – Notes
## 1. Strategy Design Pattern
**Classification:** Behavioral Pattern (GoF).
**Idea:** Instead of writing all the algorithms for the same task inside one class using big if/else or switch blocks, each algorithm gets its own separate class, and all of them implement the same Interface. The main class (Context) doesn't execute the logic itself — it just delegates the request to the appropriate Strategy object.
**Why we actually need it (the problem it solves):**
- If you have, for example, multiple payment methods (PayPal, Stripe, Fawry...) or multiple export formats (PDF, CSV, Excel), and all of that logic lives inside one class → you get:
  - **Tight Coupling:** the class becomes tied to everything external.
  - **Fragility:** a small change in one algorithm can break something else that was already working.
  - **Hard to Test:** you need mocks for every branch inside the same method.
  - **God Class:** the class keeps growing until it becomes a mess.
**Structure (Components):**

| Component | Role | Example |
|---|---|---|
| Context | Holds a reference to the Strategy interface and delegates execution through it | `OrderService` |
| Interface | Defines the method signature all strategies must implement | `IOrderNotifier` |
| Concrete Strategy | The actual implementation of one single algorithm | `EmailNotifier` |

**Main benefit:** It achieves the **Open/Closed Principle (OCP)** — you can add a new Strategy (like `PushNotifier`) without touching the existing, already-tested Context class at all. Testing also becomes much easier since each Strategy is isolated on its own.
---
## 2. Factory Design Pattern
**Classification:** Creational Pattern.
**Idea:** Instead of scattering `new SomeClass()` calls all over the codebase, you centralize the object-creation logic inside a Factory. The client just asks the Factory for the object it needs, without knowing the creation details.
**Its role in larger systems:** It acts as a middle layer between Controllers and business logic. Any complex setup (API keys, timeouts, env variables) is encapsulated inside the Factory instead of being duplicated everywhere.
**Relationship with the Strategy Pattern (very important):**
Factory and Strategy naturally complement each other:
- The Factory reads something like the payment gateway name from the request (`payment_gateway_name`)
- Based on that, it returns the matching Strategy (like `StripeStrategy` or `PaypalStrategy`)
- The client doesn't need to know or care about the creation details at all.
**Components:**

| Component | Role | Example |
|---|---|---|
| Product Interface | Defines the shape of the objects being created | `IDocument` |
| Factory Interface | Declares a `create()` method that returns the Product interface | `IDocumentFactory` |
| Concrete Product | An actual implementation of a specific type | `PDFDocument` |
| Concrete Factory | Implements `create()` to return a specific type | `PDFFactory` |

**Important downside I need to remember:** every time you add a new type, you also need a new factory → this is called **"Class Explosion."**
**My Remarks:** In Laravel, the Service Container itself can act like a Factory internally when you bind an Interface to a Concrete Class — you can swap the implementation from a single place (the Service Provider) without touching any other code that depends on the Interface.
---
## 3. Database Concurrency & Atomicity (ACID)
**Concurrency:** the database's ability to let multiple connections/threads read and modify the same tables at the same time. Important for scalability, but dangerous if not controlled properly.
**Atomicity (the "A" in ACID):** a transaction executes as a single **all-or-nothing** unit — either every operation inside it succeeds, or none of them do.
**Execution mechanics:**
1. **Begin Transaction:** marks a safe boundary; changes are staged temporarily.
2. **Commit (success):** if every statement executes without errors (like constraint violations) → the changes are permanently written to disk.
3. **Rollback (failure):** if any statement fails → all changes are reverted to the exact state before the transaction started, as if nothing happened.
---
## 4. Race Conditions
**Definition:** happens when multiple processes/threads try to access and modify the same resource at the same time, and the outcome depends on the exact timing of who executes first.
**Root cause:** an operation like `stock += 1` or `stock -= 1` is **not actually atomic** — it consists of 3 steps: **Read → Modify → Write**. If Thread A and Thread B both read the value at the same moment, one of them will overwrite the other's update — this is called a **Lost Update**.
**Practical example (Overselling):**
- Stock = 1 item only.
- Process A reads Stock = 1, and at the same moment Process B also reads Stock = 1.
- Both see Stock > 0 as true, both approve the order, and both write Stock = 0.
- **Result:** two customers successfully bought the same last item → a real financial and logistical problem
**Theoretical solutions:**
1. **Atomic DB Operations:** instead of reading the value into the app, modifying it, then writing it back, let the database itself perform the arithmetic operation directly (e.g. `UPDATE table SET stock = stock - 1`), so the engine handles it internally as one unit.
2. **Pessimistic Locking:** the transaction takes an **Exclusive Lock** on the row as soon as it's read, and anyone else trying to read/modify the same row has to wait in a queue until the lock is released.
3. **Optimistic Locking (Version Tracking):** each row has a `version` or `timestamp` column. When someone tries to update it, the system checks whether the version still matches what was read initially. If it changed → the update is rejected and the app retries.
**My Remarks:** Laravel has ready solutions for this — Optimistic Locking via a package or manually with a `version` column, and Eloquent's `lockForUpdate()` which applies Pessimistic Locking directly at the query level.
---
## 5. Database Deadlocks
**Definition:** a complete blocking state that happens when two or more transactions each hold a lock on a resource, and each one is waiting for the lock the other one is holding.
**The four necessary conditions for a deadlock to occur:**
1. **Mutual Exclusion:** the resource can only be held by one owner at a time (exclusive).
2. **Hold and Wait:** a transaction holds one resource while waiting for another at the same time.
3. **No Preemption:** no one can forcibly take a lock away from its owner; it must be released voluntarily.
4. **Circular Wait:** a closed circular chain — each transaction is waiting for the next one in the chain.
**Example:**
- Transaction 1: holds Row A, requests Row B.
- Transaction 2: holds Row B, requests Row A.
- Both are stuck in a closed loop.
**How the database handles it:** engines like MySQL InnoDB or PostgreSQL run **Deadlock Detection** in the background. Once the circular wait is detected, one transaction is chosen as the "victim" and forcibly **rolled back**, returning an error code so the other transaction can proceed.
**Ways to reduce it:**
1. **Deterministic Resource Ordering:** all code must acquire locks on tables/rows in the exact same order every time (e.g. always sort IDs numerically first).
2. **Automatic Retries:** wrap the transaction in a retry block — if a deadlock happens, wait a short random backoff period and retry.
3. **Minimizing Lock Duration:** any heavy operation (API calls, validation) should happen **before** entering the transaction, not inside it, so the lock isn't held for a long time.
---
## 6. RESTful API Architecture (extra section from the second source)
**Core principles:**
- **Statelessness:** the server doesn't keep any session state; every request must carry all the information it needs (like the token) on its own.
- **Resource-Based Routing:** URLs should represent nouns, not verbs, and should be plural: `api/users`, not `api/get-users`.
**HTTP Methods:**

| Method | Purpose | Default Status |
|---|---|---|
| GET | Read | 200 |
| POST | Create | 201 |
| PUT | Full replace | 200 |
| PATCH | Partial update | 200 |
| DELETE | Delete | 204 |

**Important status codes:** `400` bad request, `401` unauthenticated, `403` no permission, `404` not found, `422` validation failed.
**Important Laravel API components:**
- **Form Request Class:** isolates all validation and authorization rules outside the Controller (`StorePostRequest`).
- **API Resource:** a transformation layer that controls exactly how a Model is serialized into JSON, prevents leaking sensitive data (like passwords), and helps solve the N+1 problem.
- **Mass Assignment Protection:** defining `$fillable` inside the Model so no one can send data for fields that aren't allowed.
**My Remarks:** this connects directly to the N+1 Problem I already worked on in previous IEEE tasks — API Resources combined with eager loading (`with()`) solve the problem together.
---
## Resources
- Design Patterns explanation – Refactoring.Guru (Behavioral & Creational Patterns).
- Database Systems material: Concurrency Control, ACID Properties, Transaction Isolation Levels, Lock Management.
- The videos I watched (the two main sources this summary is compiled from).
## Note on LLM Usage
I used Claude to help organize and merge the information from both sources into one coherent file, and to connect some points to what I already know about Laravel (like the Service Container, `lockForUpdate()`, and the N+1 problem) so the summary would have my own personal input instead of just being a copy of the sources.
---