<script setup lang="ts">
import { onMounted, reactive } from 'vue';

import { fetchActivityLogs } from '@/utils/fetch';

interface LogsState {
  isLoading: boolean;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  logs: any;
}

const logsState = reactive<LogsState>({
  isLoading: false,
  logs: [],
});

onMounted(async () => {
  const { data } = await fetchActivityLogs();

  logsState.logs = data;
});
</script>

<template>
  <div class="mt-6 container mx-auto">
    <h2 class="text-2xl font-bold mb-4">Action Alerts</h2>

    <div
      v-for="log in logsState.logs"
      :key="log.id"
      class="mb-4 p-4 border rounded-xl shadow-sm bg-white"
    >
      <div class="text-sm text-gray-400 mb-1">
        {{ new Date(log.createdAt).toLocaleString() }}
      </div>

      <div v-if="log.action === 'create'">
        <p class="text-green-700 font-medium">
          New <span class="capitalize">{{ log.recordType }}</span> created with
          values:
          <span v-for="(value, key, idx) in log.changeLog" :key="key">
            <span class="font-semibold capitalize">{{ key }}</span
            >: {{ value
            }}<span v-if="idx < Object.keys(log.changeLog).length - 1">, </span>
          </span>
          by {{ log.user ? log.user.email : 'guest' }}.
        </p>
      </div>

      <div v-else-if="log.action === 'update'">
        <p class="text-yellow-700 font-medium">
          <span class="capitalize">{{ log.recordType }}</span> updated by
          {{ log.user ? log.user.email : 'guest' }}:
        </p>
        <ul class="ml-4 list-disc text-sm text-gray-800">
          <li v-for="(change, key) in log.changeLog" :key="key">
            <span class="capitalize font-semibold">{{ key }}</span
            >: from <span class="text-red-600">{{ change[0] }}</span> to
            <span class="text-green-600">{{ change[1] }}</span>
          </li>
        </ul>
      </div>

      <div v-else-if="log.action === 'delete'">
        <p class="text-red-700 font-medium">
          <span class="capitalize">{{ log.recordType }}</span> with ID
          {{ log.recordId }} was deleted by
          {{ log.user ? log.user.email : 'guest' }}.
        </p>
      </div>
    </div>
  </div>
</template>
