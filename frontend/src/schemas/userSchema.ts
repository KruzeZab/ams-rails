import * as z from 'zod';
import { zodResolver } from '@primevue/forms/resolvers/zod';

export const signupSchema = zodResolver(
  z.object({
    firstName: z.string().min(2, { message: 'Must be at least 2 characters.' }),
    lastName: z.string().min(2, { message: 'Must be at least 2 characters.' }),
    email: z.string().email({ message: 'Invalid email address.' }),
    password: z
      .string()
      .min(6, { message: 'Password must be at least 6 characters.' }),
    phone: z.string().refine((val) => /^\+?\d+$/.test(val), {
      message: 'Invalid phone number.',
    }),
    address: z.string().nonempty({ message: 'Address is required' }),
    dob: z.string().refine(
      (val) => {
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(val)) {
          return false;
        }

        const date = new Date(val);
        return !isNaN(date.getTime());
      },
      {
        message: 'Invalid DOB',
      },
    ),
  }),
);

export const loginSchema = zodResolver(
  z.object({
    email: z.string().email({ message: 'Invalid email address.' }),
    password: z.string().nonempty({ message: 'Password is required.' }),
  }),
);
