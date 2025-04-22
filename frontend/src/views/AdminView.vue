<script setup lang="ts">
import { onMounted, reactive } from 'vue';

import { formatDate } from '@/utils/date';
import { fetchActivityLogs } from '@/utils/fetch';

import { ActionLog, type ActivityLog } from '@/interface/log';

interface LogsState {
  isLoading: boolean;
  logs: ActivityLog[];
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
    <h2 class="text-2xl font-bold mb-6">Action Alerts</h2>

    <Accordion :value="[]">
      <AccordionPanel
        v-for="log in logsState.logs"
        :key="log.id"
        :value="String(log.id)"
      >
        <AccordionHeader class="text-white">
          <!-- CREATE -->
          <div
            v-if="log.action === ActionLog.CREATE"
            class="flex items-center gap-2"
          >
            <span class="w-2 h-2 rounded-full bg-green-500" />
            <span class="capitalize">{{ log.recordType }}</span> was created by
            <strong>{{ log.user?.email ?? 'Guest' }}</strong>
            <Tag severity="success" value="Create" />
            <i class="text-xs text-gray-500 block">{{
              formatDate(log.createdAt)
            }}</i>
          </div>

          <!-- UPDATE -->
          <div
            v-else-if="log.action === ActionLog.UPDATE"
            class="flex justify-between items-center gap-2"
          >
            <span class="w-2 h-2 rounded-full bg-blue-500" />
            <span class="capitalize">{{ log.recordType }}</span> was updated by
            <strong>{{ log.user?.email ?? 'Guest' }}</strong>
            <Tag severity="info" value="Update" />

            <i class="text-xs text-gray-500 block">{{
              formatDate(log.createdAt)
            }}</i>
          </div>

          <!-- DELETE -->
          <div
            v-else-if="log.action === ActionLog.DELETE"
            class="flex items-center gap-2"
          >
            <span class="w-2 h-2 rounded-full bg-red-500" />
            <span class="capitalize">{{ log.recordType }}</span> with ID
            <strong>{{ log.recordId }}</strong> was deleted by
            <strong>{{ log.user?.email ?? 'Guest' }}</strong>
            <Tag severity="danger" value="Delete" />
            <i class="text-xs text-gray-500 block">{{
              formatDate(log.createdAt)
            }}</i>
          </div>
        </AccordionHeader>

        <AccordionContent>
          <pre class="text-xs rounded p-3 overflow-auto bg-gray-900"
            >{{ JSON.stringify(log.changeLog, null, 2) }}
          </pre>
        </AccordionContent>
      </AccordionPanel>
    </Accordion>
  </div>
</template>
