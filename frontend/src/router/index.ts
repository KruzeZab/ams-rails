import { createRouter, createWebHistory } from 'vue-router';

import {
  ARTISTS_PATH,
  PROFILE_PATH,
  LOGIN_PATH,
  SIGNUP_PATH,
  SONGS_PATH,
  USERS_PATH,
} from '@/constants/routes';

import { Role } from '@/interface/user';
import { currentUser } from '@/injectors/currentUser';

import HomeView from '@/views/ProfileView.vue';
import LoginView from '@/views/LoginView.vue';
import SignupView from '@/views/SignupView.vue';
import UserListView from '@/views/UserListView.vue';
import SongListView from '@/views/SongListView.vue';
import ArtistListView from '@/views/ArtistListView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: PROFILE_PATH,
      name: '',
      component: HomeView,
      meta: { requiresAuth: true },
    },
    {
      path: SIGNUP_PATH,
      name: 'signup',
      component: SignupView,
      meta: { guestOnly: true },
    },
    {
      path: LOGIN_PATH,
      name: 'login',
      component: LoginView,
      meta: { guestOnly: true },
    },
    {
      path: USERS_PATH,
      name: 'users',
      component: UserListView,
      meta: {
        requiresAuth: true,
        roles: [Role.SUPER_ADMIN],
      },
    },
    {
      path: ARTISTS_PATH,
      name: 'artists',
      component: ArtistListView,
      meta: {
        requiresAuth: true,
        roles: [Role.SUPER_ADMIN, Role.ARTIST_MANAGER],
      },
    },
    {
      path: SONGS_PATH,
      name: 'songs',
      component: SongListView,
      meta: { requiresAuth: true, roles: [Role.SUPER_ADMIN, Role.ARTIST] },
    },
  ],
});

router.beforeEach((to, from, next) => {
  const allowedRoles = to.meta.roles as Role[] | undefined;
  const guestOnly = to.meta.guestOnly as boolean | undefined;
  const isLoggedIn = !!currentUser.value;
  const requiresAuth = to.meta.requiresAuth as boolean | undefined;

  if (requiresAuth && !isLoggedIn) {
    return next({ path: LOGIN_PATH });
  }

  if (guestOnly && isLoggedIn) {
    return next({ path: PROFILE_PATH });
  }

  if (requiresAuth && currentUser.value && allowedRoles?.length) {
    const userRole = currentUser.value.role;
    if (userRole && !allowedRoles.includes(userRole)) {
      return next(from.path);
    }
  }

  next();
});

export default router;
