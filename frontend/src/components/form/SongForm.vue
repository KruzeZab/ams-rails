<script setup lang="ts">
import { ref } from 'vue';
import type { FormSubmitEvent } from '@primevue/forms';

import type { SongFormValues } from '@/interface/song';

import InputLabel from '@/components/form/InputLabel.vue';
import { GENRE_OPTIONS } from '@/constants/options';

export interface SongFormProps {
  initialValues: Record<string, string | number | null>;
  onFormSubmit: (e: FormSubmitEvent) => void;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  resolver: any;
  isEdit?: boolean;
}

const props = defineProps<SongFormProps>();

const formRef = ref();

defineExpose({
  setFormValues: (values: SongFormValues) => {
    formRef.value?.setValues(values);
  },
});
</script>

<template>
  <!-- Form -->
  <Form
    ref="formRef"
    v-slot="$form"
    :resolver="props.resolver"
    :initialValues="props.initialValues"
    :validateOnValueUpdate="false"
    :validateOnSubmit="true"
    @submit="props.onFormSubmit"
    class="flex flex-col gap-6"
  >
    <!-- Title -->
    <div class="flex flex-col gap-1">
      <InputLabel class="text-gray-400">Title</InputLabel>
      <InputText name="title" type="text" placeholder="Echoes" fluid />
      <Message
        v-if="$form.title?.invalid"
        severity="error"
        size="small"
        variant="simple"
      >
        {{ $form.title.error.message }}
      </Message>
    </div>

    <!-- Album Name -->
    <div class="flex flex-col gap-1">
      <InputLabel class="text-gray-400">Album Name</InputLabel>
      <InputText
        name="albumName"
        type="text"
        placeholder="Dark side of the moon"
        fluid
      />
      <Message
        v-if="$form.albumName?.invalid"
        severity="error"
        size="small"
        variant="simple"
      >
        {{ $form.albumName.error.message }}
      </Message>

      <!-- Genre -->
      <div class="flex flex-col gap-1 mt-3">
        <InputLabel class="text-gray-400">Genre</InputLabel>
        <Select
          name="genre"
          :options="GENRE_OPTIONS"
          optionLabel="name"
          optionValue="value"
          fluid
        />

        <Message
          v-if="$form.genre?.invalid"
          severity="error"
          size="small"
          variant="simple"
          >{{ $form.gener?.error?.message }}</Message
        >
      </div>
    </div>

    <!-- Submit Button -->
    <Button type="submit" severity="success" label="Submit" />
  </Form>
</template>
