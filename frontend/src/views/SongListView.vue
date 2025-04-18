<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useToast, type DataTablePageEvent } from 'primevue';

import type { Song } from '@/interface/song';
import type { Meta } from '@/interface/common';

import { errorToast } from '@/utils/toast';
import { getErrorMessage } from '@/utils/error';
import { fetchArtistDetail, fetchSongs } from '@/utils/fetch';
import { getFullName, mapGenreToValue } from '@/utils/string';

import {
  DEFAULT_LIMIT,
  DEFAULT_META,
  DEFAULT_PAGE_START,
} from '@/constants/pagination';

import type { ArtistResponse } from '@/interface/user';
import AddSongModal from '@/components/modal/AddSongModal.vue';
import EditSongModal from '@/components/modal/EditSongModal.vue';
import DeleteSongModal from '@/components/modal/DeleteSongModal.vue';

interface SongState {
  isLoading: boolean;
  songs: Song[];
  meta: Meta;
  artist: ArtistResponse | null;
}

const router = useRouter();
const route = useRoute();

const toast = useToast();

const artistId = Number(route.params.artistId);

const isAddModalVisible = ref(false);
const isEditModalVisible = ref(false);
const isDeleteModalVisible = ref(false);
const selectedSongId = ref<number | null>(null);

const openAddModal = () => {
  isAddModalVisible.value = true;
};

const openEditModal = (songId: number) => {
  selectedSongId.value = songId;
  isEditModalVisible.value = true;
};

const closeEditModal = () => {
  selectedSongId.value = null;
};

const openDeleteModal = (songId: number) => {
  selectedSongId.value = songId;
  isDeleteModalVisible.value = true;
};

const closeDeleteModal = () => {
  selectedSongId.value = null;
};

const state = reactive<SongState>({
  isLoading: false,
  songs: [],
  artist: null,
  meta: {
    ...DEFAULT_META,
    currentPage: Number(route.query.page) || DEFAULT_PAGE_START,
  },
});

const loadSongs = async () => {
  try {
    state.isLoading = true;

    const { data } = await fetchSongs({
      page: state.meta.currentPage,
      limit: Number(route.query.limit) || DEFAULT_LIMIT,
      artist_id: artistId,
    });

    state.songs = data.data;
    state.meta = data.meta;
  } catch (error) {
    const errorMsg = getErrorMessage(error);

    errorToast(toast, 'Error', errorMsg);
  } finally {
    state.isLoading = false;
  }
};

const loadArtist = async () => {
  try {
    state.isLoading = true;

    const { data } = await fetchArtistDetail(artistId);

    state.artist = data;
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

  loadSongs();
};

onMounted(() => {
  loadSongs();
  loadArtist();
});
</script>

<template>
  <div class="mt-8 mx-16">
    <div v-if="state.artist">
      <Card class="mb-4">
        <template #title>
          <div class="flex justify-between items-center gap-2">
            {{
              getFullName(
                state.artist.user.firstName,
                state.artist.user.lastName,
              )
            }}
            songs
            <div class="flex gap-2">
              <Button
                label="Add Song"
                severity="contrast"
                size="small"
                @click="openAddModal()"
              />
            </div></div
        ></template>
      </Card>
    </div>

    <!-- Loading Spinner -->
    <div v-if="state.isLoading" class="flex justify-center items-center py-12">
      <ProgressSpinner />
    </div>

    <div v-else-if="state.artist" class="card">
      <DataTable
        :value="state.songs"
        :lazy="true"
        :paginator="!!state.songs.length"
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

        <Column field="title" header="Title" />
        <Column header="Genre">
          <template #body="slotProps">
            {{ mapGenreToValue(slotProps.data.genre) }}
          </template>
        </Column>
        <Column field="albumName" header="Album Name" />

        <Column header="Actions">
          <template #body="slotProps">
            <div class="flex gap-2">
              <Button
                label="Edit"
                severity="contrast"
                size="small"
                @click="openEditModal(slotProps.data.id)"
              />
              <Button
                label="Delete"
                severity="danger"
                size="small"
                @click="openDeleteModal(slotProps.data.id)"
              />
            </div>
          </template>
        </Column>
      </DataTable>
    </div>

    <AddSongModal
      :artistId="artistId"
      v-model:visible="isAddModalVisible"
      @update:visible="isAddModalVisible = $event"
      @updated="() => loadSongs()"
      :closeModal="closeEditModal"
    />

    <EditSongModal
      :selectedSongId="selectedSongId"
      v-model:visible="isEditModalVisible"
      :closeModal="closeEditModal"
      @update:visible="isEditModalVisible = $event"
      @updated="() => loadSongs()"
    />

    <DeleteSongModal
      :selectedSongId="selectedSongId"
      v-model:visible="isDeleteModalVisible"
      :closeModal="closeDeleteModal"
      @update:visible="isDeleteModalVisible = $event"
      @updated="() => loadSongs()"
    />
  </div>
</template>
