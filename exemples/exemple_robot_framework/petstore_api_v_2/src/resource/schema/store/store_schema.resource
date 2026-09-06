*** Comments ***
    Swagger Petstore v2 - Order response schema, taken from the official OpenAPI definitions.
*** Variables ***
${ORDER_SCHEMA}    ${{{'required': [], 'types': {'id': int, 'petId': int, 'quantity': int, 'shipDate': str, 'status': str, 'complete': bool}, 'enums': {'status': ['placed', 'approved', 'delivered']}}}}
