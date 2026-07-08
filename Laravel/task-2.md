# Laravel Research: `Gates`,`Sanctum vs Passport`, `CSRF/XSRF`, `Eloquent Relationships`

---

## 1. Laravel Gates

So Gates are basically Laravel's simplest way of answering one question: "is this user allowed to do this thing?" That's it. No models involved necessarily, just a yes/no check.

Say you only want admins to be able to delete posts. You'd go into `AppServiceProvider`, in the `boot()` method, and write:

```php
use Illuminate\Support\Facades\Gate;

Gate::define('delete-post', function ($user) {
    return $user->role === 'admin';
});
```

Then anywhere in your app you can just ask "hey, is this allowed?":

```php
if (Gate::allows('delete-post')) {
    // go ahead and delete it
}
```

Or in a controller, the cleaner way is:

```php
$this->authorize('delete-post');
```

which just throws a 403 automatically if it's a no.

### What's actually happening under the hood?

When you call `Gate::define()`, Laravel isn't doing anything fancy — it's literally just shoving your closure into an array, something like `$abilities['delete-post'] = yourClosure`. That's it, no magic yet.

The interesting part happens when you call `Gate::allows()`. At that point Laravel:

1. Figures out who's logged in right now (it has a resolver set up for that).
2. Pulls your closure out of that array.
3. Runs it through the container — which is why you can type-hint a `Post $post` in your closure and Laravel will just hand it to you, it resolves dependencies automatically.
4. Also checks if you've set up any "before" callbacks (like a "super admins can do literally anything" rule) — those run first and can skip the whole check.
5. Takes whatever comes back — true, false, or a custom response — and returns that as your answer.

And a fun fact: Policies aren't really a separate system. When you register a Policy for a model, Laravel just checks "does this model have a policy attached?" before falling back to the abilities array. Same engine, just two different places it looks for the answer.

---

## 2. Sanctum vs Passport

Honestly the way I'd put it: Sanctum is the "keep it simple" option, Passport is the "we need real OAuth" option.

If you're building your own SPA, or a mobile app that only talks to your own API, Sanctum is basically always the answer. It's lightweight, quick to set up, and it just issues tokens (or uses cookies if it's a same-domain SPA) — no OAuth flow, no authorization screens, none of that overhead.

Passport is the heavier tool. You reach for it when your app itself needs to *become* an OAuth provider — like if you want other companies or developers to be able to do a "Login with YourApp" button, the same way you'd see "Login with Google" or "Login with GitHub." That requires actual OAuth2 grant types, consent screens, scoped access, the whole deal.

So practically:
- Your own React/Vue frontend + your API → **Sanctum**
- Your own mobile app → **Sanctum**
- Letting some other company plug into your platform with proper OAuth → **Passport**

And if you're ever unsure which to pick — just start with Sanctum. Moving up to Passport later is pretty painless, but ripping Passport back out because you way over-engineered it is annoying.

As of 2026, Sanctum is actually the default package Laravel installs when you run `php artisan install:api` — it's become the "obvious first choice" for most apps, while Passport still has its place whenever real OAuth2 is genuinely needed.

---

## 3. CSRF vs XSRF

This one trips people up but honestly it's not that deep — **CSRF and XSRF are literally the same attack.** The "X" in XSRF is just people using "X" instead of "Cross" (same reason XSS uses an X). There's zero technical difference in what they mean.

The actual attack, in plain terms: say you're logged into your bank, and some sketchy site quietly fires off a request to `transfer-money` in the background. Because your browser automatically attaches your session cookies to every request, the bank has no way of knowing that wasn't really you clicking the button.

Laravel protects against this by generating a token and checking it on every request that changes data. If you're doing a normal form, you just drop `@csrf` in there and it handles the hidden token field for you:

```blade
<form method="POST">
    @csrf
    <!-- generates: <input type="hidden" name="_token" value="..."> -->
</form>
```

If the token doesn't match on submit, you get a `419 Page Expired`.

Where "XSRF" actually shows up in Laravel's code is specifically for JS-driven requests — like when you're using Axios with a Vue or React frontend. Laravel sets a cookie literally called `XSRF-TOKEN`, and Axios automatically reads it and sends it back as a header called `X-XSRF-TOKEN`. Laravel checks that header the same way it checks the hidden form field.

So really — it's one protection mechanism, just with two slightly different "delivery methods" depending on whether it's a classic form or a JS request.

---

## 4. Defining Relationships in Eloquent Models

This is basically just Eloquent's way of telling your models how they connect to each other in the database.

### One to One:
A user has one profile.
```php
class User extends Model
{
    public function profile()
    {
        return $this->hasOne(Profile::class);
    }
}
```
```php
$user->profile;
```

### One to Many:
A user has many posts.
```php
class User extends Model
{
    public function posts()
    {
        return $this->hasMany(Post::class);
    }
}
```
```php
$user->posts;
```

### Belongs To:
The reverse side — a post belongs to a user.
```php
class Post extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```
```php
$post->user;
```

### Many to Many:
Students take many courses, courses have many students. This one needs a pivot table (like `course_student`).
```php
class Student extends Model
{
    public function courses()
    {
        return $this->belongsToMany(Course::class);
    }
}
```
```php
$student->courses;
```

### Has Many Through:
This is for when you want to skip a middle step. Like a `Country` has many `Users`, and each `User` has many `Posts` — if the country wants to grab *all* the posts written by its users without going through the user model manually every time:
```php
class Country extends Model
{
    public function posts()
    {
        return $this->hasManyThrough(Post::class, User::class);
    }
}
```

**Note:**   
 this is different from `hasOneThrough`, which is only for when both hops give you a *single* result, not a whole collection. Example: a `Mechanic` is assigned one `Car`, and that `Car` has one `Owner` — the mechanic asking "who owns my car" is a `hasOneThrough`, because at every step there's only ever one record. `Country → Users → Posts` is a `hasManyThrough` because there could be tons of users and tons of posts.
