/**
 * Set an item to local storage
 *
 */
export function setItem(key: string, value: string) {
  return localStorage.setItem(key, value);
}

/**
 * Get an item from local storage
 *
 */
export function getItem(key: string) {
  return localStorage.getItem(key);
}

/**
 * Delete item from local storage
 *
 */
export function deleteItem(key: string) {
  localStorage.removeItem(key);
}
