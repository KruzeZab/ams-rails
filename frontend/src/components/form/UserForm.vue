<script setup lang="ts">
import { ref } from 'vue';
import type { FormSubmitEvent } from '@primevue/forms';

import { Role, type EditUserValues } from '@/interface/user';

import { GENDER_OPTIONS, ROLE_OPTIONS } from '@/constants/options';

import InputLabel from '@/components/form/InputLabel.vue';
import { zodResolver } from '@primevue/forms/resolvers/zod';
import { useCurrentUser } from '@/injectors/currentUser';
import { isSuperAdmin } from '@/utils/user';

export interface UserFormProps {
  initialValues: Record<string, string | number | null>;
  onFormSubmit: (e: FormSubmitEvent) => void;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  resolver: any;
  isEdit?: boolean;
  hideRole?: boolean;
}

const props = defineProps<UserFormProps>();

const formRef = ref();

const currentUser = useCurrentUser();

defineExpose({
  setFormValues: (values: EditUserValues) => {
    if (formRef.value) {
      formRef.value.setValues(values);
    }
  },
});
</script>

<template>
  <!-- Form -->
  <Form
    ref="formRef"
    v-slot="$form"
    :resolver="zodResolver(props.resolver)"
    :initialValues="props.initialValues"
    :validateOnValueUpdate="false"
    :validateOnSubmit="true"
    @submit="props.onFormSubmit"
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
        <InputText name="lastName" type="text" placeholder="Last Name" fluid />
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
          placeholder="Select a Gender"
          optionLabel="name"
          optionValue="value"
          fluid
        />

        <Message
          v-if="$form.gender?.invalid"
          severity="error"
          size="small"
          variant="simple"
          >{{ $form.gender?.error?.message }}</Message
        >
      </div>

      <!-- Date of Birth -->
      <div class="flex flex-col gap-1">
        <InputLabel class="text-gray-400">Date of Birth</InputLabel>
        <InputText name="dob" type="date" placeholder="Date of Birth" fluid />
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
      <InputText name="email" type="text" placeholder="Email Address" fluid />
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
      <InputText name="phone" type="text" placeholder="Phone Number" fluid />
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
    <div v-if="!props.isEdit" class="flex flex-col gap-1">
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

    <!-- Role -->
    <div
      :class="[
        'flex',
        'flex-col',
        'gap-1',
        isSuperAdmin(currentUser?.role) ? '' : 'hidden',
      ]"
    >
      <InputLabel class="text-gray-400">Role</InputLabel>
      <Select
        name="role"
        :options="ROLE_OPTIONS"
        placeholder="Select a Role"
        optionLabel="name"
        optionValue="value"
        fluid
      />

      <Message
        v-if="$form.role?.invalid"
        severity="error"
        size="small"
        variant="simple"
        >{{ $form.role?.error?.message }}</Message
      >
    </div>

    <div :class="{ hidden: $form.role?.value !== Role.ARTIST }" v>
      <Divider />
      <div class="grid grid-cols-1 sm:grid-cols-2 gra-4">
        <!-- Albums Released -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">Albums Released</InputLabel>
          <InputText
            name="numberOfAlbumsReleased"
            type="text"
            placeholder="2"
            fluid
          />
          <Message
            v-if="$form.numberOfAlbumsReleased?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.numberOfAlbumsReleased.error.message }}
          </Message>
        </div>

        <!-- First Release Year -->
        <div class="flex flex-col gap-1">
          <InputLabel class="text-gray-400">First Release Year</InputLabel>
          <InputText
            name="firstReleaseYear"
            type="text"
            placeholder="2002"
            fluid
          />
          <Message
            v-if="$form.firstReleaseYear?.invalid"
            severity="error"
            size="small"
            variant="simple"
          >
            {{ $form.firstReleaseYear.error.message }}
          </Message>
        </div>
      </div>
    </div>

    <!-- Submit Button -->
    <Button type="submit" severity="success" label="Submit" />
  </Form>
</template>
