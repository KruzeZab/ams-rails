<script setup lang="ts">
import { ref } from 'vue';

import { useToast } from 'primevue';
import type { FormSubmitEvent } from '@primevue/forms';

import { Gender, Role, type SignupValues } from '@/interface/user';

import { signupSchema } from '@/schemas/userSchema';

import { createUser } from '@/utils/fetch';
import { getErrorMessage } from '@/utils/error';
import { errorToast, successToast } from '@/utils/toast';

const toast = useToast();

const initialValues = ref<SignupValues>({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  dob: '',
  phone: '',
  address: '',
  gender: Gender.MALE,
  role: Role.ARTIST_MANAGER,
});

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid) {
    return;
  }

  const { values, reset } = e;

  try {
    await createUser(values);

    // reset the form
    reset();

    successToast(toast, 'User added', 'User has been added');
  } catch (error) {
    const errorMsg = getErrorMessage(error);
    errorToast(toast, 'Failed to add user.', errorMsg);
  }
};
</script>

<template>
  <div class="mt-12 flex items-center justify-center px-4">
    <div class="w-full max-w-2xl rounded-2xl p-8 border border-green-400">
      <!-- Header -->
      <div class="text-center mb-4">
        <h2 class="text-3xl font-semibold">Add User</h2>
        <p class="text-gray-300 mt-2 text-sm">
          Add a new user to our platform.
        </p>
      </div>

      <UserForm
        :onFormSubmit="onFormSubmit"
        :resolver="signupSchema"
        :initialValues="initialValues"
      />
    </div>
  </div>
</template>
