import { z } from 'zod';
import { zodResolver } from '@primevue/forms/resolvers/zod';

export const songSchema = zodResolver(
  z.object({
    title: z.string().nonempty({ message: 'Title is required' }),
    albumName: z.string().nonempty({ message: 'Album name is required' }),
    genre: z.string().nonempty({ message: 'Genre is required' }),
  }),
);
