import axios from 'axios';

import config from '@/config';

import { AUTH_TOKEN } from '@/constants/keys';

import { getItem } from '@/utils/localStorage';
import { toCamelCase, toSnakeCase } from '@/utils/object';

const server = axios.create({
  baseURL: config.serverUrl,
  headers: { 'Content-Type': 'application/json' },
});

server.interceptors.request.use(
  (request) => {
    const token = getItem(AUTH_TOKEN);

    if (token) {
      request.headers.Authorization = `Bearer ${token}`;
    }

    if (request.data) {
      request.data = toSnakeCase(request.data);
    }

    return request;
  },
  (error) => {
    return Promise.reject(error);
  },
);

server.interceptors.response.use((response) => {
  if (response.data) {
    response.data = toCamelCase(response.data);
  }

  return response;
});

export default server;
