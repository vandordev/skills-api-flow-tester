# Flow: Auth Login

**Base URL:** {{BASE_URL}}
**OpenAPI URL:** {{OPENAPI_URL}}
**Description:** Login, capture auth data, then fetch the current user profile.

---

## Step 1: Login

**Method:** POST
**Path:** /auth/login

**Headers:**
- Content-Type: application/json

**Body:**
```json
{
  "email": "{{ADMIN_EMAIL}}",
  "password": "{{ADMIN_PASSWORD}}"
}
```

**Expect:**
- Status: 200
- JSON path exists: `.data.access_token`
- JSON path exists: `.data.user.id`
- JSON path matches regex: `.data.access_token` -> `^[A-Za-z0-9-_=.]+$`

**Capture:**
- `access_token` <- `.data.access_token`
- `user_id` <- `.data.user.id`

---

## Step 2: Get Profile

**Method:** GET
**Path:** /users/{{user_id}}

**Headers:**
- Authorization: Bearer {{access_token}}

**Expect:**
- Status: 200
- JSON path exists: `.data.email`
- JSON path equals: `.data.id` -> `{{user_id}}`
- JSON path contains: `.data.email` -> `@`
