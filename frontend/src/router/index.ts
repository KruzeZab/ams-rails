import { createRouter, createWebHistory } from 'vue-router';

import {
  HOME_PATH,
  LOGIN_PATH,
  SIGNUP_PATH,
  USERS_PATH,
} from '@/constants/routes';

import HomeView from '@/views/HomeView.vue';
import SignupView from '@/views/SignupView.vue';
import LoginView from '@/views/LoginView.vue';
import UserListView from '@/views/UserListView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: HOME_PATH,
      name: 'home',
      component: HomeView,
    },
    {
      path: SIGNUP_PATH,
      name: 'signup',
      component: SignupView,
    },
    {
      path: LOGIN_PATH,
      name: 'login',
      component: LoginView,
    },
    {
      path: USERS_PATH,
      name: 'users',
      component: UserListView,
    },
    // {
    //   path: USERS_PATH,
    //   name: 'users',
    //   component: UsersView,
    // },
  ],
});

export default router;
