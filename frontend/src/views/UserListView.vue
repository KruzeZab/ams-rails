<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useToast, type DataTablePageEvent } from 'primevue';

import type { Meta } from '@/interface/common';
import type { UserResponse } from '@/interface/user';

import { formatDate } from '@/utils/date';
import { fetchUsers } from '@/utils/fetch';
import { errorToast } from '@/utils/toast';
import { getErrorMessage } from '@/utils/error';
import { getFullName, mapGenderToValue, mapRoleToValue } from '@/utils/string';

import {
  DEFAULT_LIMIT,
  DEFAULT_META,
  DEFAULT_PAGE_START,
} from '@/constants/pagination';

import { useCurrentUser } from '@/injectors/currentUser';

import AddUserModal from '@/components/modal/AddUserModal.vue';
import EditUserModal from '@/components/modal/EditUserModal.vue';
import DeleteUserModal from '@/components/modal/DeleteUserModal.vue';

interface UsersState {
  isLoading: boolean;
  users: UserResponse[];
  meta: Meta;
}

const router = useRouter();
const route = useRoute();

const currentUser = useCurrentUser();

const toast = useToast();

const isModalVisible = reactive({
  edit: false,
  delete: false,
  add: false,
});

const selectedUserId = ref<number | null>(null);

const openModal = (type: keyof typeof isModalVisible, userId?: number) => {
  if (userId) {
    selectedUserId.value = userId;
  }

  isModalVisible[type] = true;
};

const closeModal = () => {
  selectedUserId.value = null;
};

const state = reactive<UsersState>({
  isLoading: false,
  users: [],
  meta: {
    ...DEFAULT_META,
    currentPage: Number(route.query.page) || DEFAULT_PAGE_START,
  },
});

const loadUsers = async () => {
  try {
    state.isLoading = true;

    const { data } = await fetchUsers({
      page: state.meta.currentPage,
      limit: Number(route.query.limit) || DEFAULT_LIMIT,
    });

    state.users = data.data;
    state.meta = data.meta;
  } catch (error) {
    const errorMsg = getErrorMessage(error);

    errorToast(toast, 'Error', errorMsg);
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
      limit: Number(route.query.limit) || DEFAULT_LIMIT,
    },
  });

  loadUsers();
};

onMounted(async () => {
  loadUsers();
});
</script>

<template>
  <div class="mt-8 mx-16">
    <Card class="mb-4">
      <template #title>
        <div class="flex justify-between items-center gap-2">
          Users
          <div class="flex gap-2">
            <Button
              label="Add User"
              severity="contrast"
              size="small"
              @click="openModal('add')"
            />
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
        :rows="Number(route.query.limit) || DEFAULT_LIMIT"
        tableStyle="min-width: 50rem"
        :loading="state.isLoading"
        @page="onPageChange"
      >
        <template #empty>
          <EmptyTable />
        </template>
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
            {{ formatDate(slotProps.data.dob) }}
          </template>
        </Column>

        <Column field="email" header="Email Address" />
        <Column field="phone" header="Phone Number" />
        <Column field="address" header="Address" />

        <Column header="Role">
          <template #body="slotProps">
            {{ mapRoleToValue(slotProps.data.role) }}
          </template>
        </Column>

        <Column header="Actions">
          <template #body="slotProps">
            <div class="flex gap-2">
              <Button
                label="Edit"
                severity="contrast"
                size="small"
                @click="openModal('edit', slotProps.data.id)"
              />
              <Button
                v-if="currentUser?.userId !== slotProps.data.id"
                label="Delete"
                severity="danger"
                size="small"
                @click="openModal('delete', slotProps.data.id)"
              />
            </div>
          </template>
        </Column>
      </DataTable>
    </div>
    <AddUserModal
      v-model:visible="isModalVisible.add"
      @update:visible="isModalVisible.add = $event"
      @updated="loadUsers"
    />
    <EditUserModal
      :selectedUserId="selectedUserId"
      v-model:visible="isModalVisible.edit"
      :closeModal="closeModal"
      @update:visible="isModalVisible.edit = $event"
      @updated="loadUsers"
    />
    <DeleteUserModal
      :selectedUserId="selectedUserId"
      v-model:visible="isModalVisible.delete"
      :closeModal="closeModal"
      @update:visible="isModalVisible.delete = $event"
      @updated="loadUsers"
    />
  </div>
</template>
