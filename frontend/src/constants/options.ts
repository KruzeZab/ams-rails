import { Genre } from '@/interface/song';
import { Gender, Role } from '@/interface/user';

export const GENDER_OPTIONS = [
  {
    name: 'Male',
    value: Gender.MALE,
  },
  {
    name: 'Female',
    value: Gender.FEMALE,
  },
  {
    name: 'Others',
    value: Gender.OTHERS,
  },
];

export const ROLE_OPTIONS = [
  {
    name: 'Artist Manager',
    value: Role.ARTIST_MANAGER,
  },
  {
    name: 'Artist',
    value: Role.ARTIST,
  },
];

export const GENRE_OPTIONS = [
  {
    name: 'Classic',
    value: Genre.CLASSIC,
  },
  {
    name: 'Country',
    value: Genre.COUNTRY,
  },
  {
    name: 'Jazz',
    value: Genre.JAZZ,
  },
  {
    name: 'RNB',
    value: Genre.RNB,
  },
  {
    name: 'Rock',
    value: Genre.ROCK,
  },
];

export const DEFAULT_GENDER_INDEX = 0;
export const DEFAULT_GENRE_OPTIONS = 0;
