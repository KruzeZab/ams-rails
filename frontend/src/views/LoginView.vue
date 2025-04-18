<script setup lang="ts">
import { ref } from 'vue';

import { useToast } from 'primevue';
import { useRouter } from 'vue-router';
import type { FormSubmitEvent } from '@primevue/forms';

import { AUTH_TOKEN } from '@/constants/keys';
import { PROFILE_PATH, SIGNUP_PATH } from '@/constants/routes';

import { loginSchema } from '@/schemas/userSchema';

import type { LoginValues } from '@/interface/user';

import { login } from '@/utils/fetch';
import { setItem } from '@/utils/localStorage';
import { getErrorMessage } from '@/utils/error';
import { errorToast, successToast } from '@/utils/toast';

import { updateCurrentUserFromToken } from '@/injectors/currentUser';
import { zodResolver } from '@primevue/forms/resolvers/zod';

const toast = useToast();
const router = useRouter();

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

    // Update the user state
    setItem(AUTH_TOKEN, data.token);

    updateCurrentUserFromToken(data.token);

    // reset the form
    reset();

    successToast(toast, 'Login success', 'You are now logged in');

    router.push(PROFILE_PATH);
  } catch (error) {
    const errorMsg = getErrorMessage(error);

    errorToast(toast, 'Login Failed', errorMsg);
  }
};
</script>

<template>
  <div class="flex items-center justify-center px-4 mt-62">
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
        :resolver="zodResolver(loginSchema)"
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
