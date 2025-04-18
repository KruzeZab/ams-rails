<script setup lang="ts">
import { useToast } from 'primevue';

import { deleteSong } from '@/utils/fetch';
import { errorToast, successToast } from '@/utils/toast';
import { getErrorMessage } from '@/utils/error';

interface DeleteModalProps {
  selectedSongId: number | null;
  visible: boolean;
  closeModal: () => void;
}

const toast = useToast();

const props = defineProps<DeleteModalProps>();
const emit = defineEmits<{
  (e: 'updated'): void;
  (e: 'update:visible', value: boolean): void;
}>();

const onDelete = async () => {
  if (!props.selectedSongId) {
    return;
  }

  try {
    await deleteSong(props.selectedSongId);

    successToast(toast, 'Song Deleted', 'Song has been deleted');

    emit('updated');
    emit('update:visible', false);
  } catch (error) {
    const errorMsg = getErrorMessage(error);
    errorToast(toast, "Couldn't delete", errorMsg);
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
      header="Delete Song"
      :style="{ width: '40rem' }"
      closable
      :dismissableMask="true"
    >
      <p>Are you sure you want to delete this song?</p>

      <Divider />

      <div class="flex gap-4 justify-end">
        <Button label="Cancel" severity="secondary" />
        <Button label="Delete" severity="danger" @click="onDelete" />
      </div>
    </Dialog>
  </div>
</template>
ass
