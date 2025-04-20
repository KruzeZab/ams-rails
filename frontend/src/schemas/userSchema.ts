import * as z from 'zod';

import { isArtist } from '@/utils/user';

import { Role, type ArtistZodInput } from '@/interface/user';

export const loginSchema = z.object({
  email: z.string().email({ message: 'Invalid email address.' }),
  password: z.string().nonempty({ message: 'Password is required.' }),
});

const userSchema = z.object({
  firstName: z.string().min(2, { message: 'Must be at least 2 characters.' }),
  lastName: z.string().min(2, { message: 'Must be at least 2 characters.' }),
  email: z.string().email({ message: 'Invalid email address.' }),
  phone: z.string().refine((val) => /^\+?\d+$/.test(val), {
    message: 'Invalid phone number.',
  }),
  gender: z
    .string()
    .length(1, { message: 'Gender must be a single character' })
    .nonempty({ message: 'Gender is required' }),
  address: z.string().nonempty({ message: 'Address is required' }),
  dob: z.string().refine(
    (val) => {
      const date = new Date(val);
      if (isNaN(date.getTime())) return false;

      const today = new Date();
      const ageDiff = today.getFullYear() - date.getFullYear();
      const monthDiff = today.getMonth() - date.getMonth();
      const dayDiff = today.getDate() - date.getDate();

      const is18OrOlder =
        ageDiff > 18 ||
        (ageDiff === 18 &&
          (monthDiff > 0 || (monthDiff === 0 && dayDiff >= 0)));

      return is18OrOlder;
    },
    {
      message: 'Must be at least 18 years old',
    },
  ),
});

const artistRefinement = (data: ArtistZodInput, ctx: z.RefinementCtx) => {
  console.log(data.role);
  if (isArtist(data.role)) {
    if (!data.numberOfAlbumsReleased || data.numberOfAlbumsReleased < 0) {
      ctx.addIssue({
        path: ['numberOfAlbumsReleased'],
        message: 'Invalid number',
        code: z.ZodIssueCode.custom,
      });
    }

    if (
      !data.firstReleaseYear ||
      data.firstReleaseYear < 1600 ||
      data.firstReleaseYear > new Date().getFullYear()
    ) {
      ctx.addIssue({
        path: ['firstReleaseYear'],
        message:
          'First release year must be greater than or equal to 1600 and less than or equal to the current year',
        code: z.ZodIssueCode.custom,
      });
    }
  }
};

export const signupSchema = userSchema
  .extend({
    password: z
      .string()
      .min(6, { message: 'Password must be at least 6 characters.' }),
    role: z.enum([Role.SUPER_ADMIN, Role.ARTIST_MANAGER, Role.ARTIST], {
      required_error: 'Role is required',
      invalid_type_error: 'Invalid role',
    }),
    numberOfAlbumsReleased: z.coerce
      .number({
        invalid_type_error: 'Must be a number',
      })
      .min(0, {
        message: 'Must be greater than or equal to 0',
      })
      .optional(),
    firstReleaseYear: z.coerce
      .number({
        invalid_type_error: 'Must be a number',
      })
      .min(1600, {
        message: 'First release year must be greater than or equal to 1600',
      })
      .max(new Date().getFullYear(), {
        message:
          'First release year must be less than or equal to the current year',
      })
      .optional(),
  })
  .superRefine(artistRefinement);

export const updateUserSchema = userSchema
  .extend({
    role: z.enum([Role.ARTIST_MANAGER, Role.ARTIST], {
      required_error: 'Role is required',
      invalid_type_error: 'Invalid role',
    }),
    numberOfAlbumsReleased: z.coerce
      .number({
        invalid_type_error: 'Must be a number',
      })
      .min(0, {
        message: 'Must be greater than or equal to 0',
      })
      .optional(),
    firstReleaseYear: z.coerce
      .number({
        invalid_type_error: 'Must be a number',
      })
      .min(1600, {
        message: 'First release year must be greater than or equal to 1600',
      })
      .max(new Date().getFullYear(), {
        message:
          'First release year must be less than or equal to the current year',
      })
      .optional(),
  })
  .superRefine(artistRefinement);
