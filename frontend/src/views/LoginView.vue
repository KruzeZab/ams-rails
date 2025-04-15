<script setup lang="ts">
import { ref } from 'vue';

import { useToast } from 'primevue';
import type { FormSubmitEvent } from '@primevue/forms';

import type { AxiosError } from 'axios';

import { SIGNUP_PATH } from '@/constants/routes';
import { AUTH_TOKEN, USER } from '@/constants/keys';

import type { LoginValues } from '@/interface/user';

import { loginSchema } from '@/schemas/userSchema';

import { login } from '@/utils/fetch';
import { setItem } from '@/utils/localStorage';
import { errorToast, successToast } from '@/utils/toast';

const toast = useToast();

const initialValues = ref<LoginValues>({
  email: '',
  password: '',
});

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid) {
    return;
  }

  const {
    values: { email, password },
    reset,
  } = e;

  const loginBody = {
    email,
    password,
  };

  try {
    const { data } = await login(loginBody);

    // set local storage for token and user
    setItem(AUTH_TOKEN, data.token);
    setItem(USER, JSON.stringify(data.user));

    // reset the form
    reset();

    successToast(toast, 'Login success', 'You are now logged in');
  } catch (error: unknown) {
    const axiosError = error as AxiosError<{ message: string }>;
    const message =
      axiosError.response?.data?.message || 'An unexpected error occurred';

    errorToast(toast, 'Login Failed', message);
  }
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-4">
    <div class="w-full max-w-2xl rounded-2xl p-8 border border-green-400">
      <!-- Header -->
      <div class="text-center mb-8">
        <h2 class="text-3xl font-semibold">Login To AMS</h2>
        <p class="text-gray-300 mt-2 text-sm">
          Login to get started with our platform.
        </p>
      </div>

      <!-- Form -->
      <Form
        v-slot="$form"
        :resolver="loginSchema"
        :initialValues="initialValues"
        :validateOnValueUpdate="false"
        :validateOnSubmit="true"
        @submit="onFormSubmit"
        class="flex flex-col gap-6"
      >
        <!-- Email -->
        <div class="flex flex-col gap-1">
          <InputText
            name="email"
            type="text"
            placeholder="Email Address"
            fluid
          />
          <Message
            v-if="$form.email?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.email.error.message }}
          </Message>
        </div>

        <!-- Password -->
        <div class="flex flex-col gap-1">
          <Password
            name="password"
            type="password"
            :feedback="false"
            placeholder="Password"
            toggleMask
            fluid
          />
          <Message
            v-if="$form.password?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.password.error.message }}
          </Message>
        </div>

        <!-- Submit Button -->
        <Button type="submit" severity="success" label="Login" />
      </Form>

      <!-- Footer -->
      <div class="text-center mt-6 text-sm text-gray-300">
        Don't have an account?
        <RouterLink :to="SIGNUP_PATH" class="text-blue-600 hover:underline"
          >Signup</RouterLink
        >
      </div>
    </div>
  </div>
</template>
