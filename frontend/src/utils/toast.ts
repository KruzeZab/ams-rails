import type { ToastServiceMethods } from 'primevue';

import { TOAST_DURATION } from '@/constants/common';

export const successToast = (
  toast: ToastServiceMethods,
  summary: string,
  detail: string,
  life = TOAST_DURATION,
) => {
  toast.add({
    severity: 'success',
    summary,
    detail,
    life,
  });
};

export const errorToast = (
  toast: ToastServiceMethods,
  summary: string,
  detail: string,
  life = TOAST_DURATION,
) => {
  toast.add({
    severity: 'error',
    summary,
    detail,
    life,
  });
};

export const infoToast = (
  toast: ToastServiceMethods,
  summary: string,
  detail: string,
  life = TOAST_DURATION,
) => {
  toast.add({
    severity: 'info',
    summary,
    detail,
    life,
  });
};

export const warnToast = (
  toast: ToastServiceMethods,
  summary: string,
  detail: string,
  life = TOAST_DURATION,
) => {
  toast.add({
    severity: 'warn',
    summary,
    detail,
    life,
  });
};
