<script setup lang="ts">
import { useToast } from 'primevue';
import { useRouter } from 'vue-router';
import { onMounted, reactive } from 'vue';

import { LOGIN_PATH } from '@/constants/routes';

import { errorToast } from '@/utils/toast';
import { fetchUserDetail } from '@/utils/fetch';
import { getErrorMessage } from '@/utils/error';
import { getFullName, mapGenderToValue, mapRoleToValue } from '@/utils/string';

import type { UserResponse } from '@/interface/user';

import { useCurrentUser } from '@/injectors/currentUser';

const currentUser = useCurrentUser();

const toast = useToast();
const router = useRouter();

interface UserDetailState {
  isLoading: boolean;
  data: UserResponse | null;
}

const state = reactive<UserDetailState>({
  isLoading: false,
  data: null,
});

onMounted(async () => {
  if (!currentUser.value) {
    router.push(LOGIN_PATH);
    return;
  }

  try {
    state.isLoading = true;
    const { data } = await fetchUserDetail(currentUser.value.userId);

    state.data = data;
  } catch (error) {
    const errorMsg = getErrorMessage(error);

    errorToast(toast, 'Error', errorMsg);
  } finally {
    state.isLoading = false;
  }
});
</script>

<template>
  <div class="container mx-auto">
    <Card class="mt-8">
      <template #title>
        <div class="text-3xl">Profile Information</div>
        <Divider />
      </template>
      <template #content>
        <div v-if="state.isLoading" class="flex justify-center mt-2">
          <ProgressSpinner />
        </div>
        <div v-else-if="!state.data" class="flex justify-center text-xl">
          User not found
        </div>
        <div v-else class="list-disc text-xl flex flex-col gap-2">
          <p>
            Full Name:
            <strong>{{
              getFullName(state.data.firstName, state.data.lastName)
            }}</strong>
          </p>
          <p>
            Gender:
            <strong>{{ mapGenderToValue(state.data.gender) }}</strong>
          </p>
          <p>
            Address:
            <strong>{{ state.data.address }}</strong>
          </p>
          <p>
            Role:
            <strong>{{ mapRoleToValue(state.data.role) }}</strong>
          </p>
          <p>
            Phone: <strong>{{ state.data.phone }}</strong>
          </p>
          <p>
            Email: <strong>{{ state.data.email }}</strong>
          </p>
        </div>
      </template>
    </Card>
  </div>
</template>
