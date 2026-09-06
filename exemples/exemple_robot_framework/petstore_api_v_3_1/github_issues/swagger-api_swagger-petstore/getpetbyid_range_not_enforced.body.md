The `petId` path parameter on `GET /pet/{petId}` is documented with
`"exclusiveMinimum": 1, "exclusiveMaximum": 10` (i.e. only 2-9 are valid),
with a 400 "Invalid ID supplied" response for values outside that range.

That range does not appear to be enforced:

```
curl https://petstore31.swagger.io/api/v31/pet/1
# -> 200 with a full Pet body, even though 1 is excluded by exclusiveMinimum
```

Separately, a very large / presumably nonexistent id returns 400 rather than
the documented 404 "Pet not found":

```
curl https://petstore31.swagger.io/api/v31/pet/999999999
# -> 400 "Invalid ID supplied", not 404
```

So the documented boundary isn't enforced at the low end, and 404 doesn't
appear reachable at the high end either - some other, undocumented upper
bound seems to trigger 400 instead.
