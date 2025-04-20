<script setup lang="ts">
import { useToast } from 'primevue';
import { ref, watch } from 'vue';
import type { FormSubmitEvent } from '@primevue/forms';

import { updateUserSchema } from '@/schemas/userSchema';

import { Gender, Role, type EditUserValues } from '@/interface/user';

import { isArtist } from '@/utils/user';
import { getErrorMessage } from '@/utils/error';
import { formatDateForInput } from '@/utils/date';
import { errorToast, successToast } from '@/utils/toast';
import { fetchUserDetail, updateUser } from '@/utils/fetch';

import UserForm from '@/components/form/UserForm.vue';

interface EditUserModalProps {
  selectedUserId: number | null;
  visible: boolean;
  closeModal: () => void;
}

const toast = useToast();

const userRole = ref('');

const initialValues = ref<EditUserValues>({
  firstName: '',
  lastName: '',
  email: '',
  dob: '',
  phone: '',
  address: '',
  gender: Gender.MALE,
  ...(isArtist(userRole.value as Role) && {
    numberOfAlbumsReleased: null,
    firstReleaseYear: null,
  }),
});

const props = defineProps<EditUserModalProps>();
const emit = defineEmits<{
  (e: 'updated'): void;
  (e: 'update:visible', value: boolean): void;
}>();

const userFormRef = ref();

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid || !props.selectedUserId) {
    console.log(e);
    return;
  }

  const payload = {
    ...e.values,
    artist: isArtist(e.values.role)
      ? {
          numberOfAlbumsReleased: e.values.numberOfAlbumsReleased,
          firstReleaseYear: e.values.firstReleaseYear,
        }
      : undefined,
  };

  try {
    await updateUser(props.selectedUserId, payload);

    successToast(toast, 'Update Success', 'User has been updated');

    e.reset();
    emit('updated');
    emit('update:visible', false);
  } catch (error) {
    const errorMsg = getErrorMessage(error);
    errorToast(toast, 'Update Failed', errorMsg);
  }
};

watch(
  () => props.selectedUserId,
  async (newUserId) => {
    if (!newUserId) {
      return;
    }

    const { data } = await fetchUserDetail(newUserId);

    userRole.value = data.role;

    const newValues: EditUserValues = {
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      dob: formatDateForInput(data.dob),
      phone: data.phone,
      address: data.address,
      gender: data.gender,
      role: data.role,
      ...(isArtist(data.role) && {
        numberOfAlbumsReleased: data.artist?.numberOfAlbumsReleased,
        firstReleaseYear: data.artist?.firstReleaseYear,
      }),
    };

    if (userFormRef.value) {
      userFormRef.value.setFormValues(newValues);
    }
  },
);
</script>
<template>
  <div class="card flex justify-center">
    <Dialog
      :visible="props.visible"
      @hide="closeModal"
      @update:visible="emit('update:visible', $event)"
      modal
      header="Edit User"
      :style="{ width: '40rem' }"
      closable
      :dismissableMask="true"
    >
      <UserForm
        ref="userFormRef"
        :initialValues="initialValues"
        :resolver="updateUserSchema"
        :onFormSubmit="onFormSubmit"
        :isEdit="true"
      />
    </Dialog>
  </div>
</template>
