import { AUTH_TOKEN } from '@/constants/keys';
import type { Role } from '@/interface/user';
import { deleteItem } from '@/utils/localStorage';
import { toCamelCase } from '@/utils/object';
import { jwtDecode } from 'jwt-decode';
import { type InjectionKey, type Ref, ref, provide, inject } from 'vue';

interface CurrentUser {
  userId: number;
  fullName: string;
  role: Role;
  email: string;
  exp: number;
  artistId: number | null;
}

const CurrentUserKey: InjectionKey<Ref<CurrentUser | null>> =
  Symbol('CurrentUser');

export const currentUser = ref<CurrentUser | null>(null);

export function provideCurrentUser() {
  const token = localStorage.getItem(AUTH_TOKEN);

  if (token) {
    try {
      const decoded = toCamelCase(jwtDecode<CurrentUser>(token));

      const now = Date.now() / 1000;

      if (decoded.exp > now) {
        currentUser.value = decoded;
      }
    } catch (error) {
      console.error('Invalid JWT token', error);
    }
  }

  provide(CurrentUserKey, currentUser);
}

export function useCurrentUser() {
  const user = inject(CurrentUserKey);

  if (!user) {
    throw new Error(
      'useCurrentUser must be used within a component that calls provideCurrentUser()',
    );
  }

  return user;
}

export function updateCurrentUserFromToken(token: string) {
  try {
    const decoded = jwtDecode<CurrentUser>(token);
    const now = Date.now() / 1000;

    if (decoded.exp > now) {
      currentUser.value = toCamelCase(decoded);
    } else {
      currentUser.value = null;
    }
  } catch {
    currentUser.value = null;
  }
}

export function logout() {
  deleteItem(AUTH_TOKEN);
  updateCurrentUserFromToken('');
}
