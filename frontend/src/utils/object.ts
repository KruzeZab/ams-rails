import { isPlainObject, isArray, snakeCase, camelCase } from 'lodash';

/**
 * Convert camel case to snake case
 *
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const toSnakeCase = (obj: any): any => {
  if (isArray(obj)) {
    return obj.map(toSnakeCase);
  }

  if (isPlainObject(obj)) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return Object.keys(obj).reduce((result: any, key: string) => {
      const snakeKey = snakeCase(key);
      result[snakeKey] = toSnakeCase(obj[key]);
      return result;
    }, {});
  }

  return obj;
};

/**
 * Convert snake case to camel case
 *
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const toCamelCase = (obj: any): any => {
  if (isArray(obj)) {
    return obj.map(toCamelCase);
  }

  if (isPlainObject(obj)) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return Object.keys(obj).reduce((result: any, key: string) => {
      const camelKey = camelCase(key);
      result[camelKey] = toCamelCase(obj[key]);
      return result;
    }, {});
  }

  return obj;
};
