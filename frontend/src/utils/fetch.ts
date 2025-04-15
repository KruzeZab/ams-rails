import type { LoginResponse } from '@/interface/auth';
import type { ApiResponse } from '@/interface/response';

import server from '@/server';
import config from '@/config';

import { buildUrl } from '@/utils/string';

/**
 * Login a user
 *
 */
export async function login(body = {}) {
  const loginUrl = buildUrl(config.endpoints.login);

  const { data } = await server.post<ApiResponse<LoginResponse>>(
    loginUrl,
    body,
  );

  return data;
}

/**
 * Signup a user
 *
 */
export async function signup(body = {}) {
  const signupUrl = buildUrl(config.endpoints.signup);

  const { data } = await server.post<ApiResponse<LoginResponse>>(
    signupUrl,
    body,
  );

  return data;
}

/**
 *
 */
export async function fetchUsers(params = {}) {
  const usersUrl = buildUrl(config.endpoints.users);

  const response = await server.get(usersUrl, { params });

  return response;
}
