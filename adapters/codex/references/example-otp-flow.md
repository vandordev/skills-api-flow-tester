# Flow: Phone Login With OTP

**Base URL:** {{BASE_URL}}
**OpenAPI URL:** {{OPENAPI_URL}}
**Description:** Request OTP for a test phone number, submit the OTP, then fetch the authenticated profile.

---

## Step 1: Request OTP

**Method:** POST
**Path:** /auth/request-otp

**Headers:**
- Content-Type: application/json

**Body:**
```json
{
  "phone_number": "{{TEST_PHONE_NUMBER}}"
}
```

**Expect:**
- Status: 200
- JSON path exists: `.data.request_id`

**Capture:**
- `otp_request_id` <- `.data.request_id`

---

## Step 2: Verify OTP

**Method:** POST
**Path:** /auth/verify-otp

**Headers:**
- Content-Type: application/json

**Body:**
```json
{
  "request_id": "{{otp_request_id}}",
  "phone_number": "{{TEST_PHONE_NUMBER}}",
  "otp_code": "{{OTP_CODE}}"
}
```

**Expect:**
- Status: 200
- JSON path exists: `.data.access_token`
- JSON path exists: `.data.user.id`

**Capture:**
- `access_token` <- `.data.access_token`
- `user_id` <- `.data.user.id`

---

## Step 3: Get Profile

**Method:** GET
**Path:** /users/{{user_id}}

**Headers:**
- Authorization: Bearer {{access_token}}

**Expect:**
- Status: 200
- JSON path exists: `.data.phone_number`
