*** Comments ***
    Swagger Petstore v2 - Pet and ApiResponse response schemas, taken from the official OpenAPI definitions.
*** Variables ***
${PET_SCHEMA}             ${{{'required': ['name', 'photoUrls'], 'types': {'id': int, 'name': str, 'category': dict, 'photoUrls': list, 'tags': list, 'status': str}, 'enums': {'status': ['available', 'pending', 'sold']}}}}
${API_RESPONSE_SCHEMA}    ${{{'required': [], 'types': {'code': int, 'type': str, 'message': str}, 'enums': {}}}}
