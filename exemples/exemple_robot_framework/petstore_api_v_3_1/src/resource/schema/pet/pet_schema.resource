*** Comments ***
    Swagger Petstore OpenAPI 3.1 - Pet response schema, taken from the official spec
    (https://petstore31.swagger.io/api/v31/openapi.json). Note this Pet schema includes availableInstances,
    petDetailsId and petDetails on top of the classic fields - real fields in this version, not present in v2.
*** Variables ***
${PET_SCHEMA}    ${{{'required': ['name', 'photoUrls'], 'types': {'id': int, 'name': str, 'category': dict, 'photoUrls': list, 'tags': list, 'status': str, 'availableInstances': int, 'petDetailsId': int, 'petDetails': dict}, 'enums': {'status': ['available', 'pending', 'sold']}}}}
