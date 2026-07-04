# Laravel & Design Patterns
## 1. Blade Templates
- **How do Blade Templates work in Laravel?**
  - Blade is Laravel's templating engine, it lets you write clean directives instead of raw PHP, and Laravel compiles it into plain PHP behind the scenes (then caches it), so:
  - Displays data using `{{ }}` (escaped, safe from XSS) or `{!! !!}` (raw, unescaped).
  - Uses directives like `@if`, `@foreach`, `@include` instead of `<?php ?>` tags.
  - Supports **layout inheritance** with `@extends` and `@yield` / `@section` so pages share one master layout.
  - Supports **components** for reusable UI pieces (like an alert box or a card).
- **Example:**
```blade
{{-- layouts/app.blade.php --}}
<body>
    @yield('content')
</body>

{{-- home.blade.php --}}
@extends('layouts.app')
@section('content')
    <h1>Welcome, {{ $name }}</h1>
@endsection
```
---
## 2. ORM (Object-Relational Mapping)
- **What is the ORM, and why is it so useful?**
- ORM stands for `Object-Relational Mapping`. In Laravel it's called **Eloquent**, and it lets you deal with the database using PHP objects and methods instead of writing raw SQL.
- **Why it's useful:**
  - Less code, no manual SQL strings.
  - Protects against SQL injection automatically.
  - Works with different databases (MySQL, PostgreSQL...) with minimal changes.
  - Makes relationships between tables easy (`hasMany`, `belongsTo`).
- **Example:**
```php
class Student extends Model {
    public function house() {
        return $this->belongsTo(House::class);
    }
}

$students = Student::where('house', 'Gryffindor')->get();
$students->house->name; // Access related data easily
```
---
## 3. Facade Design Pattern
- **What is the Facade Pattern, and how does Laravel use it?**
- A Facade gives you a simple interface to a complex system, hiding all the complicated logic behind one easy call.
- Laravel uses Facades to give a **static-like syntax** to classes that are actually resolved from the service container, so it stays simple to use but still flexible/testable underneath.
- **Example: Laravel's `Cache` Facade:**
```php
use Illuminate\Support\Facades\Cache;

Cache::put('key', 'value', 600); // Store for 10 minutes
$value = Cache::get('key');
// Looks static, but Laravel resolves the real object behind the scenes
```
---
## 4. Factory Design Pattern
- **What is the Factory Design Pattern?**
- It's a creational pattern where object creation is handled by a factory (method/class), instead of calling `new SomeClass()` directly everywhere. This hides which exact class is being created from the client code.
- **Example:**
```php
interface Notification {
    public function send($message);
}

class EmailNotification implements Notification {
    public function send($message) { echo "Email: $message"; }
}

class NotificationFactory {
    public static function create($type): Notification {
        return match ($type) {
            'email' => new EmailNotification(),
            default => throw new Exception("Unknown type"),
        };
    }
}

$notification = NotificationFactory::create('email');
$notification->send('Welcome!');
```
- **Note:** Laravel also has **Model Factories** (`Student::factory()->create()`), used to generate fake data for testing/seeding.
---
## 5. SOLID Principles
- **What are the SOLID Principles?**

**S — Single Responsibility:** a class should do one job only.
```php
class Student { public function calculateGrade() { /* ... */ } }
class StudentRepository { public function save(Student $s) { /* ... */ } }
```

**O — Open/Closed:** open for extension, closed for modification.
```php
interface HouseBonus { public function apply(float $points): float; }
class GryffindorBonus implements HouseBonus {
    public function apply(float $points): float { return $points * 1.1; }
}
```

**L — Liskov Substitution:** subclasses must be replaceable for their parent without breaking things.
```php
interface Bird {}
interface FlyingBird extends Bird { public function fly(); }
class Penguin implements Bird {} // Not forced to fly
```

**I — Interface Segregation:** don't force classes to implement methods they don't need.
```php
interface CanCode { public function code(); }
class Developer implements CanCode {
    public function code() { echo "Writing PHP code"; }
}
```

**D — Dependency Inversion:** depend on abstractions (interfaces), not concrete classes.
```php
interface Database { public function connect(); }
class StudentRepository {
    public function __construct(private Database $db) {}
}
```
---
## Summary
- Blade makes views clean and reusable through directives, layouts, and components.
- The ORM (Eloquent) removes the need for raw SQL and adds security and easy relationships.
- The Facade Pattern gives a simple static-style interface to complex Laravel services (like `Cache::`).
- The Factory Pattern centralizes and hides object creation logic.
- SOLID (SRP, OCP, LSP, ISP, DIP) are five principles that keep OOP code clean, flexible, and maintainable.
---
