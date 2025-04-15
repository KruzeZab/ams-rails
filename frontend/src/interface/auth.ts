import type { UserResponse } from '@/interface/user';

export interface LoginResponse {
  user: UserResponse;
  token: string;
}
