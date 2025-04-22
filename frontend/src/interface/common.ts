export interface Meta {
  currentPage: number;
  totalPages: number;
  totalCount: number;
}

export interface HeaderItem {
  label: string;
  to: string;
}

export type Primitive = string | number | boolean | null;

export type ChangeLogUpdate = Record<string, [Primitive, Primitive]>;
