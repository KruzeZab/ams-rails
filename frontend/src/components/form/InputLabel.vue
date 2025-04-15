<script setup lang="ts">
defineOptions({
  inheritAttrs: false,
});
</script>

<template>
  <label v-bind="$attrs">
    <slot />
  </label>
</template>
