<script setup lang="ts">
import { onMounted, reactive } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { DataTablePageEvent } from 'primevue';

import type { Meta } from '@/interface/common';
import type { UserResponse } from '@/interface/user';

import { fetchUsers } from '@/utils/fetch';

import { DEFAULT_LIMIT, DEFAULT_META } from '@/constants/pagination';
import { getFullName, mapGenderToValue, mapRoleToValue } from '@/utils/string';

interface UsersState {
  isLoading: boolean;
  users: UserResponse[];
  error: string;
  meta: Meta;
}

const router = useRouter();
const route = useRoute();

const state = reactive<UsersState>({
  isLoading: false,
  users: [],
  error: '',
  meta: DEFAULT_META,
});

const loadUsers = async () => {
  try {
    state.isLoading = true;

    const { data } = await fetchUsers({
      page: state.meta.currentPage,
    });

    state.users = data.data;
    state.meta = data.meta;
  } catch (error: unknown) {
    state.error = error instanceof Error ? error.message : 'Unknown error';
  } finally {
    state.isLoading = false;
  }
};

const onPageChange = (event: DataTablePageEvent) => {
  const newPage = Math.floor(event.first / event.rows) + 1;

  state.meta.currentPage = newPage;

  router.replace({
    path: route.path,
    query: {
      ...route.query,
      page: newPage.toString(),
    },
  });

  loadUsers();
};

onMounted(async () => {
  loadUsers();
});
</script>

<template>
  <div class="mt-8 container mx-auto">
    <Card class="mb-4">
      <template #title>
        <div class="flex justify-between items-center gap-2">
          Users
          <div class="flex gap-2">
            <Button label="Add Manager" severity="success" size="small" />
            <Button label="Add Artist" severity="success" size="small" />
          </div></div
      ></template>
    </Card>
    <div class="card">
      <DataTable
        :value="state.users"
        :lazy="true"
        :paginator="true"
        :totalRecords="state.meta.totalCount"
        :first="(state.meta.currentPage - 1) * DEFAULT_LIMIT"
        :rows="DEFAULT_LIMIT"
        tableStyle="min-width: 50rem"
        :loading="state.isLoading"
        @page="onPageChange"
      >
        <Column header="SN">
          <template #body="slotProps">
            {{ slotProps.index + 1 }}
          </template>
        </Column>

        <Column header="Full Name">
          <template #body="slotProps">
            {{ getFullName(slotProps.data.firstName, slotProps.data.lastName) }}
          </template>
        </Column>

        <Column header="Gender">
          <template #body="slotProps">
            {{ mapGenderToValue(slotProps.data.gender) }}
          </template>
        </Column>

        <Column header="Date of Birth">
          <template #body="slotProps">
            {{ slotProps.data.dob }}
          </template>
        </Column>

        <Column field="email" header="Email Address"></Column>
        <Column field="phone" header="Phone Number"></Column>
        <Column field="address" header="Address"></Column>

        <Column header="Role">
          <template #body="slotProps">
            {{ mapRoleToValue(slotProps.data.role) }}
          </template>
        </Column>
      </DataTable>
    </div>
  </div>
</template>
