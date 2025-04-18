<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { RouterLink, useRoute, useRouter } from 'vue-router';
import { useToast, type DataTablePageEvent } from 'primevue';

import type { Meta } from '@/interface/common';
import { Role, type ArtistResponse } from '@/interface/user';

import { errorToast } from '@/utils/toast';
import { fetchArtists } from '@/utils/fetch';
import { getFullName, interpolate, mapGenderToValue } from '@/utils/string';

import {
  DEFAULT_LIMIT,
  DEFAULT_META,
  DEFAULT_PAGE_START,
} from '@/constants/pagination';

import { formatDate } from '@/utils/date';
import { getErrorMessage } from '@/utils/error';

import { SONGS_PATH } from '@/constants/routes';

import { useCurrentUser } from '@/injectors/currentUser';

import AddUserModal from '@/components/modal/AddUserModal.vue';
import EditUserModal from '@/components/modal/EditUserModal.vue';
import DeleteUserModal from '@/components/modal/DeleteUserModal.vue';
import { isSuperAdmin } from '@/utils/user';

interface ArtistsState {
  isLoading: boolean;
  artists: ArtistResponse[];
  meta: Meta;
}

const router = useRouter();
const route = useRoute();

const toast = useToast();

const currentUser = useCurrentUser();

const selectedUserId = ref<number | null>(null);

const isModalVisible = reactive({
  edit: false,
  delete: false,
  add: false,
});

const openModal = (type: keyof typeof isModalVisible, userId?: number) => {
  if (userId) {
    selectedUserId.value = userId;
  }

  isModalVisible[type] = true;
};

const closeModal = () => {
  selectedUserId.value = null;
};

const state = reactive<ArtistsState>({
  isLoading: false,
  artists: [],
  meta: {
    ...DEFAULT_META,
    currentPage: Number(route.query.page) || DEFAULT_PAGE_START,
  },
});

const loadArtists = async () => {
  try {
    state.isLoading = true;

    const { data } = await fetchArtists({
      page: state.meta.currentPage,
      limit: Number(route.query.limit) || DEFAULT_LIMIT,
    });

    state.artists = data.data;
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

  loadArtists();
};

onMounted(async () => {
  loadArtists();
});
</script>

<template>
  <div class="mt-8 mx-16">
    <Card class="mb-4">
      <template #title>
        <div class="flex justify-between items-center gap-2">
          Artists
          <div class="flex gap-2">
            <Button
              label="Add Artist"
              severity="contrast"
              size="small"
              @click="openModal('add')"
            />
          </div></div
      ></template>
    </Card>
    <div class="card">
      <DataTable
        :value="state.artists"
        :lazy="true"
        :paginator="!!state.artists.length"
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
            {{
              getFullName(
                slotProps.data.user.firstName,
                slotProps.data.user.lastName,
              )
            }}
          </template>
        </Column>

        <Column header="Gender">
          <template #body="slotProps">
            {{ mapGenderToValue(slotProps.data.user.gender) }}
          </template>
        </Column>

        <Column header="Date of Birth">
          <template #body="slotProps">
            {{ formatDate(slotProps.data.user.dob) }}
          </template>
        </Column>

        <Column field="user.email" header="Email Address" />
        <Column field="user.phone" header="Phone Number" />
        <Column field="user.address" header="Address" />
        <Column
          field="numberOfAlbumsReleased"
          header="Albums Released"
        ></Column>
        <Column field="firstReleaseYear" header="First Release Year" />

        <div v-if="isSuperAdmin(currentUser?.role)">
          <Column header="Songs">
            <template #body="slotProps"
              ><Button
                label="Songs"
                severity="help"
                size="small"
                :as="RouterLink"
                :to="interpolate(SONGS_PATH, { artistId: slotProps.data.id })"
            /></template>
          </Column>
        </div>

        <Column header="Actions">
          <template #body="slotProps">
            <div class="flex gap-2">
              <Button
                label="Edit"
                severity="contrast"
                size="small"
                @click="openModal('edit', slotProps.data.user.id)"
              />
              <Button
                label="Delete"
                severity="danger"
                size="small"
                @click="openModal('delete', slotProps.data.user.id)"
              />
            </div>
          </template>
        </Column>
      </DataTable>
    </div>
    <AddUserModal
      v-model:visible="isModalVisible.add"
      @update:visible="isModalVisible.add = $event"
      @updated="loadArtists"
      :role="Role.ARTIST"
    />
    <EditUserModal
      :selectedUserId="selectedUserId"
      v-model:visible="isModalVisible.edit"
      :closeModal="closeModal"
      @update:visible="isModalVisible.edit = $event"
      @updated="loadArtists"
    />
    <DeleteUserModal
      :selectedUserId="selectedUserId"
      v-model:visible="isModalVisible.delete"
      :closeModal="closeModal"
      @update:visible="isModalVisible.delete = $event"
      @updated="loadArtists"
    />
  </div>
</template>
