<script setup lang="ts">
import { ref } from 'vue';
import type { AxiosError } from 'axios';

import { useToast } from 'primevue';
import type { FormSubmitEvent } from '@primevue/forms';

import InputLabel from '@/components/form/InputLabel.vue';

import { LOGIN_PATH } from '@/constants/routes';

import { Gender, Role, type SignupValues } from '@/interface/user';

import { signupSchema } from '@/schemas/userSchema';

import { signup } from '@/utils/fetch';
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
  role: null,
});

const backendErrors = ref<string[]>([]);

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid) {
    return;
  }

  const { values, reset } = e;

  try {
    console.log(values);
    const { data } = await signup(values);

    console.log(data);
    console.log('Signup successful');

    // reset the form
    reset();

    successToast(toast, 'Signup success', 'You have successfully signed up');
  } catch (error: unknown) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const axiosError = error as AxiosError<any>;
    const responseErrors = axiosError.response?.data?.errors;

    if (Array.isArray(responseErrors)) {
      backendErrors.value = responseErrors.filter(
        (e): e is string => typeof e === 'string',
      );
    } else if (
      responseErrors &&
      typeof responseErrors === 'object' &&
      !Array.isArray(responseErrors)
    ) {
      const flattenedErrors = Object.values(responseErrors).reduce<string[]>(
        (acc, val) => acc.concat(val as string[]),
        [],
      );
      backendErrors.value = flattenedErrors.filter(
        (e): e is string => typeof e === 'string',
      );
    }

    errorToast(toast, 'Signup Failed', '');
  }
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-4">
    <div class="w-full max-w-2xl rounded-2xl p-8 border border-green-400">
      <!-- Header -->
      <div class="text-center mb-4">
        <h2 class="text-3xl font-semibold">Create an Account</h2>
        <p class="text-gray-300 mt-2 text-sm">
          Sign up to get started with our platform.
        </p>
      </div>

      <!-- Form Errors -->
      <div v-if="backendErrors.length" class="ml-4 mt-4">
        <ul class="text-red-400 list-disc text-sm">
          <li v-for="(error, idx) in backendErrors" :key="idx">{{ error }}</li>
        </ul>
      </div>

      <!-- Form -->
      <Form
        v-slot="$form"
        :resolver="signupSchema"
        :initialValues="initialValues"
        :validateOnValueUpdate="false"
        :validateOnSubmit="true"
        @submit="onFormSubmit"
        class="flex flex-col gap-6"
      >
        <!-- First Row: First Name + Last Name -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <!-- First Name -->
          <div class="flex flex-col gap-1">
            <InputLabel class="text-gray-400">First Name</InputLabel>
            <InputText
              name="firstName"
              type="text"
              placeholder="First Name"
              fluid
            />
            <Message
              v-if="$form.firstName?.invalid"
              severity="error"
              size="small"
              variant="simple"
            >
              {{ $form.firstName.error.message }}
            </Message>
          </div>

          <!-- Last Name -->
          <div class="flex flex-col gap-1">
            <InputLabel class="text-gray-400">Last Name</InputLabel>
            <InputText
              name="lastName"
              type="text"
              placeholder="Last Name"
              fluid
            />
            <Message
              v-if="$form.lastName?.invalid"
              severity="error"
              size="small"
              variant="simple"
            >
              {{ $form.lastName.error.message }}
            </Message>
          </div>
        </div>

        <!-- Second Row: Gender + Date of Birth -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <!-- Gender -->
          <div class="flex flex-col gap-1">
            <InputLabel class="text-gray-400">Gender</InputLabel>
            <Select
              name="gender"
              :options="GENDER_OPTIONS"
              optionLabel="name"
              placeholder="Select a Gender"
              v-model="initialValues.gender"
              fluid
            />
          </div>

          <!-- Date of Birth -->
          <div class="flex flex-col gap-1">
            <InputLabel class="text-gray-400">Date of Birth</InputLabel>
            <InputText
              name="dob"
              type="date"
              placeholder="Date of Birth"
              fluid
            />
            <Message
              v-if="$form.dob?.invalid"
              severity="error"
              size="small"
              variant="simple"
            >
              {{ $form.dob.error.message }}
            </Message>
          </div>
        </div>

        <!-- Email -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">Email</InputLabel>
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

        <!-- Address -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">Address</InputLabel>
          <InputText name="address" type="text" placeholder="Address" fluid />
          <Message
            v-if="$form.address?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.address.error.message }}
          </Message>
        </div>

        <!-- Phone -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">Phone Number</InputLabel>
          <InputText
            name="phone"
            type="text"
            placeholder="Phone Number"
            fluid
          />
          <Message
            v-if="$form.phone?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.phone.error.message }}
          </Message>
        </div>

        <!-- Password -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">Password</InputLabel>
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

        <!-- Role (Hidden) -->
        <input type="text" :value="Role.SUPER_ADMIN" hidden />

        <!-- Submit Button -->
        <Button type="submit" severity="success" label="Sign Up" />
      </Form>

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
