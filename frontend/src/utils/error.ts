import axios from 'axios';

export function getErrorMessage(error: unknown) {
  let message = 'Something went wrong!';

  if (axios.isAxiosError(error)) {
    message = error.response?.data.message;
  }

  return message;
}
