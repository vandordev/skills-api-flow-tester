# Flow: Invalid Phone Login

**Base URL:** {{BASE_URL}}
**OpenAPI URL:** {{OPENAPI_URL}}
**Description:** Verify that login rejects an invalid phone number with a validation error.

---

## Step 1: Request OTP With Invalid Phone

**Method:** POST
**Path:** /auth/request-otp

**Headers:**
- Content-Type: application/json

**Body:**
```json
{
  "phone_number": "{{INVALID_PHONE_NUMBER}}"
}
```

**Expect:**
- Status: 422
- JSON path exists: `.error.code`
- JSON path equals: `.error.code` -> `INVALID_PHONE_NUMBER`
- JSON path contains: `.error.message` -> `phone`
