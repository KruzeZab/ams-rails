<script setup lang="ts">
import { useToast } from 'primevue';
import { ref, watch } from 'vue';
import type { FormSubmitEvent } from '@primevue/forms';

import type { SongFormValues } from '@/interface/song';

import { errorToast, successToast } from '@/utils/toast';
import { fetchSongDetail, updateSong } from '@/utils/fetch';

import SongForm from '@/components/form/SongForm.vue';
import { songSchema } from '@/schemas/songSchema';

interface EditSongModalProps {
  selectedSongId: number | null;
  visible: boolean;
  closeModal: () => void;
}

const toast = useToast();

const initialValues = ref<SongFormValues>({
  title: '',
  albumName: '',
  genre: null,
});

const props = defineProps<EditSongModalProps>();
const emit = defineEmits<{
  (e: 'updated'): void;
  (e: 'update:visible', value: boolean): void;
}>();

const songFormRef = ref();

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid || !props.selectedSongId) {
    return;
  }

  try {
    await updateSong(props.selectedSongId, e.values);

    successToast(toast, 'Update Success', 'Song has been updated');

    e.reset();
    emit('updated');
    emit('update:visible', false);
  } catch (error) {
    const detail =
      error instanceof Error ? error.message : 'Something went wrong';
    errorToast(toast, 'Update Failed', detail);
  }
};

watch(
  () => props.selectedSongId,
  async (newSongId) => {
    if (!newSongId) {
      return;
    }

    const { data } = await fetchSongDetail(newSongId);

    const newValues: SongFormValues = {
      title: data.title,
      albumName: data.albumName,
      genre: data.genre,
    };

    songFormRef.value?.setFormValues(newValues);
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
      header="Edit Song"
      :style="{ width: '40rem' }"
      closable
      :dismissableMask="true"
    >
      <SongForm
        ref="songFormRef"
        :initialValues="initialValues"
        :resolver="songSchema"
        :onFormSubmit="onFormSubmit"
        :isEdit="true"
      />
    </Dialog>
  </div>
</template>
