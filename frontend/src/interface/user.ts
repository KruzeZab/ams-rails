import type { OptionType } from '@/interface/common';

export enum Role {
  SUPER_ADMIN = 'super_admin',
  ARTIST_MANAGER = 'artist_manager',
  ARTIST = 'artist',
}

export enum Gender {
  MALE = 'm',
  FEMALE = 'f',
  OTHERS = 'o',
}

export interface SignupValues {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  gender: OptionType<Gender>;
  phone: string;
  dob: string;
  address: string;
  role: null | Role;
}

export interface LoginValues {
  email: string;
  password: string;
}

export interface UserResponse {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  gender: Gender;
  dob: string;
  address: string;
  role: Role;
}
