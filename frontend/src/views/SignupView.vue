<script setup lang="ts">
import { ref } from 'vue';

import { useToast } from 'primevue';
import { useRouter } from 'vue-router';
import type { FormSubmitEvent } from '@primevue/forms';

import { LOGIN_PATH } from '@/constants/routes';

import { Gender, Role, type SignupValues } from '@/interface/user';

import { signupSchema } from '@/schemas/userSchema';

import { signup } from '@/utils/fetch';
import { errorToast, successToast } from '@/utils/toast';
import { getBackendErrors, getErrorMessage } from '@/utils/error';

const toast = useToast();

const router = useRouter();

const backendErrors = ref<Record<string, string[]>>({});

const initialValues = ref<SignupValues>({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  dob: '',
  phone: '',
  address: '',
  gender: Gender.MALE,
  role: Role.SUPER_ADMIN,
});

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid) {
    return;
  }

  const { values, reset } = e;

  try {
    await signup(values);

    backendErrors.value = {};

    // reset the form
    reset();

    successToast(toast, 'Signup success', 'You have successfully signed up');

    router.push(LOGIN_PATH);
  } catch (error) {
    backendErrors.value = getBackendErrors(error);

    const errorMsg = getErrorMessage(error);

    errorToast(toast, 'Signup Failed', errorMsg);
  }
};
</script>

<template>
  <div class="mt-12 flex items-center justify-center px-4 mb-8">
    <div class="w-full max-w-2xl rounded-2xl p-8 border border-green-400">
      <!-- Header -->
      <div class="text-center mb-4">
        <h2 class="text-3xl font-semibold">Create an Account</h2>
        <p class="text-gray-300 mt-2 text-sm">
          Sign up to get started with our platform.
        </p>
      </div>

      <UserForm
        :onFormSubmit="onFormSubmit"
        :resolver="signupSchema"
        :initialValues="initialValues"
        hideRole
        :backendErrors="backendErrors"
      />

      <!-- Footer -->
      <div class="text-center mt-6 text-sm text-gray-300">
        Already have an account?
        <RouterLink :to="LOGIN_PATH" class="text-blue-600 hover:underline"
          >Log in</RouterLink
        >
      </div>
    </div>
  </div>
</template>
