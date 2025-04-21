import axios from 'axios';

/**
 * Get the error message from error object
 *
 */
export function getErrorMessage(error: unknown) {
  let message = 'Something went wrong!';

  if (axios.isAxiosError(error)) {
    message = error.response?.data.message;
  }

  return message;
}

/**
 * Get the backends error message from error object
 *
 */
export function getBackendErrors(error: unknown) {
  let errors = {};

  if (axios.isAxiosError(error)) {
    errors = error.response?.data.errors;
  }

  return errors;
}
