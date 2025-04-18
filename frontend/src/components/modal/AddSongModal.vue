<script setup lang="ts">
import { ref } from 'vue';
import { useToast } from 'primevue';
import type { FormSubmitEvent } from '@primevue/forms';

import { Genre, type SongFormValues } from '@/interface/song';

import { addSong } from '@/utils/fetch';
import { errorToast, successToast } from '@/utils/toast';

import SongForm from '@/components/form/SongForm.vue';
import { songSchema } from '@/schemas/songSchema';
import { getErrorMessage } from '@/utils/error';

interface AddSongModalProps {
  artistId: number;
  visible: boolean;
  closeModal: () => void;
}

const toast = useToast();

const initialValues = ref<SongFormValues>({
  title: '',
  albumName: '',
  genre: Genre.CLASSIC,
});

const props = defineProps<AddSongModalProps>();
const emit = defineEmits<{
  (e: 'updated'): void;
  (e: 'update:visible', value: boolean): void;
}>();

const onFormSubmit = async (e: FormSubmitEvent) => {
  if (!e.valid) {
    return;
  }

  const { values, reset } = e;

  try {
    await addSong({
      ...values,
      artistId: props.artistId,
    });

    successToast(toast, 'Song Added', 'Song has been added');

    reset();
    emit('updated');
    emit('update:visible', false);
  } catch (error) {
    const errorMsg = getErrorMessage(error);
    errorToast(toast, 'Failed to add song', errorMsg);
  }
};
</script>
<template>
  <div class="card flex justify-center">
    <Dialog
      :visible="props.visible"
      @hide="closeModal"
      @update:visible="emit('update:visible', $event)"
      modal
      header="Add a new song"
      :style="{ width: '40rem' }"
      closable
      :dismissableMask="true"
    >
      <SongForm
        ref="songFormRef"
        :initialValues="initialValues"
        :resolver="songSchema"
        :onFormSubmit="onFormSubmit"
      />
    </Dialog>
  </div>
</template>
