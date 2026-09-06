# Pending upstream issue submissions

Ready-to-submit GitHub issue drafts, found while building this
`petstore_api_v_3_1` example (see `../KNOWN_ISSUES.md` for the full
write-up). Not submitted yet - `gh` was not available in the environment
that authored them.

## To submit (on a machine with `gh` installed and authenticated)

```bash
cd exemples/exemple_robot_framework/petstore_api_v_3_1/github_issues/swagger-api_swagger-petstore

gh issue create --repo swagger-api/swagger-petstore \
  --title "PUT /pet returns HTTP 500 when updating a Pet id that already exists" \
  --body-file put_pet_500_on_existing_id.body.md

gh issue create --repo swagger-api/swagger-petstore \
  --title "PUT /pet and POST /pet accept invalid enum/empty required fields with 200 instead of the documented 405" \
  --body-file no_field_validation_enforced.body.md

gh issue create --repo swagger-api/swagger-petstore \
  --title "GET /pet/{petId} does not enforce its own documented exclusiveMinimum/exclusiveMaximum range" \
  --body-file getpetbyid_range_not_enforced.body.md
```

Worth a quick `gh issue list --repo swagger-api/swagger-petstore --search "..."`
check first in case someone already reported the same thing. Once filed,
update this README (or delete the `.md`/`.body.md` pairs) to avoid double-submitting.
