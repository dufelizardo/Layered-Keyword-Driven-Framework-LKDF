TITLE: GET /user/login returns an object, not the documented `string` schema

TARGET REPO: swagger-api/swagger-petstore

STATUS: Not yet submitted. To submit once `gh` is available and authenticated:

    gh issue create --repo swagger-api/swagger-petstore \
      --title "GET /user/login returns an object, not the documented \`string\` schema" \
      --body-file login_returns_object_not_string.body.md

---
BODY (also saved separately as login_returns_object_not_string.body.md):

The OpenAPI spec for `GET /user/login` documents the 200 response schema as:

    {"type": "string"}

But the live server at https://petstore.swagger.io/v2 actually returns a JSON object:

    {"code": 200, "type": "unknown", "message": "logged in user session:1788698084010"}

Repro:
GET https://petstore.swagger.io/v2/user/login?username=<any>&password=<any>

Expected: a plain string per swagger.json.
Actual: an ApiResponse-shaped object.

Any client generated strictly from the spec (expecting a bare string / token) will
mishandle this response.
