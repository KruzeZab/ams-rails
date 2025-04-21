<script setup lang="ts">
import { ref } from 'vue';
import { useToast } from 'primevue';

import type { FormSubmitEvent } from '@primevue/forms';

import { Gender, Role, type SignupValues } from '@/interface/user';

import { isArtist } from '@/utils/user';
import { createUser } from '@/utils/fetch';
import { errorToast, successToast } from '@/utils/toast';
import { getBackendErrors, getErrorMessage } from '@/utils/error';

import { signupSchema } from '@/schemas/userSchema';

interface AddUserModalProps {
  visible: boolean;
  role?: Role;
}

const toast = useToast();

const props = defineProps<AddUserModalProps>();

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
  role: props.role ?? null,
});

const emit = defineEmits<{
  (e: 'updated'): void;
  (e: 'update:visible', value: boolean): void;
}>();

const onFormSubmit = async (e: FormSubmitEvent) => {
  // if (!e.valid) {
  //   return;
  // }

  const { values, reset } = e;

  let body;

  if (isArtist(values.role)) {
    body = {
      ...values,
      artist: {
        numberOfAlbumsReleased: values.numberOfAlbumsReleased,
        firstReleaseYear: values.firstReleaseYear,
      },
    };
  } else {
    body = { ...values };
  }

  try {
    await createUser(body);

    backendErrors.value = {};

    successToast(toast, 'User Added', 'User has been added');

    reset();
    emit('updated');
    emit('update:visible', false);
  } catch (error) {
    backendErrors.value = getBackendErrors(error);

    const errorMsg = getErrorMessage(error);
    errorToast(toast, 'Failed to add user', errorMsg);
  }
};
</script>
<template>
  <div class="card flex justify-center">
    <Dialog
      :visible="props.visible"
      @update:visible="emit('update:visible', $event)"
      modal
      header="Add a new user"
      :style="{ width: '40rem' }"
      closable
      :dismissableMask="true"
    >
      <UserForm
        :onFormSubmit="onFormSubmit"
        :resolver="signupSchema"
        :initialValues="initialValues"
        :backendErrors="backendErrors"
      />
    </Dialog>
  </div>
</template>
