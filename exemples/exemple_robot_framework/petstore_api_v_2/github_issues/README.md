# Pending upstream issue submissions

These are ready-to-submit GitHub issue drafts, found while building the
`petstore_api_v_2` schema-validation suite (see `../KNOWN_ISSUES.md` for the
full write-up in project context). They have **not** been submitted yet —
`gh` was not available in the environment that authored them.

## To submit (on a machine with `gh` installed and authenticated)

```bash
cd exemples/exemple_robot_framework/petstore_api_v_2/github_issues/swagger-api_swagger-petstore

gh issue create --repo swagger-api/swagger-petstore \
  --title "GET /user/login returns an object, not the documented \`string\` schema" \
  --body-file login_returns_object_not_string.body.md

gh issue create --repo swagger-api/swagger-petstore \
  --title "GET /pet/findByStatus can return Pet objects missing the required \`name\` field" \
  --body-file findbystatus_missing_required_name.body.md
```

Before submitting, worth a quick `gh issue list --repo swagger-api/swagger-petstore --search "findByStatus"` /
`--search "user/login"` check in case someone already reported the same thing.

Once filed, update this README (or delete the two `.md`/`.body.md` pairs) so
we don't double-submit later.
