import { expect } from '@playwright/test';

/**
 * Shared, reusable response-schema validation, based on the ViaCEP documentation
 * (https://viacep.com.br/) and the actual response shapes confirmed against the live API.
 * Mirrors the same required/types checking logic used in the Robot Framework example.
 */
export interface FieldSchema {
    required: string[];
    types: Record<string, 'string' | 'number' | 'boolean' | 'object'>;
}

export function validateObjectSchema(data: unknown, schema: FieldSchema): void {
    expect(
        typeof data === 'object' && data !== null && !Array.isArray(data),
        `Response body is not a JSON object: ${JSON.stringify(data)}`,
    ).toBeTruthy();

    const obj = data as Record<string, unknown>;
    const errors: string[] = [];

    for (const field of schema.required) {
        if (!(field in obj)) {
            errors.push(`missing required field: ${field}`);
        }
    }

    for (const [field, expectedType] of Object.entries(schema.types)) {
        if (field in obj && obj[field] !== null && typeof obj[field] !== expectedType) {
            errors.push(`field ${field} expected type ${expectedType} but got ${typeof obj[field]}`);
        }
    }

    expect(errors, `Schema validation failed: ${errors.join(', ')}`).toEqual([]);
}

export function validateArraySchema(data: unknown, itemSchema: FieldSchema): void {
    expect(Array.isArray(data), `Response body is not a JSON array: ${JSON.stringify(data)}`).toBeTruthy();

    for (const item of data as unknown[]) {
        validateObjectSchema(item, itemSchema);
    }
}
