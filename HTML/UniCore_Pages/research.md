# 1. GET vs POST
- They are `HTTP` methods used to send data from the browser to the server.  
**GET:**
- Sends the data through a `URL`.
- Data is `visible` in the URL.
- `Not secure` for the sensitive data.
- Used for retrieving data.  
- The length of a URL is limited (about 2048 characters)
- Useful for form submissions where a user wants to bookmark the result.
**POST:**
- Sends the data inside the `request body`.
- Data is `not visible` in the URL.
- `More secure` for the sensetive data
- Used for submitting sensitive information.
- It has no size limitations, and can be used to send large amounts of data.
- Form submissions with POST cannot be bookmarked.   
**Therefore**, for the `register.html` page `POST` is the better choice as it sends the user information more securely.
----
# 2. Semantic HTML:
### Why is it "better" to use tags like `<header>`, `<main>` , `<section>` ,and `<footer>` not the `<div>` tags ?
- Because the semantic tags :
  - Improves the readability of the code.
  - Improves the accessibility for the screen users.
  - Helps the search engines to understand the structure of the page.   
- **But** on the other hand using only the `<div>` tags will make the structure unclear and harder to be maintained.
---
# 3. Request / Response Cycle:
- When a user types google.com in the browser:
   1. The browser asks the `DNS` server to translate the domain name `(google.com)` into an `IP` address.
   2.  The `DNS` server returns the `IP` address of the server.
   3. The browser sends an `HTTP` request to that `IP` address.
   4. The server processes the request and sends back the webpage.
   5. The browser receives the response and then renders the page for the user.


