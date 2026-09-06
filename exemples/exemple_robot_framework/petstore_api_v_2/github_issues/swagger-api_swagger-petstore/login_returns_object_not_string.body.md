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
